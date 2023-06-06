.include "exti_map.inc"
.include "gpio_map.inc"

.cpu cortex-m3      @ Generates Cortex-M3 instructions
.section .text
.align	1
.syntax unified
.thumb
.global EXTI0_Handler
.global EXTI4_Handler

EXTI0_Handler:
        ldr     r0, =EXTI_BASE
        ldr     r3, [r0, EXTI_PR_OFFSET]
        orr     r3, r3, 0x40
        str     r3, [r0, EXTI_PR_OFFSET]
        bx      lr

EXTI4_Handler:
        ldr     r0, =EXTI_BASE
        ldr     r3, [r0, EXTI_PR_OFFSET]
        orr     r3, r3, 0x400
        str     r3, [r0, EXTI_PR_OFFSET]
        bx      lr
