/*
 *-----------------------------------------------------------------------------
 * The confidential and proprietary information contained in this file may
 * only be used by a person authorised under and to the extent permitted
 * by a subsisting licensing agreement from ARM Limited.
 *
 *            (C) COPYRIGHT 2010-2015  ARM Limited or its affiliates.
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

#include "CM3DS_MPS2.h"
#include <stdio.h>
#include "uart_stdout.h"

int main (void)
{
  // UART init
  UartStdOutInit();

  printf("Hello world\n");

  printf("** TEST PASSED **\n");

  // End simulation
  UartEndSimulation();

  return 0;
}

