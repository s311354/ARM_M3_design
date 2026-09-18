#include <stdint.h>
#include <stdio.h>

#include "CM3DS_MPS2.h"
#include "uart_stdout.h"

#define REG32(addr) (* (volatile uint32_t *)(addr))

#define PCIE_HOST_BASE          0xA0000000UL
#define PCIE_MMIO_BASE          0x60000000UL

#define PCIE_VERSION            REG32(PCIE_HOST_BASE + 0x000U)
#define PCIE_CONTROL            REG32(PCIE_HOST_BASE + 0x004U)
#define PCIE_STATUS             REG32(PCIE_HOST_BASE + 0x008U)
#define PCIE_CFG_BDF            REG32(PCIE_HOST_BASE + 0x010U)
#define PCIE_CFG_REG            REG32(PCIE_HOST_BASE + 0x014U)
#define PCIE_CFG_WDATA          REG32(PCIE_HOST_BASE + 0x018U)
#define PCIE_CFG_RDATA          REG32(PCIE_HOST_BASE + 0x01CU)
#define PCIE_CFG_COMMAND        REG32(PCIE_HOST_BASE + 0x020U)
#define PCIE_ERROR_STATUS       REG32(PCIE_HOST_BASE + 0x024U)

#define PCIE_CONTROL_ENABLE     (1UL << 0)
#define PCIE_STATUS_DONE        (1UL << 1)
#define PCIE_STATUS_ERROR       (1UL << 2)

#define PCIE_CMD_CFG_READ       (1UL)
#define PCIE_CMD_CFG_WRITE      (2UL)

#define PCIE_COMMAND_MEMORY     (1UL << 1)

#define ENDPOINT_BDF            0x00000800UL

#define POLL_LIMIT              100000U

#define SCRATCH_OFFSET          0x1000UL

#define TEST_VALUE              0xA5A55A5AUL

static int wait_completion(void) {
    for (unsigned int count = 0U; count < POLL_LIMIT; ++count) {
        uint32_t status = PCIE_STATUS;

	if ((status & PCIE_STATUS_DONE) == 0U)
            continue;

	if ((status & PCIE_STATUS_ERROR) != 0U)
            return -1;

	return 0;
    }

    return -2;
}

static int cfg_read32(uint32_t reg, uint32_t *value) {
    PCIE_CFG_BDF = ENDPOINT_BDF;

    PCIE_CFG_REG = reg;

    PCIE_CFG_COMMAND = PCIE_CMD_CFG_READ;

    if (wait_completion() != 0)
	return -1;

    *value = PCIE_CFG_RDATA;

    return 0;
}

static int cfg_write32(uint32_t reg, uint32_t value) {
    PCIE_CFG_BDF = ENDPOINT_BDF;

    PCIE_CFG_REG = reg;

    PCIE_CFG_WDATA = value;

    PCIE_CFG_COMMAND = PCIE_CMD_CFG_WRITE;

    return wait_completion();
}

int main(void) {
    uint32_t value;

    volatile uint32_t *scratch = (volatile uint32_t *) (PCIE_MMIO_BASE + SCRATCH_OFFSET);

    UartStdOutInit();

    printf("LabH3 PCIe MMIO full-system test\n");

    /* Stage 1. TARGEXP0 reachability */
    if (PCIE_VERSION != 0x00010000UL)
	goto failed;

    PCIE_CONTROL = PCIE_CONTROL_ENABLE;

    /* Stage 2. Configuration Read */
    if (cfg_read32(0x000U, &value) != 0)
	goto failed;

    if (value != 0x56781234UL)
	goto failed;

    printf("CFG_READ PASS: %08lx", (unsigned long) value);

    /* Stage 3. BAR0 probe */
    if (cfg_write32(0x010U, 0xFFFFFFFFUL) != 0)
	goto failed;

    if (cfg_read32(0x010U, &value) != 0)
	goto failed;

    if (value != 0xFFFF0000UL)
	goto failed;

    /* Stage 4. Program BAR0 */
    if (cfg_write32(0x010U, PCIE_MMIO_BASE) != 0)
        goto failed;

    /* Stage 5. Enable Memory Space */
    if (cfg_write32(0x004U, PCIE_COMMAND_MEMORY) != 0)
	goto failed;

    /* Stage 6. CPU STORE -> TARGEXP1 -> PCIe MEM_WRITE */
    *scratch = TEST_VALUE;

    __DSB();

    /* Stage 7. CPU LOAD -> TARGEXP1 -> PCIe MEM_READ -> Completion -> HRDATA */
    value = *scratch;

    if (value != TEST_VALUE)
	goto failed;

    printf("MMIO READBACK PASS: %08lx\n", (unsigned long) value);

    printf("LABH3 PCIe HOST PASS\n");

    printf("** TEST PASSED **\n");

    UartEndSimulation();

    return 0;

failed:
    printf("STATUS=%08lx ERROR=%08lx\n", (unsigned long) PCIE_STATUS, (unsigned long) PCIE_ERROR_STATUS);

    printf("LABH3 PCIe HOST FAIL\n");

    printf("** LABH3 FAILED **");

    UartEndSimulation();

    return 1;
}
