.include "exti_map.inc"
.include "gpio_map.inc"

.cpu cortex-m3      @ Generates Cortex-M3 instructions
.section .text
.align	1
.syntax unified
.thumb


.global EXTI0_Handler
EXTI0_Handler:
        ldr     r0, =EXTI_BASE
        ldr     r3, [r0, EXTI_PR_OFFSET]
        orr     r3, r3, 0x40
        str     r3, [r0, EXTI_PR_OFFSET]
        bx      lr
/*
.global EXTI5_Handler
EXTI5_Handler:
        ldr     r0, =EXTI_BASE
        ldr     r3, [r0, EXTI_PR_OFFSET]
        orr     r3, r3, 0x40
        str     r3, [r0, EXTI_PR_OFFSET]
        bx      lr*/


.global EXTI4_Handler
EXTI4_Handler:
        ldr     r0, =EXTI_BASE
        ldr     r3, [r0, EXTI_PR_OFFSET]
        orr     r3, r3, 0x400
        str     r3, [r0, EXTI_PR_OFFSET]
        bx      lr

/*.global EXTI9_Handler
EXTI9_Handler:
        ldr     r0, =EXTI_BASE
        ldr     r3, [r0, EXTI_PR_OFFSET]
        orr     r3, r3, 0x400
        str     r3, [r0, EXTI_PR_OFFSET]
        bx      lr*/
