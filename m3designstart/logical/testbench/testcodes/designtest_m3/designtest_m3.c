/*
 *-----------------------------------------------------------------------------
 * The confidential and proprietary information contained in this file may
 * only be used by a person authorised under and to the extent permitted
 * by a subsisting licensing agreement from ARM Limited.
 *
 *            (C) COPYRIGHT 2017 ARM Limited or its affiliates.
 *                ALL RIGHTS RESERVED
 *
 * This entire notice must be reproduced on all copies of this file
 * and copies of this file may only be made by a person if such person is
 * permitted to do so under the terms of a subsisting license agreement
 * from ARM Limited.
 *
 *      SVN Information
 *
 *      Checked In          : $$
 *
 *      Revision            : $$
 *
 *      Release Information : CM3DesignStart-r0p0-02rel0
 *-----------------------------------------------------------------------------
 */

#include "CM3DS_MPS2.h"
#include <stdio.h>
#include "designtest_m3.h"
#include "uart_stdout.h"
#include "CM3DS_MPS2_driver.h"

#if defined ( __CC_ARM   )
__asm unsigned int  memcpy_LDM_STM(unsigned int to, unsigned int* from, unsigned int size);
#else
      unsigned int  memcpy_LDM_STM(unsigned int to, unsigned int* from, unsigned int size);
#endif

unsigned int burst_test(unsigned int base, unsigned int offset, unsigned int range)
{
  unsigned int addr;
  unsigned int din;
  unsigned int address_start;
  unsigned int address_end;
  unsigned int* testvalues_ptr;
  int status;
  int cycles;
  unsigned int result;
  unsigned int testvalues[] = {0x12345678,0xa5a5a5a5,0x00000000,0xFFFFFFFF,0x01011010,0x02022020,0x03033030,0x04044040};
  result=PASS;
  address_start = (base+offset);
  address_end   = (address_start+range);
  testvalues_ptr = testvalues;
  printf("Start address 0x%08X\n",address_start);
  printf("End address   0x%08X ignored\n",address_end);

  // (To memory address, From array of test values, Copy size)
  result += memcpy_LDM_STM( address_start, testvalues_ptr, 8);
  //Check data
  status = PASS;
  cycles = 0;
  address_end = (address_start+(8*4)); // Burst test limits range
  for(addr = address_start; addr < address_end; addr = addr + 4)
  {
    din = *((volatile unsigned int *)addr);
    // Check and display errors
    if (din != testvalues[cycles])
    {
      status++;
    }
    cycles++;
    }
  //Report status
  if (status == PASS)
  {
    printf("Pass %d locations tested\n",cycles);
  } else {
    printf("Fail %d errors of %d locations\n",status,cycles);
    result++;
  }
  return(result);
}
unsigned int test(unsigned int base, unsigned int offset, unsigned int range)
{
  unsigned int ii;
  unsigned int dout;
  unsigned int din;
  unsigned int address_start;
  unsigned int address_end;
  unsigned int data;
  int status;
  int cycles;
  unsigned int result;
  unsigned int addrvalues[4];

  addrvalues[0] = base;
  addrvalues[1] = base+range/2-4;
  addrvalues[2] = base+range/2;
  addrvalues[3] = base+range-4;
  data=0;
  result=PASS;
  address_start = (base+offset);
  address_end   = (address_start+range);
  printf("Start address 0x%08X\n",address_start);
  printf("End address   0x%08X\n",address_end);
  //Write data
  for(ii = 0; ii < 4; ii = ii + 1)
  {
    data = data + 0x200211 * addrvalues[ii];
    dout = data;
    *((volatile unsigned int *)addrvalues[ii]) = dout;
  }
  //Check data
  status = PASS;
  cycles = 0;
  data = 0;
  for(ii = 0; ii < 4; ii = ii + 1)
  {
    data = data + 0x200211 * addrvalues[ii];
    dout = data;
    din = *((volatile unsigned int *)addrvalues[ii]);
    cycles++;
    // Check and display errors
    if (din != dout)
    {
      status++;
      printf("written = %x, read = %x\n", dout, din);
    }
  }
  //Report status
  if (status == PASS)
  {
    printf("Pass %d locations tested\n",cycles);
  } else {
    printf("Fail %d errors of %d locations\n",status,cycles);
    result++;
  }
  return(result);
}

unsigned int test_fpgareg(unsigned int base)
{
  unsigned int counter_start;
  unsigned int result;

#ifndef FPGA_IMAGE
  // Used for Button & LED test only
  int loopcounter;
#endif

  result=PASS;
  counter_start = CM3DS_MPS2_FPGASYS->COUNTCYC;
  printf("Base address 0x%08X\n",base);
  printf("Remap 0x%08X\n",*((volatile unsigned int *)CM3DS_MPS2_SYSCTRL_BASE));
  printf("Timer 0 ID 0x%08X\n",*((volatile unsigned int *)(CM3DS_MPS2_TIMER0_BASE + 0x0FE0)));
  printf("Timer 0 0x%08X\n",*((volatile unsigned int *)(CM3DS_MPS2_TIMER0_BASE + 0x0000)));
  printf("Writing 0x55\n");
  *((volatile unsigned int *)(CM3DS_MPS2_TIMER0_BASE + 0x0000)) = 0x55;
  printf("Timer 0 0x%08X\n",*((volatile unsigned int *)(CM3DS_MPS2_TIMER0_BASE + 0x0000)));
  printf("Timer 1 0x%08X\n",*((volatile unsigned int *)(CM3DS_MPS2_TIMER1_BASE + 0x0000)));
  printf("Counter 1Hz 0x%08X, 100Hz 0x%08X, Cycleup 0x%08X\n",
         CM3DS_MPS2_FPGASYS->COUNT1HZ,
         CM3DS_MPS2_FPGASYS->CNT100HZ,
         CM3DS_MPS2_FPGASYS->COUNTCYC);

  printf("EXT bus [15:0] = 0x%08X\n", CM3DS_MPS2_GPIO0->DATA);
  if (CM3DS_MPS2_GPIO0->DATA != 0x0000FFFF)
  {
    printf("Fail\n");
    result++;
  }
  printf("EXT bus [31:16] = 0x%08X\n", CM3DS_MPS2_GPIO1->DATA);
  if (CM3DS_MPS2_GPIO1->DATA != 0x0000FFFF)
  {
    printf("Fail\n");
    result++;
  }
  printf("EXT bus [47:32] = 0x%08X\n", CM3DS_MPS2_GPIO2->DATA);
  if (CM3DS_MPS2_GPIO2->DATA != 0x0000FFFF)
  {
    printf("Fail\n");
    result++;
  }
  printf("EXT bus [51:48] = 0x%08X\n", CM3DS_MPS2_GPIO3->DATA);
  if (CM3DS_MPS2_GPIO3->DATA != 0x0000000F)
  {
    printf("Fail\n");
    result++;
  }

  printf("Zeroing bus (not yet enabled)\n");

  CM3DS_MPS2_GPIO0->DATAOUT = 0x0;
  CM3DS_MPS2_GPIO1->DATAOUT = 0x0;
  CM3DS_MPS2_GPIO2->DATAOUT = 0x0;
  CM3DS_MPS2_GPIO3->DATAOUT = 0x0;

  printf("EXT bus [15:0] = 0x%08X\n",CM3DS_MPS2_GPIO0->DATA);
  printf("EXT bus [31:16] = 0x%08X\n",CM3DS_MPS2_GPIO1->DATA);
  printf("EXT bus [47:32] = 0x%08X\n",CM3DS_MPS2_GPIO2->DATA);
  printf("EXT bus [51:48] = 0x%08X\n",CM3DS_MPS2_GPIO3->DATA);


  CM3DS_MPS2_GPIO0->OUTENABLESET = 0x7FFE;
  CM3DS_MPS2_GPIO1->OUTENABLESET = 0xFB7F;
  CM3DS_MPS2_GPIO2->OUTENABLESET = 0xFDFF;
  CM3DS_MPS2_GPIO3->OUTENABLESET = 0x000F;
  printf("Enabled bus drive\n");

  printf("EXT bus [15:0] = 0x%08X\n",CM3DS_MPS2_GPIO0->DATA);
  if ((CM3DS_MPS2_GPIO0->DATA & CM3DS_MPS2_GPIO0->OUTENABLESET) == 0x0)
  {
    printf("Pass\n");
  } else {
    printf("Fail\n");
    result++;
  }

  printf("EXT bus [31:16] = 0x%08X\n",CM3DS_MPS2_GPIO1->DATA);
  if ((CM3DS_MPS2_GPIO1->DATA & CM3DS_MPS2_GPIO1->OUTENABLESET) == 0x0)
  {
    printf("Pass\n");
  } else {
    printf("Fail\n");
    result++;
  }

  printf("EXT bus [47:32] = 0x%08X\n",CM3DS_MPS2_GPIO2->DATA);
  if ((CM3DS_MPS2_GPIO2->DATA & CM3DS_MPS2_GPIO2->OUTENABLESET) == 0x0)
  {
    printf("Pass\n");
  } else {
    printf("Fail\n");
    result++;
  }

  printf("EXT bus [51:48] = 0x%08X\n",CM3DS_MPS2_GPIO3->DATA);

  if ((CM3DS_MPS2_GPIO3->DATA & CM3DS_MPS2_GPIO3->OUTENABLESET) == 0x0)
  {
    printf("Pass\n");
  } else {
    printf("Fail\n");
    result++;
  }

#ifndef FPGA_IMAGE
  // On testbench only, buttons are looped back to LEDs.
  // This test will not work on MPS2 board
  printf("LEDs and buttons - Buttons are looped back from LEDs.\n");
  for (loopcounter = 0; loopcounter < 4; loopcounter = loopcounter + 1)
  {
    printf("Setting LEDs to 0x%08X\n",loopcounter);

    CM3DS_MPS2_FPGASYS->LEDS = loopcounter;

    printf("Buttons = 0x%08X\n",CM3DS_MPS2_FPGASYS->BUTTONS);
      if (CM3DS_MPS2_FPGASYS->BUTTONS == loopcounter)
    {
      printf("Pass\n");
    } else {
      printf("Fail\n");
      result++;
    }
  }

#endif

  printf("Counter 1Hz 0x%08X, 100Hz 0x%08X, Cycleup 0x%08X\n",
         CM3DS_MPS2_FPGASYS->COUNT1HZ,
         CM3DS_MPS2_FPGASYS->CNT100HZ,
         CM3DS_MPS2_FPGASYS->COUNTCYC);
  printf("Checking Cycleup counter is counting - ");
  if (counter_start != CM3DS_MPS2_FPGASYS->COUNTCYC)
    {
    printf("Pass\n");
  } else {
    printf("Fail\n");
    result++;
  }
  return(result);
}

unsigned int test_scc(unsigned int base)
{
  unsigned int result;
  result=PASS;
  printf("Base address 0x%08X\n",base);
  printf("DLLLOCK     0x%08X\n",CM3DS_MPS2_SCC->SCC_DLLLOCK);
  printf("SCC_LED     0x%08X\n",CM3DS_MPS2_SCC->SCC_LED    );
  printf("SCC_SW      0x%08X\n",CM3DS_MPS2_SCC->SCC_SW     );
  printf("SCC_APBLOCK 0x%08X\n",CM3DS_MPS2_SCC->SCC_APBLOCK);
  printf("SCC_AID     0x%08X\n",CM3DS_MPS2_SCC->SCC_AID    );
  printf("SCC_ID      0x%08X\n",CM3DS_MPS2_SCC->SCC_ID     );
  printf("SYS_CFGDATA_SERIAL 0x%08X\n",CM3DS_MPS2_SCC->SYS_CFGDATA_SERIAL);
  printf("SYS_CFGDATA_APB 0x%08X\n",CM3DS_MPS2_SCC->SYS_CFGDATA_APB);
  printf("SYS_CFGCTRL 0x%08X\n",CM3DS_MPS2_SCC->SYS_CFGCTRL);
  printf("SYS_CFGSTAT 0x%08X\n",CM3DS_MPS2_SCC->SYS_CFGSTAT);

  printf("Writing 0xa5a5a5a5 to SYS_CFGDATA_APB\n");
  CM3DS_MPS2_SCC->SYS_CFGDATA_APB = 0xa5a5a5a5;
  printf("SYS_CFGDATA_APB 0x%08X\n",CM3DS_MPS2_SCC->SYS_CFGDATA_APB);
  if (CM3DS_MPS2_SCC->SYS_CFGDATA_APB != 0xa5a5a5a5)
  {
    printf("Fail\n");
    result++;
  }
  printf("Writing 0xFFFFFFFF to SYS_CFGDATA_APB\n");
  CM3DS_MPS2_SCC->SYS_CFGDATA_APB = 0xFFFFFFFF;
  printf("SYS_CFGDATA_APB 0x%08X\n",CM3DS_MPS2_SCC->SYS_CFGDATA_APB);
  if (CM3DS_MPS2_SCC->SYS_CFGDATA_APB != 0xFFFFFFFF)
  {
    printf("Fail\n");
    result++;
  }

  printf("Writing 0xa5a5a5a5 to SYS_CFGCTRL - Also triggers interrupt\n");
  CM3DS_MPS2_SCC->SYS_CFGCTRL = 0xa5a5a5a5;
  printf("SYS_CFGCTRL 0x%08X\n",CM3DS_MPS2_SCC->SYS_CFGCTRL);
  if (CM3DS_MPS2_SCC->SYS_CFGCTRL != 0xa5a5a5a5)
  {
    printf("Fail\n");
    result++;
  }
  printf("Writing 0xFFFFFFFF to SYS_CFGCTRL\n");
  CM3DS_MPS2_SCC->SYS_CFGCTRL = 0xFFFFFFFF;
  printf("SYS_CFGCTRL 0x%08X\n",CM3DS_MPS2_SCC->SYS_CFGCTRL);
  if (CM3DS_MPS2_SCC->SYS_CFGCTRL != 0xFFFFFFFF)
  {
    printf("Fail\n");
    result++;
  }
  return(result);
}

void listmemory(unsigned int base, unsigned int offset, unsigned int range)
{
  unsigned int addr;
  unsigned int address_start;
  unsigned int address_end;

  address_start = (base+offset);
  address_end   = (address_start+range);
  printf("Start address 0x%08X\n",address_start);
  printf("End address   0x%08X\n",address_end);
  for(addr = address_start; addr < address_end; addr = addr + 4)
  {
    printf("0x%08X contains 0x%08X\n",addr,*((volatile unsigned int *)addr));
  }
  return;
}

void delay(void)
{
  int i;
  for (i=0;i<10;i++){
    __ISB();
    }
  return;
}

// Write 8 bits of data to the serial bus
void genAI2C_send_byte(unsigned char c, unsigned int address)
{
    int loop;
    for (loop = 0; loop < 8; loop++) {
        // apSleepus(1);
        CM3DS_MPS2_I2C->CONTROLC = CM3DS_MPS2_I2C_SCL_Msk;
        // apSleepus(1);
        if (c & (1 << (7 - loop)))
            CM3DS_MPS2_I2C->CONTROL = CM3DS_MPS2_I2C_SDA_Msk;
        else
            CM3DS_MPS2_I2C->CONTROLC = CM3DS_MPS2_I2C_SDA_Msk;
        CM3DS_MPS2_I2C->CONTROL = CM3DS_MPS2_I2C_SCL_Msk;
        CM3DS_MPS2_I2C->CONTROLC = CM3DS_MPS2_I2C_SCL_Msk;
    }

    CM3DS_MPS2_I2C->CONTROL = CM3DS_MPS2_I2C_SDA_Msk;
}

/* Test function for read */
#if defined ( __CC_ARM   )
/* Test function for read - for ARM / Keil */
__asm unsigned int memcpy_LDM_STM(unsigned int to, unsigned int* from, unsigned int size)
{
    PUSH    {r4-r7}         ; Store 4 registers onto stack
    CMP     r2,#8           ; Always size 8 LDM,
    BNE     fail            ; Check just in case accidentally modified.
    LDMIA     r1!,{r4-r7}   ; Load from memory 4 words
    STMIA     r0!,{r4-r7}   ; Store to temporary array
    LDMIA     r1!,{r4-r7}   ; Load from memory 4 words
    STMIA     r0!,{r4-r7}   ; Store to temporary array
success
    MOVS    r0, #0
    B       return
fail
    MOVS    r0, #1
return
    POP     {r4-r7}         ; Load 4 registers from stack
    BX      lr
}
#elif defined ( __IAR_SYSTEMS_ICC__ )
/* Test function for read - for IAR Systems */
unsigned int  memcpy_LDM_STM(unsigned int to, unsigned int* from, unsigned int size)
{
   unsigned int rdata;
  __asm("  push  {r4-r7}\n"
        "  cmp   %3, #8 \n"
        "  bne   fail   \n"
        "  ldmia %2!,{r4-r7} \n"
        "  stmia %1!,{r4-r7} \n"
        "  ldmia %2!,{r4-r7} \n"
        "  stmia %1!,{r4-r7} \n"
        "sucess: \n"
        "  movs  %0, #0 \n"
        "  b return \n"
        "fail: \n"
        "  movs %0, #1\n"
        "return: \n"
        "  pop {r4-r7} \n"
        :"=r"(rdata) : "r" (to), "r" (from), "r" (size) :  "memory"
   );
   return rdata;
}
#else
/* Test function for read - for gcc */
unsigned int  memcpy_LDM_STM(unsigned int to, unsigned int* from, unsigned int size) __attribute__((naked));
unsigned int  memcpy_LDM_STM(unsigned int to, unsigned int* from, unsigned int size)
{
  __asm("  push  {r4-r7}\n"
        "  cmp   r2, #8 \n"
        "  bne   fail   \n"
        "  ldmia r1!,{r4-r7} \n"
        "  stmia r0!,{r4-r7} \n"
        "  ldmia r1!,{r4-r7} \n"
        "  stmia r0!,{r4-r7} \n"
        "  sucess: \n"
        "  movs  r0, #0 \n"
        "  b return \n"
        "  fail: \n"
        "  movs r0, #1\n"
        "  return: \n"
        "  pop {r4-r7} \n"
        "  bx lr \n"  );
}
#endif

int main(void)
{
  unsigned int result;

  unsigned val, addr;

  result=PASS;
  // UART init
  UartStdOutInit();

  puts("\nSSE-050 - Design Test for Cortex-M3 - revision $Revision: 243483 $\n");

  printf("*** Testing Audio\n");
  CM3DS_MPS2_i2c_send_byte(0x65);

  printf("*** Single PSRAM read\n");
  addr = (CM3DS_MPS2_PSRAM_BASE+8);
  *((volatile unsigned short int *)addr) = (unsigned short int)0x55AA;
  val = *((volatile unsigned short int *)addr);
  // Try reading again
  val = *((volatile unsigned short int *)addr);

  printf("*** Testing SCC registers\n");
  result += result + test_scc(CM3DS_MPS2_SCC_BASE);
  printf("*** Testing Reading FPGA control registers\n");
  result += result + test_fpgareg(CM3DS_MPS2_FPGASYS_BASE);
  printf("*** Sending data from LCD I2C\n");
  genAI2C_send_byte(0x45,CM3DS_MPS2_CLCDTOUCH_BASE);
  printf("*** Testing PSRAM\n");
  result += test(CM3DS_MPS2_PSRAM_BASE,0x0,CM3DS_MPS2_PSRAM_SIZE);
  printf("*** Testing PSRAM burst\n");
  result += burst_test(CM3DS_MPS2_PSRAM_BASE,0x800000,CM3DS_MPS2_PSRAM_SIZE);
#ifndef FPGA_IMAGE
  // Testbench has a memory in place of Ethernet, to prove accesses
  // So this test will not pass on the Ethernet
  printf("*** Testing Ethernet\n");
  result += test(CM3DS_MPS2_ETH_BASE,0x0,ETH_SIZE);
#endif
  printf("*** Testing ZBT1\n");
  result += test(CM3DS_MPS2_ZBT1_BASE,0x0,CM3DS_MPS2_ZBT1_SIZE);
  printf("*** Testing ZBT1 burst\n");
  result += burst_test(CM3DS_MPS2_ZBT1_BASE,0x0,CM3DS_MPS2_ZBT1_SIZE);
  printf("*** Testing ZBT2 and ZBT3\n");
  result += test(CM3DS_MPS2_ZBT2_BASE,0x0,CM3DS_MPS2_ZBT2_SIZE);
  printf("*** Testing block RAM\n");
  result += test(CM3DS_MPS2_FLASH_BASE,0x0,CM3DS_MPS2_FLASH_SIZE);

#ifndef FPGA_IMAGE
  // On testbench only, external SPI is self looped back.
  // This test will not work on MPS2 board
  printf("*** Testing external SPI: self loop back test\n");
  // Program external SPI to master, Motorola SPI frame format SP0=0 SPH=0, data size 16bits, PCLKOUT half of PCLK
  // transmit 0xFFFF as data
  printf("Setting up external SPI\n");
  *((volatile unsigned int *)(CM3DS_MPS2_EXTSPI_BASE + 0x0000)) = 0xF;
  *((volatile unsigned int *)(CM3DS_MPS2_EXTSPI_BASE + 0x0008)) = 0x5555;
  *((volatile unsigned int *)(CM3DS_MPS2_EXTSPI_BASE + 0x0010)) = 0x2;
  printf("Enable external SPI\n");
  *((volatile unsigned int *)(CM3DS_MPS2_EXTSPI_BASE + 0x0004)) = 0x2;
  printf("Wait for receive data to be captured\n");
  while ((*((volatile unsigned int *)(CM3DS_MPS2_EXTSPI_BASE + 0x000c)) & 0x4) == 0);
  printf("Check receive data is the same as tranmit data\n");
  if (*((volatile unsigned int *)(CM3DS_MPS2_EXTSPI_BASE + 0x0008)) != 0x5555) {
    printf("Fail\n");
    result++;
  }
    printf("Pass\n");
#endif

  if (result == PASS)
  {
    printf("\n\n\n----------\n** TEST PASSED **\n----------\n\n\n\n");
  } else {
    if (result == 1)
    {
      printf("\n\n\nFail, %u failure\n\n\n\n",result);
    } else {
      printf("\n\n\nFail, %u failures\n\n\n\n",result);
    }
  }

  // End simulation
  UartEndSimulation();
  }
