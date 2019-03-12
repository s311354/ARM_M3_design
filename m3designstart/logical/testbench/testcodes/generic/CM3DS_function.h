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
#define HW32_REG(ADDRESS)  (*((volatile unsigned long  *)(ADDRESS)))
#define HW16_REG(ADDRESS)  (*((volatile unsigned short *)(ADDRESS)))
#define HW8_REG(ADDRESS)   (*((volatile unsigned char  *)(ADDRESS)))

#if defined ( __CC_ARM   )
__asm void          address_test_write(unsigned int addr, unsigned int wdata);
__asm unsigned int  address_test_read(unsigned int addr);
#else
      void          address_test_write(unsigned int addr, unsigned int wdata);
      unsigned int  address_test_read(unsigned int addr);
#endif
/* -------------------------------------------------------------------- */
/*   Helper functions for testing bus fault                             */
/* -------------------------------------------------------------------- */

#if defined ( __CC_ARM   )
/* Test function for write - for ARM / Keil */
__asm void address_test_write(unsigned int addr, unsigned int wdata)
{
  STR    R1,[R0]
  DSB    ; Ensure bus fault occurred before leaving this subroutine
  BX     LR
}

#elif defined ( __IAR_SYSTEMS_ICC__ )
/* Test function for write - for IAR Systems */
void address_test_write(unsigned int addr, unsigned int wdata)
{
   __asm("  str   %1,[%0]\n"
         "  dsb          \n"
         :: "r" (addr), "r" (wdata) : "memory"
   );
}
#else
/* Test function for write - for gcc */
void address_test_write(unsigned int addr, unsigned int wdata) __attribute__((naked));
void address_test_write(unsigned int addr, unsigned int wdata)
{
  __asm("  str   r1,[r0]\n"
        "  dsb          \n"
        "  bx    lr     \n"
  );
}
#endif

/* Test function for read */
#if defined ( __CC_ARM   )
/* Test function for read - for ARM / Keil */
__asm unsigned int address_test_read(unsigned int addr)
{
  PUSH   {R1, R2}
  LDR    R1,[R0]
  DSB    ; Ensure bus fault occurred before leaving this subroutine
  MOVS   R0, R1
  POP    {R1, R2}
  BX     LR
}
#elif defined ( __IAR_SYSTEMS_ICC__ )
/* Test function for read - for IAR Systems */
unsigned int address_test_read(unsigned int addr)
{
   unsigned int rdata;
   __asm("  ldr   %0,[%1]\n"
         "  dsb          \n"
         :"=r"(rdata) : "r" (addr) :  "memory"
   /* memory clobber is not strictly necessary but it makes sure that there is no "read ahead" */
   );
   return rdata;
}
#else
/* Test function for read - for gcc */
unsigned int  address_test_read(unsigned int addr) __attribute__((naked));
unsigned int  address_test_read(unsigned int addr)
{
  __asm("  push  {r1, r2}   \n"
        "  ldr   r1,[r0]\n"
        "  dsb          \n"
        "  movs  r0, r1 \n"
        "  pop   {r1, r2}   \n"
        "  bx    lr     \n"
  );
}
#endif



