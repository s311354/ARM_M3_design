#include <stdint.h>
#include <stdio.h>

#include "CM3DS_MPS2.h"
#include "uart_stdout.h"

#define PCIE_HOST_BASE           0xA0000000UL

#define REG32(addr) \
	(*(volatile unsigned int *)(addr))

#define PCIE_VERSION             REG32(PCIE_HOST_BASE + 0x000U)
#define PCIE_CONTROL             REG32(PCIE_HOST_BASE + 0x004U)
#define PCIE_STATUS              REG32(PCIE_HOST_BASE + 0x008U)

#define PCIE_CFG_BDF             REG32(PCIE_HOST_BASE + 0x010U)
#define PCIE_CFG_REG             REG32(PCIE_HOST_BASE + 0x014U)
#define PCIE_CFG_WDATA           REG32(PCIE_HOST_BASE + 0x018U)
#define PCIE_CFG_RDATA           REG32(PCIE_HOST_BASE + 0x01CU)
#define PCIE_CFG_COMMAND         REG32(PCIE_HOST_BASE + 0x020U)
#define PCIE_ERROR_STATUS        REG32(PCIE_HOST_BASE + 0x024U)

#define PCIE_VERSION_EXPECTED    0x00010000UL

#define PCIE_CONTROL_ENABLE      (1UL << 0)

#define PCIE_STATUS_BUSY         (1UL << 0)
#define PCIE_STATUS_DONE         (1UL << 1)
#define PCIE_STATUS_ERROR        (1UL << 2)

#define PCIE_CMD_CFG_READ        1UL

#define PCIE_BDF(bus, dev, fn) \
	((((uint32_t)(bus) & 0xFFU) << 16U) | \
	 (((uint32_t)(dev) & 0x1FU) << 11U) | \
	 (((uint32_t)(fn)  & 0x07U) << 8U))

#define POLL_LIMIT              100000U

static int wait_for_completion(void) {
    unsigned int count;

    for (count = 0U; count < POLL_LIMIT; ++count) {
        uint32_t status = PCIE_STATUS;

	if ((status & PCIE_STATUS_DONE) == 0U)
            continue;

	if ((status & PCIE_STATUS_ERROR) != 0U)
	    return -1;

	return 0;
    }

    return -2;
}

int main(void) {
    uint32_t id;
    uint32_t bdf;

    uint16_t vendor;
    uint16_t device;

    int result;

    UartStdOutInit();

    printf("LabH1 PCIe Host integration test\n");

    /*
     * Stage 1: prove Cortex-M3 can reach TARGEXP0 PCIe CSR block.
     */
    if (PCIE_VERSION != PCIE_VERSION_EXPECTED) {
        printf("VERSION FAIL: %08lx\n", (unsigned long)PCIE_VERSION);

	goto failed;
    }

    /*
     * Enable host bridge
     */
    PCIE_CONTROL = PCIE_CONTROL_ENABLE;

    /*
     * Endpoint 00:01.0
     */
    bdf = PCIE_BDF(0U,1U,0U);

    PCIE_CFG_BDF = bdf;

    /*
     * Configuration DWORD 0: vendor/ device id
     */
    PCIE_CFG_REG = 0U;

    /*
     * Doorbell
     */
    PCIE_CFG_COMMAND = PCIE_CMD_CFG_READ;

    result = wait_for_completion();

    if (result != 0) {
        printf("CFG_READ FAIL: result=%d status=%08lx error=%08lx\n", \
    		    result, (unsigned long)PCIE_STATUS, (unsigned long) PCIE_ERROR_STATUS);

        goto failed;
    }

    id = PCIE_CFG_RDATA;

    vendor = (uint16_t) (id & 0xFFFFU);
    device = (uint16_t) (id >> 16U);

    printf("BDF             = %08lx\n", (unsigned long) bdf);
    printf("ID              = %08lx\n", (unsigned long) id);
    printf("Vendor          = %04x\n", vendor);
    printf("Device          = %04x\n", device);

    /*
     * LabH1 fake backend golden endpoint.
     */
    if ((vendor != 0x1234U) || (device != 0x5678U)) {
    	goto failed;
    }

    printf("LABH1 PCIe HOST PASS\n");
    printf("** TEST PASSED **\n");

    UartEndSimulation();

    return 0;

ed:
    printf("LABH1 PCIe HOST FAIL\n");
    printf("** TEST FAILED **\n");

    UartEndSimulation();

    return 1;
}
