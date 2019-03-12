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
 *      Checked In          : $Date: 2013-04-10 15:14:20 +0100 (Wed, 10 Apr 2013) $
 *
 *      Revision            : $Revision: 243501 $
 *
 *      Release Information : CM3DesignStart-r0p0-02rel0
 *-----------------------------------------------------------------------------
 */


#if defined ( __CC_ARM   )
/******************************************************************************/
/* Retarget functions for ARM DS-5 Professional / Keil MDK                    */
/******************************************************************************/

#include <stdio.h>
#include <time.h>
#include <rt_misc.h>

#include "uart_stdout.h"

#pragma import(__use_no_semihosting_swi)

#ifdef FPGA_IMAGE

    // Headers only used by FPGA_IMAGE routines
    #include "CM3DS_MPS2.h"     // Defines RTC register
    #include <string.h>
    #include <rt_sys.h>

    /* Standard IO device handles. */
    #define STDIN   0x8001
    #define STDOUT  0x8002
    #define STDERR  0x8003

    /* Standard IO device name defines. */
    const char __stdin_name[]  = "STDIN";
    const char __stdout_name[] = "STDOUT";
    const char __stderr_name[] = "STDERR";
#endif

struct __FILE { int handle; /* Add whatever you need here */ };

// Verification tests only retarget stdio functions.
#ifndef FPGA_IMAGE
    FILE __stdout;
    FILE __stdin;
#endif


int fputc(int ch, FILE *f) {
  return (UartPutc(ch));
}

int fgetc(FILE *f) {
  return (UartPutc(UartGetc()));
}

int ferror(FILE *f) {
  /* Your implementation of ferror */
  return EOF;
}


void _ttywrch(int ch) {
  UartPutc (ch);
}

#ifdef FPGA_IMAGE
/*--------------------------- _sys_open --------------------------------------*/

FILEHANDLE _sys_open (const char *name, int openmode) {
   /* Register standard Input Output devices. */
   if (strcmp(name, "STDIN") == 0) {
      return (STDIN);
   }
   if (strcmp(name, "STDOUT") == 0) {
      return (STDOUT);
   }
   if (strcmp(name, "STDERR") == 0) {
      return (STDERR);
   }
   return (-1);
   //return (__sys_open (name, openmode));
}

/*--------------------------- _sys_close -------------------------------------*/

int _sys_close (FILEHANDLE fh) {
   if (fh > 0x8000) {
      return (0);
   }
   return (-1);
   //return (__sys_close (fh));
}

/*--------------------------- _sys_write -------------------------------------*/

int _sys_write (FILEHANDLE fh, const unsigned char  *buf, unsigned int len, int mode) {
   if (fh == STDOUT) {
      /* Standard Output device. */
      for (  ; len; len--) {
          UartPutc (*buf++);
      }
      return (0);
   }

   if (fh > 0x8000) {
      return (-1);
   }
   return (-1);
   //return (__sys_write (fh, buf, len));
}

/*--------------------------- _sys_read --------------------------------------*/

int _sys_read (FILEHANDLE fh, unsigned char *buf, unsigned int len, int mode) {
   if (fh == STDIN) {
      /* Standard Input device. */
      for (  ; len; len--) {
        *buf++ = UartGetc ();
      }
      return (0);
   }

   if (fh > 0x8000) {
      return (-1);
   }
   return (-1);
   //   return (__sys_read (fh, buf, len));
}

/*--------------------------- _sys_istty -------------------------------------*/

int _sys_istty (FILEHANDLE fh) {
   if (fh > 0x8000) {
      return (1);
   }
   return (0);
}

/*--------------------------- _sys_seek --------------------------------------*/

int _sys_seek (FILEHANDLE fh, long pos) {
   if (fh > 0x8000) {
      return (-1);
   }
   return (-1);
   //return (__sys_seek (fh, pos));
}

/*--------------------------- _sys_ensure ------------------------------------*/

int _sys_ensure (FILEHANDLE fh) {
   if (fh > 0x8000) {
      return (-1);
   }
   return (-1);
   //return (__sys_ensure (fh));
}

/*--------------------------- _sys_flen --------------------------------------*/

long _sys_flen (FILEHANDLE fh) {
   if (fh > 0x8000) {
      return (0);
   }
   return (-1);
   //return (__sys_flen (fh));
}

int _sys_tmpnam (char *name, int sig, unsigned maxlen) {
   return (1);
}

char *_sys_command_string (char *cmd, int len) {
   return (cmd);
}

int  system(const char * cmd)
{
   return (0);
}

time_t time(time_t * timer)
{
    time_t current;
    // Uses the simple up-counter in the FPGA control block, not the RTC
    current = CM3DS_MPS2_FPGASYS->COUNT1HZ;

    if (timer != NULL)
    {
        *timer = current;
    }

        return (current);
}

#endif

void _sys_exit(int return_code) {
label:  goto label;  /* endless loop */
}

#elif defined ( __IAR_SYSTEMS_ICC__ )
/******************************************************************************/
/* Retarget functions for IAR Systems C Compiler for ARM                      */
/******************************************************************************/
#include <yfuns.h>

#ifdef FPGA_IMAGE
#include <time.h>
#include "CM3DS_MPS2.h"
#endif

extern unsigned char UartGetc(void);
extern unsigned char UartPutc(unsigned char my_ch);

size_t __write(int handle, const unsigned char * buffer, size_t size)
{
size_t nChars = 0;

  for (/*Empty */; size > 0; --size)
  {
    UartPutc( * buffer++ );
    ++nChars;
  }
  return nChars;
}

size_t __read(int handle, unsigned char * buffer, size_t size)
{
  int nChars = 0;

  /* This template only reads from "standard in", for all other file
   * handles it returns failure. */
  if (handle != _LLIO_STDIN)
  {
    return _LLIO_ERROR;
  }

  for (/* Empty */; size > 0; --size)
  {
    /* Get char with echo */
    unsigned char c = UartPutc(UartGetc());
    /* Get char without echo */
    // unsigned char c = UartGetc();
    * buffer++ = c;
    ++nChars;
  }
  return nChars;
}

#ifdef FPGA_IMAGE

int __close(int handle)
{
  return 0;
}

long __lseek(int handle, long offset, int whence)
{
  return -1;
}

int remove(const char * filename)
{
  return 0;
}

time_t time(time_t * timer)
{
    time_t current;

    current = CM3DS_MPS2_FPGASYS->COUNT1HZ;

    if (timer != NULL)
    {
        *timer = current;
    }

    return (current);
}

#endif

#else
/******************************************************************************/
/* Retarget functions for GNU Tools for ARM Embedded Processors               */
/******************************************************************************/
#include <stdio.h>
#include <sys/stat.h>

extern unsigned char UartPutc(unsigned char my_ch);

__attribute__ ((used))  int _write (int fd, char *ptr, int len)
{
  size_t i;
  for (i=0; i<len;i++) {
    UartPutc(ptr[i]); // call character output function
    }
  return len;
}


#endif
