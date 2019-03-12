/*
 *-----------------------------------------------------------------------------
 * The confidential and proprietary information contained in this file may
 * only be used by a person authorised under and to the extent permitted
 * by a subsisting licensing agreement from ARM Limited.
 *
 *            (C) COPYRIGHT 2010-2017  ARM Limited or its affiliates.
 *                ALL RIGHTS RESERVED
 *
 * This entire notice must be reproduced on all copies of this file
 * and copies of this file may only be made by a person if such person is
 * permitted to do so under the terms of a subsisting license agreement
 * from ARM Limited.
 *
 *      SVN Information
 *
 *      Checked In          : $Date: 2013-03-27 23:58:01 +0000 (Wed, 27 Mar 2013) $
 *
 *      Revision            : $Revision: 242484 $
 *
 *      Release Information : CM3DesignStart-r0p0-02rel0
 *-----------------------------------------------------------------------------
 */

 /* Check demonstrate watchdog functionality */

#include "CM3DS_MPS2.h"
#include <stdio.h>
#include "uart_stdout.h"

/* Macros for word access to address */
#define HW32_REG(ADDRESS)  (*((volatile unsigned long  *)(ADDRESS)))

void main_prog_part_1(void);
void main_prog_part_2(void);
int  watchdog_id_check(void);
int  sysctrl_id_check(void);
void watchdog_init(unsigned int cycle, int type);
                                       /* Program watchdog: */
                                       /* type = 0 : No action */
                                       /* type = 1 : Interrupt */
                                       /* type = 2 : Reset */
void watchdog_set(unsigned int cycle); /* update watchdog counter */
void watchdog_unlock(void);            /* unlock watchdog */
void watchdog_lock(void);              /* lock watchdog */
void watchdog_irq_clear(void);         /* clear watchdog interrupt */

/* Software variables for testing */
volatile int nmi_occurred;
volatile int nmi_expected;
volatile int reset_test;  /* set to 1 during watchdog reset test so that NMI
                             handler will not clear the watchdog */
volatile int integration_test=0;  /* set to 1 during watchdog integration test so that NMI
                             handler will clear integration test output */

/* Start of main code */
int main (void)
{
  // UART init
  UartStdOutInit();

  // Test banner message and revision number
  puts("\nCortex-M3 DesignStart - Watchdog Demo - revision $Revision: 242484 $\n");

  if (sysctrl_id_check()!=0) {
    puts ("** TEST SKIPPED ** SysCtrl not present.");
    UartEndSimulation();
    return 0;}

  /* Check CM3DS_MPS2_SYSCON->RSTINFO Reset Information register */
  /*  0 = cold reset */
  /*  1 = reset from SYSRESETREQ */
  /*  2 = reset from Watchdog */
  if ((CM3DS_MPS2_SYSCON->RSTINFO & CM3DS_MPS2_SYSCON_RSTINFO_WDOGRESETREQ_Msk) !=0) {
    puts ("Restarted by Watchdog reset");
    main_prog_part_2();
    UartEndSimulation(); /* Simulation stop */
  }
  else if ((CM3DS_MPS2_SYSCON->RSTINFO & CM3DS_MPS2_SYSCON_RSTINFO_SYSRESETREQ_Msk) !=0) {
    puts ("Restarted by SYSRESETREQ reset");
    puts ("ERROR: reset info register value incorrect.\n");
    UartEndSimulation(); /* Simulation stop */
  }
  else {
    puts("Watchdog demo test\n");

    if (watchdog_id_check()!=0) {
      puts ("** TEST SKIPPED ** Watchdog not present.");
      UartEndSimulation();
      return 0;}

    main_prog_part_1();
  }
  puts ("** TEST PASSED ** \n");
  UartEndSimulation(); /* Simulation stop */
}
/* ----------------------------------------------------------------- */
/* Detect the ARM ID and part number to see if device is present     */
int watchdog_id_check(void)
{
unsigned char wdog_id;
#define HW32_REG(ADDRESS)  (*((volatile unsigned long  *)(ADDRESS)))
#define HW8_REG(ADDRESS)   (*((volatile unsigned char  *)(ADDRESS)))

wdog_id = HW8_REG(CM3DS_MPS2_WATCHDOG_BASE + 0xFE8) & 0x07;

if ((HW32_REG(CM3DS_MPS2_WATCHDOG_BASE + 0xFE0) != 0x24) ||
    (HW32_REG(CM3DS_MPS2_WATCHDOG_BASE + 0xFE4) != 0xB8) ||
    (wdog_id != 0x03))
  return 1; /* part ID & ARM ID does not match */
else
  return 0;
}
int sysctrl_id_check(void)
{ /* CM3DS_MPS2 SysCtrl part ID range from 826 to 829 */
if ((HW32_REG(CM3DS_MPS2_SYSCTRL_BASE + 0xFE0) < 0x26) ||
    (HW32_REG(CM3DS_MPS2_SYSCTRL_BASE + 0xFE0) > 0x29) ||
    (HW32_REG(CM3DS_MPS2_SYSCTRL_BASE + 0xFE4) != 0xB8))
  return 1; /* part ID does not match */
else
  return 0;
}

/* ----------------------------------------------------------------- */
/* First part of the test program                                    */
void main_prog_part_1(void)
{
  int i;
  const char expected_id[8]={0x24, 0xB8, 0x1B, 0x00, 0x0D, 0xF0, 0x05, 0xB1};
  unsigned int read_data;
  reset_test = 0;

  puts("Main program part 1\n");
  puts("- Detect ID registers\n");
  // Check the IDs and not revision number
  for (i=0; i<8; i++){
    read_data = HW32_REG(CM3DS_MPS2_WATCHDOG_BASE + 0xFE0 + i*4);
    if (read_data==expected_id[i]){
      printf ("Values[%x]=0x%x\n", i, read_data);
    } else {
      printf ("ERROR : Values[%x]=0x%x, expected 0x%x\n", i, read_data,expected_id[i]);
      UartEndSimulation();
    }
  }

  puts("\n- Program watchdog for 10000 cycles");
  watchdog_init(10000, 1); /* Generate NMI */
  nmi_occurred = 0;
  nmi_expected = 0;
  puts("- Run loop with watchdog set regularly 10 times\n");
  i = 0;
  while (i<10) {
    read_data = CM3DS_MPS2_WATCHDOG->VALUE;
    if (read_data < 8000) //the threshold must be large enough so that the NMI interrupt
                          //won't be triggered before the watchdog value is set again
    {
      watchdog_set(10000);
      i++;
      puts ("  Watchdog value set again");
    }
  }

  watchdog_init(5000, 0); /* Set watchdog to no action */
  if (nmi_occurred!=0) {
    puts ("ERROR : NMI occurred unexpectedly\n");
    UartEndSimulation();  /* Simulation stop */
  }

  puts("\n- Test NMI generation");
  nmi_occurred = 0;
  nmi_expected = 1;
  watchdog_init(5000, 1); /* Generate NMI */

  while (nmi_occurred==0) {
    //Wait for the watchdog interrupt
  }

  watchdog_init(5000, 0); /* Set watchdog to no action */
  puts("\n- Test reset generation");
  nmi_occurred = 0;
  nmi_expected = 1; /* NMI will be triggered first */
  reset_test   = 1; /* put NMI handler to reset test operation */
  watchdog_init(5000, 2); /* Generate Reset */
  while (1) {
    // wait for NMI...
  }
}


/* ----------------------------------------------------------------- */
/* Second part of the main test program - execute after watchdog reset */
void main_prog_part_2(void)
{
  int result=0;
  unsigned int read_data;
  puts("Main program part 2");
  puts("- Watchdog reset completed");
  read_data = CM3DS_MPS2_SYSCON->RSTINFO;
  printf ("  SYSCON->RSTINFO = %x\n", read_data);

  if (read_data != CM3DS_MPS2_SYSCON_RSTINFO_WDOGRESETREQ_Msk) {
     result++;
  }
  puts("- Clear reset info");
  CM3DS_MPS2_SYSCON->RSTINFO = CM3DS_MPS2_SYSCON_RSTINFO_WDOGRESETREQ_Msk;
  read_data = CM3DS_MPS2_SYSCON->RSTINFO;
  printf ("  SYSCON->RSTINFO = %x\n", read_data);

  if (read_data != 0)/* RSTINFO should be cleared */
  {
     result++;
  }

  if (result != 0) {
    puts ("ERROR: reset info register value incorrect.\n");
  } else {
    puts ("Watchdog reset performed successfully\n");
  }

  /*                                                  */
  /* A simple integration test for Watchdog using NMI */
  /*                                                  */

   /* Instead of trigger NMI using normal watchdog operation, you can also
      test the watchdog connection using integration test register.
      ITCR - bit 0 enable integration test mode
      ITOP - bit 0 enable watchdog reset when integration test mode is enabled
             bit 1 enable watchdog interrupt when integration test mode is enabled

      Here we demonstrate the generation of interrupt (NMI) using integration test
      registers. You can also use integration test register to generate reset
      but this will cause this part of the test running again and again, so we
      will not demonstrate it here.
   */

  puts("Testing generation of NMI using integration test register");
  reset_test = 0;
  integration_test = 1;
  nmi_expected = 0;
  nmi_occurred = 0;
  watchdog_unlock();
  CM3DS_MPS2_WATCHDOG->ITOP = 0;  // Ensure NMI and reset in integration test mode are 0
  CM3DS_MPS2_WATCHDOG->ITCR = 1;  // Enable integration test mode
  if (CM3DS_MPS2_WATCHDOG->ITCR == 0) {
     puts ("  - Integration Control read error");
     result++;
  }
  else {
    nmi_expected = 1;
    CM3DS_MPS2_WATCHDOG->ITOP = 2;  // Set NMI output to 1
    CM3DS_MPS2_WATCHDOG->ITOP = 0;  // Set NMI output to 0
    if (nmi_occurred==0) {
       puts ("  - Integration Test operation failed");
       result++;
    }
    CM3DS_MPS2_WATCHDOG->ITCR = 0;  // Disable integration test mode
    if (CM3DS_MPS2_WATCHDOG->ITCR != 0) {
      puts ("  - Integration Control clear error");
      result++;
    }
  }
  if (result != 0) {
    puts ("** TEST FAILED ** Errors in Watchdog test\n");
  } else {
    puts ("Watchdog demo completed successfully\n** TEST PASSED ** \n");
  }

  UartEndSimulation(); /* Simulation stops in UartEndSimulation */
}

/* ----------------------------------------------------------------- */
void NMI_Handler(void)
{

  puts ("NMI Handler Entered! \n");
  if (reset_test==1){  /* When testing watchdog reset, need to stay
    in NMI handler until the watchdog overflows again */
    while (1) {
     // wait for reset...
    }
  }
  watchdog_irq_clear(); /* Deassert Watchdog interrupt */
  nmi_occurred++; /* Update software flag */
  if (nmi_expected==0) { /* error check */
    puts ("ERROR : NMI occurred unexpectedly\n");
    UartEndSimulation(); /* Simulation stop */
  }
  if (integration_test!=0) {
    watchdog_unlock();
    CM3DS_MPS2_WATCHDOG->ITOP = 0;  // Set NMI output to 0
  }
}
/* ----------------------------------------------------------------- */
/* Watchdog initialization */
void watchdog_init(unsigned int cycle, int type)
{
  puts   ("  Unlocking watchdog...");
  watchdog_unlock();
#ifdef FPGA_IMAGE
  CM3DS_MPS2_WATCHDOG->LOAD = (cycle*100);
#else
  CM3DS_MPS2_WATCHDOG->LOAD = cycle;
#endif

  if (type==0) {
    puts   ("  Set to no action");
    CM3DS_MPS2_WATCHDOG->CTRL = 0;
  } else if (type==1) {
    puts   ("  Set to NMI generation");
    CM3DS_MPS2_WATCHDOG->CTRL = CM3DS_MPS2_Watchdog_CTRL_INTEN_Msk;
  } else {
    puts   ("  Set to reset generation");
    CM3DS_MPS2_WATCHDOG->CTRL = CM3DS_MPS2_Watchdog_CTRL_RESEN_Msk|CM3DS_MPS2_Watchdog_CTRL_INTEN_Msk;
  }
  puts   ("  Locking watchdog...");
  watchdog_lock();
}
/* ----------------------------------------------------------------- */
/* Update watchdog counter */
void watchdog_set(unsigned int cycle)
{
  watchdog_unlock();
#ifdef FPGA_IMAGE
  CM3DS_MPS2_WATCHDOG->CTRL = (cycle*100);
#else
  CM3DS_MPS2_WATCHDOG->CTRL = cycle;
#endif
  watchdog_lock();
}
/* ----------------------------------------------------------------- */
/* Unlock watchdog access */
void watchdog_unlock(void)
{
  CM3DS_MPS2_WATCHDOG->LOCK = 0x1ACCE551;
}
/* ----------------------------------------------------------------- */
/* Lock watchdog access */
void watchdog_lock(void)
{
  CM3DS_MPS2_WATCHDOG->LOCK = 0;
}
/* ----------------------------------------------------------------- */
/* Clear watchdog interrupt request */
void watchdog_irq_clear(void)
{
  watchdog_unlock();
  CM3DS_MPS2_WATCHDOG->INTCLR = CM3DS_MPS2_Watchdog_INTCLR_Msk;
  watchdog_lock();
}

