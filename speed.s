.section .text
.align  1
.syntax unified
.thumb
.global check_speed

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
        mov     r0, #250
        adds    r7, r7, #4
        mov     sp, r7
        pop     {r7}
        bx      lr
// case (4):
A3:
        cmp     r8, #4
        bne     A4
// return (5);
        mov     r0, #125
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
