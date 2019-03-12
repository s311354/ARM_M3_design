/*
 *-----------------------------------------------------------------------------
 * The confidential and proprietary information contained in this file may
 * only be used by a person authorised under and to the extent permitted
 * by a subsisting licensing agreement from ARM Limited.
 *
 *            (C) COPYRIGHT 2010-2017 ARM Limited.
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

// Simple demonstration of booting up an RTOS : Keil RTX

#include <RTL.h>
#include <stdio.h>
#include "uart_stdout.h"
#include "CM3DS_MPS2.h"

OS_TID t_task1;    // Declare a task ID for task1 : Event generator
OS_TID t_task2;    // Declare a task ID for task2 : Event receiver
int num = 0; // Counter

__task void task1(void) { // Task 1 - Event generator
  while (1) {
    os_dly_wait(1);
    puts("task 1 ->");
    os_evt_set (0x0001, t_task2);  // Send a event 0x0001 to task 2
    }
  }

__task void task2(void) { // Task 2 - Event receiver
  while(1) {
    os_evt_wait_and (0x0001, 0xffff); // wait for an event flag 0x0001
    num ++;
    printf ("  task 2, %d\n", num);
    if (num>=3) {      // Execute 3 times and stop simulation
      puts("Tasks ran 3 times.");
      puts("** TEST PASSED ** \n");
      UartEndSimulation();
      }
    }
  }

// Initialize tasks
__task void init (void) {
  t_task1  = os_tsk_create (task1, 1); // Create a task "task1" with priority 1
  t_task2  = os_tsk_create (task2, 1); // Create a task "task2" with priority 1
  os_tsk_delete_self ();
}


int main(void)
{
  // UART init
  UartStdOutInit();

  SysTick->VAL=0; // Initialize SysTick timer value

  // Test banner message and revision number
  puts("\nCortex-M3 DesignStart - RTX Demo - revision $Revision: 242484 $\n");
  puts("- Execute task 1 -> task 2 sequence three times\n");

  os_sys_init(init); // Initialize OS
} // end main
