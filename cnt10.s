.thumb              @ Assembles using thumb mode
.cpu cortex-m3      @ Generates Cortex-M3 instructions
.syntax unified
.align 1
.section .text

.include "ivt.s"
.include "gpio_map.inc"
.include "rcc_map.inc"
.include "exti_map.inc"
.include "scb_map.inc"
.include "systick_map.inc"
.include "afio_map.inc"
.include "nvic_reg_map.inc"

.extern delay
.extern Systick_Initialize
.global __main

wait_ms:
        // Prologo
        push    {r7} @ backs r7 up
        sub     sp, sp, #28 @ reserves a 32-byte function frame
        add     r7, sp, #0 @ updates r7
        str     r0, [r7] @ backs ms up
        // Body function
        //ldr     r0, =2666667
        mov     r0, #1023 @ ticks = 255, adjust to achieve 1 ms delay
        str     r0, [r7, #16]
        // for (i = 0; i < ms; i++)
        mov     r0, #0 @ i = 0;
        str     r0, [r7, #8]
        b       F3
        // for (j = 0; j < tick; j++)
F4:     mov     r0, #0 @ j = 0;
        str     r0, [r7, #12]
        b       F5
F6:     ldr     r0, [r7, #12] @ j++;
        add     r0, #1
        str     r0, [r7, #12]
F5:     ldr     r0, [r7, #12] @ j < ticks;
        ldr     r1, [r7, #16]
        cmp     r0, r1
        blt     F6
        ldr     r0, [r7, #8] @ i++;
        add     r0, #1
        str     r0, [r7, #8]
F3:     ldr     r0, [r7, #8] @ i < ms
        ldr     r1, [r7]
        cmp     r0, r1
        blt     F4
        // Epilogue
        adds    r7, r7, #28
        mov	    sp, r7
        pop	    {r7}
        bx	    lr
.size	wait_ms, .-wait_ms

check_speed:
        push    {r7}
        sub     sp, sp, #4
        add     r7, sp, #0
// case (1):
        cmp     r8, #1
        bne     A1
// return (1000);
        mov     r0, #1000
        adds    r7, r7, #4
        mov     sp, r7
        pop     {r7}
        bx      lr
// case (2):
A1:
        cmp     r8, #2
        bne     A2
// return (500);
        mov     r0, #500
        adds    r7, r7, #4
        mov     sp, r7
        pop     {r7}
        bx      lr
// case (3):
A2:
        cmp     r8, #3
        bne     A3
// return (50);
        mov     r0, #50
        adds    r7, r7, #4
        mov     sp, r7
        pop     {r7}
        bx      lr
// case (4):
A3:
        cmp     r8, #4
        bne     A4
// return (5);
        mov     r0, #5
        adds    r7, r7, #4
        mov     sp, r7
        pop     {r7}
        bx      lr
// default:
A4:
        mov     r8, #1
// return (1000);
        mov     r0, #1000

        adds    r7, r7, #4
        mov     sp, r7
        pop     {r7}
        bx      lr
.size check_speed, .-check_speed

// void setup(){
__main:
        push    {r7, lr}
        sub     sp, sp, #28
        add     r7, sp, #0
        bl   SysTick_Initialize
        // Habilitar señal de reloj para los puertos A y B.
        ldr     r0, =RCC_BASE
        mov     r3, 0xc
        str     r3, [r0, RCC_APB2ENR_OFFSET]
         // Configurar la fuente de interrupcion externa para GPIOB B0 y B4
        ldr     r0, =AFIO_BASE
        mov     r3, 0x0
        str     r3, [r0, AFIO_EXTICR1_OFFSET]
        // Configuracion del tipo de disparo para la interrupcion
        ldr     r0, =EXTI_BASE
        mov     r3, 0x1
        str     r3, [r0, EXTI_RTST_OFFSET] // Bit correspondiente al flanco ascendente
        ldr     r3, =0x11
        str     r3, [r0, EXTI_FTST_OFFSET]
        str     r3, [r0, EXTI_IMR_OFFSET]
        // Habilitar la interrupción en el NVIC para EXTI1
        ldr     r0, =NVIC_BASE
        mov     r3, 0x440
        str     r3, [r0, NVIC_ISER0_OFFSET]
        // Inicializar las salidas
        ldr     r0, =GPIOA_BASE
        ldr     r3, =0x33333333
        str     r3, [r0, GPIOx_CRL_OFFSET]
        ldr     r0, =GPIOA_BASE
        ldr     r3, =0x44444433
        str     r3, [r0, GPIOx_CRH_OFFSET]
        /*Configuramos los puertos de entrada*/
        ldr     r0, =GPIOB_BASE
        ldr     r3, =0x44484448
        str     r3, [r0, GPIOx_CRL_OFFSET]
        /* int n = 0*/
        mov     r3, #0
        str     r3, [r7]
        // int speed = 1000;
        mov     r3, #1000
        str     r3, [r7, #4]

        mov     r8, #1
        mov     r9, #1
//}

// void loop(){
loop:

// speed = check_speed();
        bl      check_speed
        str     r0, [r7, #4]

// buttonA = digitalRead(PB0);
        ldr     r0, =GPIOB_BASE
        ldr     r0, [r0, GPIOx_IDR_OFFSET]
        and     r0, r0, 0x1
        cmp     r0, 0x1
        bne     b0
        // wait_ms(speed);
        mov     r0, #200
        bl      wait_ms
        adds    r8, r8, #1
b0:

// buttonB = digitalRead(PB4);
        ldr     r0, =GPIOB_BASE
        ldr     r0, [r0, GPIOx_IDR_OFFSET]
        and     r0, r0, 0x10
        cmp     r0, 0x10
        bne     b1
        // wait_ms(speed);
        mov     r0, #200
        bl      wait_ms
        eor     r9, r9, #1
        and     r9, r9, #1

b1:

// if (mode){
        cmp     r9, #1
        bne     x0
        // n--;
        ldr     r0, [r7]
        subs    r0, r0, #1
        str     r0, [r7]
        b       x1
//}else{
x0:
        // n++;
        ldr     r0, [r7]
        adds    r0, r0, #1
        str     r0, [r7]
//}
x1:
// if (n >= 1024){
        ldr     r3, [r7]
        ldr     r2, =0x400
        cmp     r3, r2
        blt     x3
        mov     r3, #0
        str     r3, [r7]
//}
x3:
// if (n < 0){
        ldr     r3, [r7]
        cmp     r3, 0x0
        bge     x2
        //ldr     r3, =0x3ff
        mov     r3, #1023
        str     r3, [r7]
//}
x2:
// digitalWrite(n);
        ldr     r3, =0xffff
        ldr     r0, =GPIOA_BASE
        add     r0, GPIOx_ODR_OFFSET
        ldr     r2, [r7]
        and     r3, r3, r2
        str     r3, [r0]
// delay(speed);
        ldr     r0, [r7, #4]
        bl      delay
//}
        b       loop
