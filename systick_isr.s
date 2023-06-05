.include "systick_map.inc"
.include "scb_map.inc"

.cpu cortex-m3      @ Generates Cortex-M3 instructions
.extern __main
.section .text
.align 1
.syntax unified
.thumb

.global SysTick_Initialize
SysTick_Initialize:
        ldr     r0, =SYSTICK_BASE
        mov     r3, 0x0
        str     r3, [r0, STK_CTRL_OFFSET]
        ldr     r4, =0x1f3f
        str     r4, [r0, STK_LOAD_OFFSET]
        mov     r3, 0x0
        str     r3, [r0, STK_VAL_OFFSET]
        ldr     r4, =SCB_BASE
        add     r4 ,SCB_SHPR3_OFFSET
        mov     r5, 0x20
        strb    r5, [r0, #11]
        ldr     r3, [r0, STK_CTRL_OFFSET]
        orr     r3, r3, 0x7
        str     r3, [r0, STK_CTRL_OFFSET]
        bx      lr

.global SysTick_Handler
SysTick_Handler:
        sub     r10, r10, #1
        bx      lr
.size   SysTick_Handler, .-SysTick_Handler
