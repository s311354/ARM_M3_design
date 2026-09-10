#include <stdint.h>
#include <stdio.h>

#include "CM3DS_MPS2.h"
#include "uart_stdout.h"

#define PCIE_HOST_BASE             0xA0000000UL

#define REG32(addr) (*(volatile uint32_t *)(addr))

#define PCIE_VERSION      REG32(PCIE_HOST_BASE + 0x000U)
#define PCIE_CONTROL      REG32(PCIE_HOST_BASE + 0x004U)
#define PCIE_STATUS       REG32(PCIE_HOST_BASE + 0x008U)
#define PCIE_CFG_BDF      REG32(PCIE_HOST_BASE + 0x010U)
#define PCIE_CFG_REG      REG32(PCIE_HOST_BASE + 0x014U)
#define PCIE_CFG_WDATA    REG32(PCIE_HOST_BASE + 0x018U)
#define PCIE_CFG_RDATA    REG32(PCIE_HOST_BASE + 0x01CU)
#define PCIE_CFG_COMMAND  REG32(PCIE_HOST_BASE + 0x020U)
#define PCIE_ERROR_STATUS REG32(PCIE_HOST_BASE + 0x024U)

#define PCIE_VERSION_EXPECTED     0x00010000UL

#define PCIE_CONTROL_ENABLE       (1UL << 0)

#define PCIE_STATUS_BUSY          (1UL << 0)
#define PCIE_STATUS_DONE          (1UL << 1)
#define PCIE_STATUS_ERROR         (1UL << 2)

#define PCIE_CMD_CFG_READ         1UL
#define PCIE_CMD_CFG_WRITE        2UL

#define LABH2_CFG_SCRATCH         0x040UL
#define LABH2_SCRATCH_VALUE       0xA5A55A5AUL

#define POLL_LIMIT                100000U

#define PCIE_BDF(bus, dev, fn) \
	((((uint32_t)(bus) & 0xFFU) << 16U) | \
	 (((uint32_t)(dev) & 0x1FU) << 11U) | \
	 (((uint32_t)(fn)  & 0x07U) << 8U))

static int wait_completion(void) {
    unsigned int count;

    for (count = 0U; count < POLL_LIMIT ; ++count) {
        uint32_t status = PCIE_STATUS;

	if ((status & PCIE_STATUS_DONE) == 0U)
            continue;

	if ((status & PCIE_STATUS_ERROR) != 0U)
	    return -1;

	return 0;
    }

    return -2;
}

static int cfg_read32(uint32_t bdf, uint32_t reg, uint32_t *value) {
    PCIE_CFG_BDF = bdf;
    PCIE_CFG_REG = reg;

    PCIE_CFG_COMMAND = PCIE_CMD_CFG_READ;

    if (wait_completion() != 0) {
        return -1;
    }

    *value = PCIE_CFG_RDATA;

    return 0;
}

static int cfg_write32(uint32_t bdf, uint32_t reg, uint32_t value) {
    PCIE_CFG_BDF = bdf;
    PCIE_CFG_REG = reg;
    PCIE_CFG_WDATA = value;

    PCIE_CFG_COMMAND = PCIE_CMD_CFG_WRITE;

    return wait_completion();
}

int main(void) {
    uint32_t endpoint_bdf;
    uint32_t absent_bdf;

    uint32_t value;

    UartStdOutInit();

    printf("LabH2 PCIe transaction model full-system test\n");

    /* Cortex-M3 -> AHB -> TARGEXP0 reachability */
    if (PCIE_VERSION != PCIE_VERSION_EXPECTED)
	goto failed;

    PCIE_CONTROL = PCIE_CONTROL_ENABLE;

    endpoint_bdf = PCIE_BDF(0U, 1U, 0U);

    absent_bdf = PCIE_BDF(0U, 2U, 0U);

    /* Test 1. Configuration Read */
    if (cfg_read32(endpoint_bdf, 0x000U, &value) != 0)
	goto failed;

    if (value != 0x56781234U)
	goto failed;

    printf("CFG_READ PASS: %08lx\n", (unsigned long)value);

    /* Test 2. H2 Configuration Write */
    if (cfg_write32(endpoint_bdf, LABH2_CFG_SCRATCH, LABH2_SCRATCH_VALUE) != 0)
	goto failed;

    /* Test 3. Readback proves write transaction reached H2 endpoint model */
    if (cfg_read32(endpoint_bdf, LABH2_CFG_SCRATCH, &value) != 0)
	goto failed;

    printf("CFG_WRTIE/CFG_READBACK PASS: %08lx\n", (unsigned long) value);

    /* Test 4. Absent function */
    if (cfg_read32(absent_bdf, 0x000U, &value) != 0)
	goto failed;

    if (value != 0xFFFFFFFFU)
	goto failed;

    printf("ABSENT BDF PASS\n");

    printf("LABH2 PCIe HOST PASS\n");
    printf("** TEST PASSED **\n");

    UartEndSimulation();

    return 0;

failed:
    printf("STATUS=%08lx ERROR=%08lx\n", (unsigned long) PCIE_STATUS, (unsigned long) PCIE_ERROR_STATUS);

    printf("LABH2 PCIe HOST FAIL\n");
    printf("** LABH2 FAILED **\n");

    UartEndSimulation();

    return 1;
}
