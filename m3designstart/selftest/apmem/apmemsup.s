;
; Copyright: 
; ----------------------------------------------------------------
; This confidential and proprietary software may be used only as
; authorised by a licensing agreement from ARM Limited
;   (C) COPYRIGHT 2014 ARM Limited
;       ALL RIGHTS RESERVED
; The entire notice above must be reproduced on all authorised
; copies and copies may only be made to the extent permitted
; by a licensing agreement from ARM Limited.
; ----------------------------------------------------------------
; File:     apusb.c
; Release:  Version 2.0
; ----------------------------------------------------------------
; 

    AREA    MemoryTest, CODE, READONLY

    EXPORT get_stack_ptr
    EXPORT memcpy_LDM_STM

get_stack_ptr         ; r0 points to arg1

    MOV r1, sp        ; read stack pointer
    STR r1, [r0]      ; store it into arg1

    BX  lr            ; return




memcpy_LDM_STM              ; r0 = to, r1 = from, r2 = size
    PUSH    {r4-r7}         ; Store 4 registers onto stack

    CMP     r2,#8           ; Always size 8 LDM,
    BNE     fail            ; Check just in case accidentally modified.

    LDMIA     r1!,{r4-r7}      ; Load from memory 4 words
    STMIA     r0!,{r4-r7}      ; Store to temporary array
    LDMIA     r1!,{r4-r7}      ; Load from memory 4 words
    STMIA     r0!,{r4-r7}      ; Store to temporary array
    
success
    MOVS    r0, #0
    B       return

fail
    MOVS    r0, #1

return
    POP     {r4-r7}         ; Load 4 registers from stack
    BX      lr

    END
