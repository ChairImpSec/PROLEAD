///////////////////////////////////////////////////////////////////////////////////
////////////////////////////////// ARM masked PRESENT /////////////////////////////
///////////////////////////////////////////////////////////////////////////////////



.syntax unified
.thumb

.text


.macro ror8_1 reg
    and  r12, \reg, #1
    lsl r12, r12, #7
    and  \reg, \reg, #254
    lsr  \reg, \reg, #1
    eor   \reg, \reg, r12
    and  \reg, \reg, #255
    mov r12, 0
.endm

.macro ror8_2 reg
    and  r12, \reg, #3
    lsl r12, r12, #6
    and  \reg, \reg, #252
    lsr  \reg, \reg, #2
    eor   \reg, \reg, r12
    and  \reg, \reg, #255
    mov r12, #0

.endm

.macro rol8_1 reg
    and  r12, \reg, #128
    lsr r12, r12, #7
    and  \reg, \reg, #127
    lsl  \reg, \reg, #1
    eor   \reg, \reg, r12
    and  \reg, \reg, #255
    mov r12, 0
.endm

.macro rol8_2 reg
    and  r12, \reg, #192
    lsr r12, r12, #6
    and  \reg, \reg, #63
    lsl  \reg, \reg, #2
    eor   \reg, \reg, r12
    and  \reg, \reg, #255
    mov r12, 0

.endm


.macro big_ror_1 reg
    // p1
    and r0, \reg, #255
    // p2
    lsr r1, \reg, #8
    ror8_1 r0
    ror8_1 r1
    lsl r1, r1, #8
    eor \reg, r0, r1
    mov r0, 0
    mov r1, 0
.endm


.macro big_ror_2 reg
    // p1
    and r0, \reg, #255
    // p2
    lsr r1, \reg, #8
    ror8_2 r0
    ror8_2 r1
    lsl r1, r1, #8
    eor \reg, r0, r1
    mov r0, 0
    mov r1, 0
.endm

.macro big_rol_1 reg
    // p1
    and r0, \reg, #255
    // p2
    lsr r1, \reg, #8
    rol8_1 r0
    rol8_1 r1
    lsl r1, r1, #8
    eor \reg, r0, r1
    mov r0, 0
    mov r1, 0
.endm

.macro big_rol_2 reg
    // p1
    and r0, \reg, #255
    // p2
    lsr r1, \reg, #8
    rol8_2 r0
    rol8_2 r1
    lsl r1, r1, #8
    eor \reg, r0, r1
    mov r0, 0
    mov r1, 0
.endm


///////////////////////////////////////////////////////////////////////
/////////////////////////// sbox //////////////////////////////////////
///////////////////////////////////////////////////////////////////////


.align 4
.global   A
.type   A, %function;
A:

    mov r12, r10
    mov r10, r11
    eor r11, r1, r12
    bx lr



.align 4
.global   Ap
.type   Ap, %function;
Ap:

    mov r11, r0
    mov r6, r1
    mov r7, r10
    mov r8, r11

    eor r0, r11, r7
    eor r0, r0, r8
    mov r1, r11
    eor r11, r11, r6

    bx lr



.align 4
.global   App_a
.type   App_a, %function;
App_a:

    mov r0, r2
    mov r1, r3
    mov r10, r4
    mov r11, r5


    eor r3, r10, r11
    eor r4, r0, r1
    eor r4, r4, r11
    mov r0, #255
    lsl r0, r0, #8
    eor r0, r0, #255
    eor r4, r4, r0
    eor r5, r10, r0

    bx lr



.align 4
.global   App_b
.type   App_b, %function;
App_b:

    mov r0, r6
    mov r1, r7
    mov r10, r8
    mov r11, r9

    eor r7, r10, r11
    eor r8, r0, r1
    eor r8, r8, r11
    mov r9, r10

    bx lr



.align 4
.global   Appp_a
.type   Appp_a, %function;
Appp_a:

    mov r0, r2
    mov r1, r3
    mov r10, r4
    mov r11, r5

    eor r2, r0, r1
    mov r3, r0
    eor r4, r0, r1
    eor r4, r4, r10
    eor r4, r4, r11

    mov r11, #255
    lsl r11, r11, #8
    eor r11, r11, #255
    eor r5, r5, r11

    bx lr

.align 4
.global   Appp_b
.type   Appp_b, %function;
Appp_b:


    mov r0, r6
    mov r1, r7
    mov r10, r8
    mov r11, r9

    eor r6, r0, r1
    mov r7, r0
    eor r8, r0, r1
    eor r8, r8, r10
    eor r8, r8, r11

    bx lr


//////////////////////////////////////////////////////////////////////////////
/////////////////////////// sbox //////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////


.align 4
.global   sbox_player
.type   sbox_player, %function;
// r0 = shares0 (64 bits)
// r1 = sharer2 (64 bits)
sbox_player:


    push {r14}
    sub sp, sp, #(4 * 3)

    str r0, [sp, #0] // save pt shares0 in stack
    str r1, [sp, #4] // save pt sharer2 in stacK

    mov r2, #0
    mov r3, #0
    mov r4, #0
    mov r5, #0

    mov r6, #0
    mov r7, #0
    mov r8, #0
    mov r9, #0


    ////////////////////////////////////////
    ////////////////////////////////////////
    ///// Construct bitsliced format ///////
    ////////////////////////////////////////
    ////////////////////////////////////////



    ////////////////////////////////////////
    /////////////// SHARE A ////////////////
    ////////////////////////////////////////

    // ************ r2 REGISTER ************ //


    // FIRST SHARE part 2
    ldr r10, [r0, #4]

    lsr r11, r10, #28
    and r11, r11, #1
    lsl r11, r11, #8
    orr r2, r2, r11

    lsr r11, r10, #24
    and r11, r11, #1
    lsl r11, r11, #9
    orr r2, r2, r11

    lsr r11, r10, #20
    and r11, r11, #1
    lsl r11, r11, #10
    orr r2, r2, r11

    lsr r11, r10, #16
    and r11, r11, #1
    lsl r11, r11, #11
    orr r2, r2, r11

    lsr r11, r10, #12
    and r11, r11, #1
    lsl r11, r11, #12
    orr r2, r2, r11

    lsr r11, r10, #8
    and r11, r11, #1
    lsl r11, r11, #13
    orr r2, r2, r11

    lsr r11, r10, #4
    and r11, r11, #1
    lsl r11, r11, #14
    orr r2, r2, r11


    and r11, r10, #1
    lsl r11, r11, #15
    orr r2, r2, r11

    // FIRST SHARE part 1
    ldr r10, [r0, #0]

    lsr r11, r10, #28
    and r11, r11, #1
    lsl r11, r11, #0
    orr r2, r2, r11

    lsr r11, r10, #24
    and r11, r11, #1
    lsl r11, r11, #1
    orr r2, r2, r11

    lsr r11, r10, #20
    and r11, r11, #1
    lsl r11, r11, #2
    orr r2, r2, r11

    lsr r11, r10, #16
    and r11, r11, #1
    lsl r11, r11, #3
    orr r2, r2, r11

    lsr r11, r10, #12
    and r11, r11, #1
    lsl r11, r11, #4
    orr r2, r2, r11

    lsr r11, r10, #8
    and r11, r11, #1
    lsl r11, r11, #5
    orr r2, r2, r11

    lsr r11, r10, #4
    and r11, r11, #1
    lsl r11, r11, #6
    orr r2, r2, r11


    and r11, r10, #1
    lsl r11, r11, #7
    orr r2, r2, r11


    // ************ r3 REGISTER ************ //

    // FIRST SHARE part 2
    ldr r10, [r0, #4]

    lsr r11, r10, #29
    and r11, r11, #1
    lsl r11, r11, #8
    orr r3, r3, r11

    lsr r11, r10, #25
    and r11, r11, #1
    lsl r11, r11, #9
    orr r3, r3, r11

    lsr r11, r10, #21
    and r11, r11, #1
    lsl r11, r11, #10
    orr r3, r3, r11

    lsr r11, r10, #17
    and r11, r11, #1
    lsl r11, r11, #11
    orr r3, r3, r11

    lsr r11, r10, #13
    and r11, r11, #1
    lsl r11, r11, #12
    orr r3, r3, r11

    lsr r11, r10, #9
    and r11, r11, #1
    lsl r11, r11, #13
    orr r3, r3, r11

    lsr r11, r10, #5
    and r11, r11, #1
    lsl r11, r11, #14
    orr r3, r3, r11


    lsr r11, r10, #1
    and r11, r11, #1
    lsl r11, r11, #15
    orr r3, r3, r11

    // FIRST SHARE part 1
    ldr r10, [r0, #0]

    lsr r11, r10, #29
    and r11, r11, #1
    lsl r11, r11, #0
    orr r3, r3, r11

    lsr r11, r10, #25
    and r11, r11, #1
    lsl r11, r11, #1
    orr r3, r3, r11

    lsr r11, r10, #21
    and r11, r11, #1
    lsl r11, r11, #2
    orr r3, r3, r11

    lsr r11, r10, #17
    and r11, r11, #1
    lsl r11, r11, #3
    orr r3, r3, r11

    lsr r11, r10, #13
    and r11, r11, #1
    lsl r11, r11, #4
    orr r3, r3, r11

    lsr r11, r10, #9
    and r11, r11, #1
    lsl r11, r11, #5
    orr r3, r3, r11

    lsr r11, r10, #5
    and r11, r11, #1
    lsl r11, r11, #6
    orr r3, r3, r11


    lsr r11, r10, #1
    and r11, r11, #1
    lsl r11, r11, #7
    orr r3, r3, r11

    // ************ r4 REGISTER ************ //

    // FIRST SHARE part 2
    ldr r10, [r0, #4]

    lsr r11, r10, #30
    and r11, r11, #1
    lsl r11, r11, #8
    orr r4, r4, r11

    lsr r11, r10, #26
    and r11, r11, #1
    lsl r11, r11, #9
    orr r4, r4, r11

    lsr r11, r10, #22
    and r11, r11, #1
    lsl r11, r11, #10
    orr r4, r4, r11

    lsr r11, r10, #18
    and r11, r11, #1
    lsl r11, r11, #11
    orr r4, r4, r11

    lsr r11, r10, #14
    and r11, r11, #1
    lsl r11, r11, #12
    orr r4, r4, r11

    lsr r11, r10, #10
    and r11, r11, #1
    lsl r11, r11, #13
    orr r4, r4, r11

    lsr r11, r10, #6
    and r11, r11, #1
    lsl r11, r11, #14
    orr r4, r4, r11


    lsr r11, r10, #2
    and r11, r11, #1
    lsl r11, r11, #15
    orr r4, r4, r11

    // FIRST SHARE part 1
    ldr r10, [r0, #0]

    lsr r11, r10, #30
    and r11, r11, #1
    lsl r11, r11, #0
    orr r4, r4, r11

    lsr r11, r10, #26
    and r11, r11, #1
    lsl r11, r11, #1
    orr r4, r4, r11

    lsr r11, r10, #22
    and r11, r11, #1
    lsl r11, r11, #2
    orr r4, r4, r11

    lsr r11, r10, #18
    and r11, r11, #1
    lsl r11, r11, #3
    orr r4, r4, r11

    lsr r11, r10, #14
    and r11, r11, #1
    lsl r11, r11, #4
    orr r4, r4, r11

    lsr r11, r10, #10
    and r11, r11, #1
    lsl r11, r11, #5
    orr r4, r4, r11

    lsr r11, r10, #6
    and r11, r11, #1
    lsl r11, r11, #6
    orr r4, r4, r11


    lsr r11, r10, #2
    and r11, r11, #1
    lsl r11, r11, #7
    orr r4, r4, r11


    // ************ r5 REGISTER ************ //

    // FIRST SHARE part 2
    ldr r10, [r0, #4]

    lsr r11, r10, #31
    and r11, r11, #1
    lsl r11, r11, #8
    orr r5, r5, r11

    lsr r11, r10, #27
    and r11, r11, #1
    lsl r11, r11, #9
    orr r5, r5, r11

    lsr r11, r10, #23
    and r11, r11, #1
    lsl r11, r11, #10
    orr r5, r5, r11

    lsr r11, r10, #19
    and r11, r11, #1
    lsl r11, r11, #11
    orr r5, r5, r11

    lsr r11, r10, #15
    and r11, r11, #1
    lsl r11, r11, #12
    orr r5, r5, r11

    lsr r11, r10, #11
    and r11, r11, #1
    lsl r11, r11, #13
    orr r5, r5, r11

    lsr r11, r10, #7
    and r11, r11, #1
    lsl r11, r11, #14
    orr r5, r5, r11


    lsr r11, r10, #3
    and r11, r11, #1
    lsl r11, r11, #15
    orr r5, r5, r11

    // FIRST SHARE part 1
    ldr r10, [r0, #0]

    lsr r11, r10, #31
    and r11, r11, #1
    lsl r11, r11, #0
    orr r5, r5, r11

    lsr r11, r10, #27
    and r11, r11, #1
    lsl r11, r11, #1
    orr r5, r5, r11

    lsr r11, r10, #23
    and r11, r11, #1
    lsl r11, r11, #2
    orr r5, r5, r11

    lsr r11, r10, #19
    and r11, r11, #1
    lsl r11, r11, #3
    orr r5, r5, r11

    lsr r11, r10, #15
    and r11, r11, #1
    lsl r11, r11, #4
    orr r5, r5, r11

    lsr r11, r10, #11
    and r11, r11, #1
    lsl r11, r11, #5
    orr r5, r5, r11

    lsr r11, r10, #7
    and r11, r11, #1
    lsl r11, r11, #6
    orr r5, r5, r11


    lsr r11, r10, #3
    and r11, r11, #1
    lsl r11, r11, #7
    orr r5, r5, r11


    ////////////////////////////////////////
    /////////////// SHARE B ////////////////
    ////////////////////////////////////////


    // ************ r6 REGISTER ************ //


    // SECOND SHARE part 2
    ldr r10, [r1, #4]


    lsr r11, r10, #23
    and r11, r11, #1
    lsl r11, r11, #8
    orr r6, r6, r11

    lsr r11, r10, #19
    and r11, r11, #1
    lsl r11, r11, #9
    orr r6, r6, r11

    lsr r11, r10, #15
    and r11, r11, #1
    lsl r11, r11, #10
    orr r6, r6, r11

    lsr r11, r10, #11
    and r11, r11, #1
    lsl r11, r11, #11
    orr r6, r6, r11

    lsr r11, r10, #7
    and r11, r11, #1
    lsl r11, r11, #12
    orr r6, r6, r11

    lsr r11, r10, #3
    and r11, r11, #1
    lsl r11, r11, #13
    orr r6, r6, r11

    lsr r11, r10, #31
    and r11, r11, #1
    lsl r11, r11, #14
    orr r6, r6, r11


    lsr r11, r10, #27
    and r11, r11, #1
    lsl r11, r11, #15
    orr r6, r6, r11

    // SECOND SHARE part 1

    ldr r10, [r1, #0]


    lsr r11, r10, #23
    and r11, r11, #1
    lsl r11, r11, #0
    orr r6, r6, r11

    lsr r11, r10, #19
    and r11, r11, #1
    lsl r11, r11, #1
    orr r6, r6, r11

    lsr r11, r10, #15
    and r11, r11, #1
    lsl r11, r11, #2
    orr r6, r6, r11

    lsr r11, r10, #11
    and r11, r11, #1
    lsl r11, r11, #3
    orr r6, r6, r11

    lsr r11, r10, #7
    and r11, r11, #1
    lsl r11, r11, #4
    orr r6, r6, r11

    lsr r11, r10, #3
    and r11, r11, #1
    lsl r11, r11, #5
    orr r6, r6, r11

    lsr r11, r10, #31
    and r11, r11, #1
    lsl r11, r11, #6
    orr r6, r6, r11


    lsr r11, r10, #27
    and r11, r11, #1
    lsl r11, r11, #7
    orr r6, r6, r11


    // ************ r7 REGISTER ************ //

    // SECOND SHARE part 2

    ldr r10, [r1, #4]


    lsr r11, r10, #24
    and r11, r11, #1
    lsl r11, r11, #8
    orr r7, r7, r11

    lsr r11, r10, #20
    and r11, r11, #1
    lsl r11, r11, #9
    orr r7, r7, r11

    lsr r11, r10, #16
    and r11, r11, #1
    lsl r11, r11, #10
    orr r7, r7, r11

    lsr r11, r10, #12
    and r11, r11, #1
    lsl r11, r11, #11
    orr r7, r7, r11

    lsr r11, r10, #8
    and r11, r11, #1
    lsl r11, r11, #12
    orr r7, r7, r11

    lsr r11, r10, #4
    and r11, r11, #1
    lsl r11, r11, #13
    orr r7, r7, r11

    lsr r11, r10, #0
    and r11, r11, #1
    lsl r11, r11, #14
    orr r7, r7, r11


    lsr r11, r10, #28
    and r11, r11, #1
    lsl r11, r11, #15
    orr r7, r7, r11

    // SECOND SHARE part 1

    ldr r10, [r1, #0]


    lsr r11, r10, #24
    and r11, r11, #1
    lsl r11, r11, #0
    orr r7, r7, r11

    lsr r11, r10, #20
    and r11, r11, #1
    lsl r11, r11, #1
    orr r7, r7, r11

    lsr r11, r10, #16
    and r11, r11, #1
    lsl r11, r11, #2
    orr r7, r7, r11

    lsr r11, r10, #12
    and r11, r11, #1
    lsl r11, r11, #3
    orr r7, r7, r11

    lsr r11, r10, #8
    and r11, r11, #1
    lsl r11, r11, #4
    orr r7, r7, r11

    lsr r11, r10, #4
    and r11, r11, #1
    lsl r11, r11, #5
    orr r7, r7, r11

    lsr r11, r10, #0
    and r11, r11, #1
    lsl r11, r11, #6
    orr r7, r7, r11


    lsr r11, r10, #28
    and r11, r11, #1
    lsl r11, r11, #7
    orr r7, r7, r11

    // ************ r8 REGISTER ************ //

    // SECOND SHARE part 2

    ldr r10, [r1, #4]


    lsr r11, r10, #25
    and r11, r11, #1
    lsl r11, r11, #8
    orr r8, r8, r11

    lsr r11, r10, #21
    and r11, r11, #1
    lsl r11, r11, #9
    orr r8, r8, r11

    lsr r11, r10, #17
    and r11, r11, #1
    lsl r11, r11, #10
    orr r8, r8, r11

    lsr r11, r10, #13
    and r11, r11, #1
    lsl r11, r11, #11
    orr r8, r8, r11

    lsr r11, r10, #9
    and r11, r11, #1
    lsl r11, r11, #12
    orr r8, r8, r11

    lsr r11, r10, #5
    and r11, r11, #1
    lsl r11, r11, #13
    orr r8, r8, r11

    lsr r11, r10, #1
    and r11, r11, #1
    lsl r11, r11, #14
    orr r8, r8, r11


    lsr r11, r10, #29
    and r11, r11, #1
    lsl r11, r11, #15
    orr r8, r8, r11

    // SECOND SHARE part 1

    ldr r10, [r1, #0]


    lsr r11, r10, #25
    and r11, r11, #1
    lsl r11, r11, #0
    orr r8, r8, r11

    lsr r11, r10, #21
    and r11, r11, #1
    lsl r11, r11, #1
    orr r8, r8, r11

    lsr r11, r10, #17
    and r11, r11, #1
    lsl r11, r11, #2
    orr r8, r8, r11

    lsr r11, r10, #13
    and r11, r11, #1
    lsl r11, r11, #3
    orr r8, r8, r11

    lsr r11, r10, #9
    and r11, r11, #1
    lsl r11, r11, #4
    orr r8, r8, r11

    lsr r11, r10, #5
    and r11, r11, #1
    lsl r11, r11, #5
    orr r8, r8, r11

    lsr r11, r10, #1
    and r11, r11, #1
    lsl r11, r11, #6
    orr r8, r8, r11


    lsr r11, r10, #29
    and r11, r11, #1
    lsl r11, r11, #7
    orr r8, r8, r11


    // ************ r9 REGISTER ************ //

    // SECOND SHARE part 2

    ldr r10, [r1, #4]


    lsr r11, r10, #26
    and r11, r11, #1
    lsl r11, r11, #8
    orr r9, r9, r11

    lsr r11, r10, #22
    and r11, r11, #1
    lsl r11, r11, #9
    orr r9, r9, r11

    lsr r11, r10, #18
    and r11, r11, #1
    lsl r11, r11, #10
    orr r9, r9, r11

    lsr r11, r10, #14
    and r11, r11, #1
    lsl r11, r11, #11
    orr r9, r9, r11

    lsr r11, r10, #10
    and r11, r11, #1
    lsl r11, r11, #12
    orr r9, r9, r11

    lsr r11, r10, #6
    and r11, r11, #1
    lsl r11, r11, #13
    orr r9, r9, r11

    lsr r11, r10, #2
    and r11, r11, #1
    lsl r11, r11, #14
    orr r9, r9, r11


    lsr r11, r10, #30
    and r11, r11, #1
    lsl r11, r11, #15
    orr r9, r9, r11

    // SECOND SHARE part 1

    ldr r10, [r1, #0]


    lsr r11, r10, #26
    and r11, r11, #1
    lsl r11, r11, #0
    orr r9, r9, r11

    lsr r11, r10, #22
    and r11, r11, #1
    lsl r11, r11, #1
    orr r9, r9, r11

    lsr r11, r10, #18
    and r11, r11, #1
    lsl r11, r11, #2
    orr r9, r9, r11

    lsr r11, r10, #14
    and r11, r11, #1
    lsl r11, r11, #3
    orr r9, r9, r11

    lsr r11, r10, #10
    and r11, r11, #1
    lsl r11, r11, #4
    orr r9, r9, r11

    lsr r11, r10, #6
    and r11, r11, #1
    lsl r11, r11, #5
    orr r9, r9, r11

    lsr r11, r10, #2
    and r11, r11, #1
    lsl r11, r11, #6
    orr r9, r9, r11


    lsr r11, r10, #30
    and r11, r11, #1
    lsl r11, r11, #7
    orr r9, r9, r11



    ////////////////////////////////////////////
    ///////////////// NOW SBOX /////////////////
    ////////////////////////////////////////////


    ///////////////////////////////// A //////////////////////////////


    // shares A
    mov r0, r2
    mov r1, r3
    mov r10, r4
    mov r11, r5
    bl A
    mov r2, r0
    mov r3, r1
    mov r4, r10
    mov r5, r11

    // shares B
    mov r0, r6
    mov r1, r7
    mov r10, r8
    mov r11, r9
    bl A
    mov r6, r0
    mov r7, r1
    mov r8, r10
    mov r9, r11



    ///////////////////////////////// Q12 //////////////////////////////

    /////////// PTs(b,a,c) ///////////
    and r14, r5, r3 // a0c0
    eor r4, r4, r14 // b0 + a0c0

    ////////////// b0 + a0c0 + a0c1
    // a0c1
    big_ror_2 r5
    big_ror_1 r7
    and r14, r5, r7
    big_rol_2 r5
    big_rol_1 r7
    big_ror_2 r4
    eor r4, r4, r14
    big_rol_2 r4
    ////////////// r8 + r1c1
    // a1c1
    and r14, r9, r7
    eor r8, r8, r14
    ////////////// b1 + a1c1 + a1c0
    // a1c0
    big_ror_2 r3
    big_ror_1 r9
    and r14, r3, r9
    big_rol_2 r3
    big_rol_1 r9
    big_ror_1 r8
    eor r8, r8, r14
    big_rol_1 r8


    /////////// PTs(c,a,b) ///////////
    ////////////// c0 + a0b0
    // a0b0
    and r14, r5, r4
    eor r3, r3, r14

    ////////////// c0 + a0b0 + a0b1
    // a0b1
    big_ror_2 r5
    big_ror_1 r8
    and r14, r5, r8
    big_rol_2 r5
    big_rol_1 r8
    big_ror_2 r3
    eor r3, r3, r14
    big_rol_2 r3

    ////////////// c1 + a1b1
    // r1b1
    and r14, r9, r8
    eor r7, r7, r14

    ////////////// c1 + a1b1 + a1b0
    // a1b0
    big_ror_2 r4
    big_ror_1 r9
    and r14, r4, r9
    big_rol_2 r4
    big_rol_1 r9
    big_ror_1 r7
    eor r7, r7, r14
    big_rol_1 r7



   // shares A''
    bl App_a

    // shares B
    bl App_b



    ///////////////////////////////// A''' //////////////////////////////
    // shares A
    bl Appp_a

    // shares B
    bl Appp_b



    ///////////////////////////////// A //////////////////////////////
    // shares A
    mov r0, r2
    mov r1, r3
    mov r10, r4
    mov r11, r5
    bl A
    mov r2, r0
    mov r3, r1
    mov r4, r10
    mov r5, r11

    // shares B
    mov r0, r6
    mov r1, r7
    mov r10, r8
    mov r11, r9
    bl A
    mov r6, r0
    mov r7, r1
    mov r8, r10
    mov r9, r11


    ///////////////////////////////// Q12 //////////////////////////////

    /////////// PTs(b,a,c) ///////////


    and r14, r5, r3
    eor r4, r4, r14

    big_ror_2 r5
    big_ror_1 r7
    and r14, r5, r7
    big_rol_2 r5
    big_rol_1 r7
    big_ror_2 r4
    eor r4, r4, r14
    big_rol_2 r4

    and r14, r9, r7
    eor r8, r8, r14

    big_ror_2 r3
    big_ror_1 r9
    and r14, r3, r9
    big_rol_2 r3
    big_rol_1 r9
    big_ror_1 r8
    eor r8, r8, r14
    big_rol_1 r8


    and r14, r5, r4
    eor r3, r3, r14

    big_ror_2 r5
    big_ror_1 r8
    and r14, r5, r8
    big_rol_2 r5
    big_rol_1 r8
    big_ror_2 r3
    eor r3, r3, r14
    big_rol_2 r3

    and r14, r9, r8
    eor r7, r7, r14

    big_ror_2 r4
    big_ror_1 r9
    and r14, r4, r9
    big_rol_2 r4
    big_rol_1 r9
    big_ror_1 r7
    eor r7, r7, r14
    big_rol_1 r7



    ///////////////////////////////// A'' //////////////////////////////
    // shares A
    bl App_a

    // shares B
    bl App_b


    ////////////////////////////////////////
    ////////////////////////////////////////
    //// Reconstruct registers format //////
    ////////////////////////////////////////
    ////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////  reconstruct share A     //////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


    // Share A block 2

    mov r10, #0
    mov r11, #0

    ldr r0, [sp, #0]
    ldr r1, [sp, #4]
    str r10, [r0, #0]
    str r10, [r0, #4]
    str r10, [r1, #0]
    str r10, [r1, #4]

    lsr r11, r2, 8
    and r11, r11, #1
    lsl r11, r11, #28
    eor r10, r10, r11

    lsr r11, r2, 9
    and r11, r11, #1
    lsl r11, r11, #24
    eor r10, r10, r11

    lsr r11, r2, 10
    and r11, r11, #1
    lsl r11, r11, #20
    eor r10, r10, r11

    lsr r11, r2, 11
    and r11, r11, #1
    lsl r11, r11, #16
    eor r10, r10, r11

    lsr r11, r2, 12
    and r11, r11, #1
    lsl r11, r11, #12
    eor r10, r10, r11

    lsr r11, r2, 13
    and r11, r11, #1
    lsl r11, r11, #8
    eor r10, r10, r11

    lsr r11, r2, 14
    and r11, r11, #1
    lsl r11, r11, #4
    eor r10, r10, r11

    lsr r11, r2, 15
    and r11, r11, #1
    eor r10, r10, r11

    lsr r11, r3, 8
    and r11, r11, #1
    lsl r11, r11, #29
    eor r10, r10, r11

    lsr r11, r3, 9
    and r11, r11, #1
    lsl r11, r11, #25
    eor r10, r10, r11

    lsr r11, r3, 10
    and r11, r11, #1
    lsl r11, r11, #21
    eor r10, r10, r11

    lsr r11, r3, 11
    and r11, r11, #1
    lsl r11, r11, #17
    eor r10, r10, r11

    lsr r11, r3, 12
    and r11, r11, #1
    lsl r11, r11, #13
    eor r10, r10, r11

    lsr r11, r3, 13
    and r11, r11, #1
    lsl r11, r11, #9
    eor r10, r10, r11

    lsr r11, r3, 14
    and r11, r11, #1
    lsl r11, r11, #5
    eor r10, r10, r11

    lsr r11, r3, 15
    and r11, r11, #1
    lsl r11, r11, #1
    eor r10, r10, r11


    lsr r11, r4, 8
    and r11, r11, #1
    lsl r11, r11, #30
    eor r10, r10, r11

    lsr r11, r4, 9
    and r11, r11, #1
    lsl r11, r11, #26
    eor r10, r10, r11

    lsr r11, r4, 10
    and r11, r11, #1
    lsl r11, r11, #22
    eor r10, r10, r11

    lsr r11, r4, 11
    and r11, r11, #1
    lsl r11, r11, #18
    eor r10, r10, r11

    lsr r11, r4, 12
    and r11, r11, #1
    lsl r11, r11, #14
    eor r10, r10, r11

    lsr r11, r4, 13
    and r11, r11, #1
    lsl r11, r11, #10
    eor r10, r10, r11

    lsr r11, r4, 14
    and r11, r11, #1
    lsl r11, r11, #6
    eor r10, r10, r11

    lsr r11, r4, 15
    and r11, r11, #1
    lsl r11, r11, #2
    eor r10, r10, r11

    lsr r11, r5, 8
    and r11, r11, #1
    lsl r11, r11, #31
    eor r10, r10, r11

    lsr r11, r5, 9
    and r11, r11, #1
    lsl r11, r11, #27
    eor r10, r10, r11

    lsr r11, r5, 10
    and r11, r11, #1
    lsl r11, r11, #23
    eor r10, r10, r11

    lsr r11, r5, 11
    and r11, r11, #1
    lsl r11, r11, #19
    eor r10, r10, r11

    lsr r11, r5, 12
    and r11, r11, #1
    lsl r11, r11, #15
    eor r10, r10, r11

    lsr r11, r5, 13
    and r11, r11, #1
    lsl r11, r11, #11
    eor r10, r10, r11

    lsr r11, r5, 14
    and r11, r11, #1
    lsl r11, r11, #7
    eor r10, r10, r11

    lsr r11, r5, 15
    and r11, r11, #1
    lsl r11, r11, #3
    eor r10, r10, r11 // This is Sbox(Share A part 2)


    // Share A block 1
    mov r12, 0

    lsr r11, r2, 0
    and r11, r11, #1
    lsl r11, r11, #28
    eor r12, r12, r11

    lsr r11, r2, 1
    and r11, r11, #1
    lsl r11, r11, #24
    eor r12, r12, r11

    lsr r11, r2, 2
    and r11, r11, #1
    lsl r11, r11, #20
    eor r12, r12, r11

    lsr r11, r2, 3
    and r11, r11, #1
    lsl r11, r11, #16
    eor r12, r12, r11

    lsr r11, r2, 4
    and r11, r11, #1
    lsl r11, r11, #12
    eor r12, r12, r11

    lsr r11, r2, 5
    and r11, r11, #1
    lsl r11, r11, #8
    eor r12, r12, r11

    lsr r11, r2, 6
    and r11, r11, #1
    lsl r11, r11, #4
    eor r12, r12, r11

    lsr r11, r2, 7
    and r11, r11, #1
    eor r12, r12, r11

    lsr r11, r3, 0
    and r11, r11, #1
    lsl r11, r11, #29
    eor r12, r12, r11

    lsr r11, r3, 1
    and r11, r11, #1
    lsl r11, r11, #25
    eor r12, r12, r11

    lsr r11, r3, 2
    and r11, r11, #1
    lsl r11, r11, #21
    eor r12, r12, r11

    lsr r11, r3, 3
    and r11, r11, #1
    lsl r11, r11, #17
    eor r12, r12, r11

    lsr r11, r3, 4
    and r11, r11, #1
    lsl r11, r11, #13
    eor r12, r12, r11

    lsr r11, r3, 5
    and r11, r11, #1
    lsl r11, r11, #9
    eor r12, r12, r11

    lsr r11, r3, 6
    and r11, r11, #1
    lsl r11, r11, #5
    eor r12, r12, r11

    lsr r11, r3, 7
    and r11, r11, #1
    lsl r11, r11, #1
    eor r12, r12, r11


    lsr r11, r4, 0
    and r11, r11, #1
    lsl r11, r11, #30
    eor r12, r12, r11

    lsr r11, r4, 1
    and r11, r11, #1
    lsl r11, r11, #26
    eor r12, r12, r11

    lsr r11, r4, 2
    and r11, r11, #1
    lsl r11, r11, #22
    eor r12, r12, r11

    lsr r11, r4, 3
    and r11, r11, #1
    lsl r11, r11, #18
    eor r12, r12, r11

    lsr r11, r4, 4
    and r11, r11, #1
    lsl r11, r11, #14
    eor r12, r12, r11

    lsr r11, r4, 5
    and r11, r11, #1
    lsl r11, r11, #10
    eor r12, r12, r11

    lsr r11, r4, 6
    and r11, r11, #1
    lsl r11, r11, #6
    eor r12, r12, r11

    lsr r11, r4, 7
    and r11, r11, #1
    lsl r11, r11, #2
    eor r12, r12, r11

    lsr r11, r5, 0
    and r11, r11, #1
    lsl r11, r11, #31
    eor r12, r12, r11

    lsr r11, r5, 1
    and r11, r11, #1
    lsl r11, r11, #27
    eor r12, r12, r11

    lsr r11, r5, 2
    and r11, r11, #1
    lsl r11, r11, #23
    eor r12, r12, r11

    lsr r11, r5, 3
    and r11, r11, #1
    lsl r11, r11, #19
    eor r12, r12, r11

    lsr r11, r5, 4
    and r11, r11, #1
    lsl r11, r11, #15
    eor r12, r12, r11

    lsr r11, r5, 5
    and r11, r11, #1
    lsl r11, r11, #11
    eor r12, r12, r11

    lsr r11, r5, 6
    and r11, r11, #1
    lsl r11, r11, #7
    eor r12, r12, r11

    lsr r11, r5, 7
    and r11, r11, #1
    lsl r11, r11, #3
    eor r12, r12, r11 // This is Sbox(Share A part 1)


    mov r2, #0
    mov r3, #0
    mov r4, #0
    mov r5, #0

    mov r2, r12
    mov r3, r10

    eor r10, r4, r5
    eor r11, r4, r5
    eor r12, r4, r5



////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////  reconstruct share B     //////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    // Share B block 2

    mov r10, 0

    lsr r11, r6, 8
    and r11, r11, #1
    lsl r11, r11, #23
    eor r10, r10, r11

    lsr r11, r6, 9
    and r11, r11, #1
    lsl r11, r11, #19
    eor r10, r10, r11

    lsr r11, r6, 10
    and r11, r11, #1
    lsl r11, r11, #15
    eor r10, r10, r11

    lsr r11, r6, 11
    and r11, r11, #1
    lsl r11, r11, #11
    eor r10, r10, r11

    lsr r11, r6, 12
    and r11, r11, #1
    lsl r11, r11, #7
    eor r10, r10, r11

    lsr r11, r6, 13
    and r11, r11, #1
    lsl r11, r11, #3
    eor r10, r10, r11

    lsr r11, r6, 14
    and r11, r11, #1
    lsl r11, r11, #31
    eor r10, r10, r11

    lsr r11, r6, 15
    and r11, r11, #1
    lsl r11, r11, #27
    eor r10, r10, r11

    lsr r11, r7, 8
    and r11, r11, #1
    lsl r11, r11, #24
    eor r10, r10, r11

    lsr r11, r7, 9
    and r11, r11, #1
    lsl r11, r11, #20
    eor r10, r10, r11

    lsr r11, r7, 10
    and r11, r11, #1
    lsl r11, r11, #16
    eor r10, r10, r11

    lsr r11, r7, 11
    and r11, r11, #1
    lsl r11, r11, #12
    eor r10, r10, r11

    lsr r11, r7, 12
    and r11, r11, #1
    lsl r11, r11, #8
    eor r10, r10, r11

    lsr r11, r7, 13
    and r11, r11, #1
    lsl r11, r11, #4
    eor r10, r10, r11

    lsr r11, r7, 14
    and r11, r11, #1
    lsl r11, r11, #0
    eor r10, r10, r11

    lsr r11, r7, 15
    and r11, r11, #1
    lsl r11, r11, #28
    eor r10, r10, r11


    lsr r11, r8, 8
    and r11, r11, #1
    lsl r11, r11, #25
    eor r10, r10, r11

    lsr r11, r8, 9
    and r11, r11, #1
    lsl r11, r11, #21
    eor r10, r10, r11

    lsr r11, r8, 10
    and r11, r11, #1
    lsl r11, r11, #17
    eor r10, r10, r11

    lsr r11, r8, 11
    and r11, r11, #1
    lsl r11, r11, #13
    eor r10, r10, r11

    lsr r11, r8, 12
    and r11, r11, #1
    lsl r11, r11, #9
    eor r10, r10, r11

    lsr r11, r8, 13
    and r11, r11, #1
    lsl r11, r11, #5
    eor r10, r10, r11

    lsr r11, r8, 14
    and r11, r11, #1
    lsl r11, r11, #1
    eor r10, r10, r11

    lsr r11, r8, 15
    and r11, r11, #1
    lsl r11, r11, #29
    eor r10, r10, r11

    lsr r11, r9, 8
    and r11, r11, #1
    lsl r11, r11, #26
    eor r10, r10, r11

    lsr r11, r9, 9
    and r11, r11, #1
    lsl r11, r11, #22
    eor r10, r10, r11

    lsr r11, r9, 10
    and r11, r11, #1
    lsl r11, r11, #18
    eor r10, r10, r11

    lsr r11, r9, 11
    and r11, r11, #1
    lsl r11, r11, #14
    eor r10, r10, r11

    lsr r11, r9, 12
    and r11, r11, #1
    lsl r11, r11, #10
    eor r10, r10, r11

    lsr r11, r9, 13
    and r11, r11, #1
    lsl r11, r11, #6
    eor r10, r10, r11

    lsr r11, r9, 14
    and r11, r11, #1
    lsl r11, r11, #2
    eor r10, r10, r11

    lsr r11, r9, 15
    and r11, r11, #1
    lsl r11, r11, #30
    eor r10, r10, r11 // This is Sbox(Share B part 2)


    // Share B block 1
    mov r12, 0

    lsr r11, r6, 0
    and r11, r11, #1
    lsl r11, r11, #23
    eor r12, r12, r11

    lsr r11, r6, 1
    and r11, r11, #1
    lsl r11, r11, #19
    eor r12, r12, r11

    lsr r11, r6, 2
    and r11, r11, #1
    lsl r11, r11, #15
    eor r12, r12, r11

    lsr r11, r6, 3
    and r11, r11, #1
    lsl r11, r11, #11
    eor r12, r12, r11

    lsr r11, r6, 4
    and r11, r11, #1
    lsl r11, r11, #7
    eor r12, r12, r11

    lsr r11, r6, 5
    and r11, r11, #1
    lsl r11, r11, #3
    eor r12, r12, r11

    lsr r11, r6, 6
    and r11, r11, #1
    lsl r11, r11, #31
    eor r12, r12, r11

    lsr r11, r6, 7
    and r11, r11, #1
    lsl r11, r11, #27
    eor r12, r12, r11

    lsr r11, r7, 0
    and r11, r11, #1
    lsl r11, r11, #24
    eor r12, r12, r11

    lsr r11, r7, 1
    and r11, r11, #1
    lsl r11, r11, #20
    eor r12, r12, r11

    lsr r11, r7, 2
    and r11, r11, #1
    lsl r11, r11, #16
    eor r12, r12, r11

    lsr r11, r7, 3
    and r11, r11, #1
    lsl r11, r11, #12
    eor r12, r12, r11

    lsr r11, r7, 4
    and r11, r11, #1
    lsl r11, r11, #8
    eor r12, r12, r11

    lsr r11, r7, 5
    and r11, r11, #1
    lsl r11, r11, #4
    eor r12, r12, r11

    lsr r11, r7, 6
    and r11, r11, #1
    lsl r11, r11, #0
    eor r12, r12, r11

    lsr r11, r7, 7
    and r11, r11, #1
    lsl r11, r11, #28
    eor r12, r12, r11

    lsr r11, r8, 0
    and r11, r11, #1
    lsl r11, r11, #25
    eor r12, r12, r11

    lsr r11, r8, 1
    and r11, r11, #1
    lsl r11, r11, #21
    eor r12, r12, r11

    lsr r11, r8, 2
    and r11, r11, #1
    lsl r11, r11, #17
    eor r12, r12, r11

    lsr r11, r8, 3
    and r11, r11, #1
    lsl r11, r11, #13
    eor r12, r12, r11

    lsr r11, r8, 4
    and r11, r11, #1
    lsl r11, r11, #9
    eor r12, r12, r11

    lsr r11, r8, 5
    and r11, r11, #1
    lsl r11, r11, #5
    eor r12, r12, r11

    lsr r11, r8, 6
    and r11, r11, #1
    lsl r11, r11, #1
    eor r12, r12, r11

    lsr r11, r8, 7
    and r11, r11, #1
    lsl r11, r11, #29
    eor r12, r12, r11

    lsr r11, r9, 0
    and r11, r11, #1
    lsl r11, r11, #26
    eor r12, r12, r11

    lsr r11, r9, 1
    and r11, r11, #1
    lsl r11, r11, #22
    eor r12, r12, r11

    lsr r11, r9, 2
    and r11, r11, #1
    lsl r11, r11, #18
    eor r12, r12, r11

    lsr r11, r9, 3
    and r11, r11, #1
    lsl r11, r11, #14
    eor r12, r12, r11

    lsr r11, r9, 4
    and r11, r11, #1
    lsl r11, r11, #10
    eor r12, r12, r11

    lsr r11, r9, 5
    and r11, r11, #1
    lsl r11, r11, #6
    eor r12, r12, r11

    lsr r11, r9, 6
    and r11, r11, #1
    lsl r11, r11, #2
    eor r12, r12, r11

    lsr r11, r9, 7
    and r11, r11, #1
    lsl r11, r11, #30
    eor r12, r12, r11 // This is Sbox(Share B part 1)


    mov r6, #0
    mov r7, #0
    eor r8, r6, r7
    eor r9, r6, r7


////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////// PLAYER B ///////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


    mov r6, r12 // PART 1 SHARE B
    eor r12, r8, r9
    mov r7, r10 // PART 2 SHARE B
    eor r10, r8, r9


    mov r8, #0
    mov r9, #0


    //////////////////////////////////////////// PART 1
    // place from 31 to 0

    lsr r10, r6, #31
    and r10, r10, #1
    lsl r8, r10, #31


    lsr r10, r7, #28
    and r10, r10, #1
    lsl r10, r10, #30
    orr r8, r8, r10

    // 58 mod 32
    lsr r10, r7, #24
    and r10, r10, #1
    lsl r10, r10, #29
    orr r8, r8, r10

    // 54 mod 32
    lsr r10, r7, #20
    and r10, r10, #1
    lsl r10, r10, #28
    orr r8, r8, r10

    // 50 mod 32
    lsr r10, r7, #16
    and r10, r10, #1
    lsl r10, r10, #27
    orr r8, r8, r10

    // 46 mod 32
    lsr r10, r7, #12
    and r10, r10, #1
    lsl r10, r10, #26
    orr r8, r8, r10

    // 42 mod 32
    lsr r10, r7, #8
    and r10, r10, #1
    lsl r10, r10, #25
    orr r8, r8, r10

    // 38 mod 32
    lsr r10, r7, #4
    and r10, r10, #1
    lsl r10, r10, #24
    orr r8, r8, r10

    // 34 mod 32
    lsr r10, r7, #0
    and r10, r10, #1
    lsl r10, r10, #23
    orr r8, r8, r10

    // 26 mod 32
    lsr r10, r6, #28
    and r10, r10, #1
    lsl r10, r10, #22
    orr r8, r8, r10

    // 22 mod 32
    lsr r10, r6, #24
    and r10, r10, #1
    lsl r10, r10, #21
    orr r8, r8, r10

    // 18 mod 32
    lsr r10, r6, #20
    and r10, r10, #1
    lsl r10, r10, #20
    orr r8, r8, r10

    // 14 mod 32
    lsr r10, r6, #16
    and r10, r10, #1
    lsl r10, r10, #19
    orr r8, r8, r10

    // 10 mod 32
    lsr r10, r6, #12
    and r10, r10, #1
    lsl r10, r10, #18
    orr r8, r8, r10

    // 6 mod 32
    lsr r10, r6, #8
    and r10, r10, #1
    lsl r10, r10, #17
    orr r8, r8, r10

    // 2 mod 32
    lsr r10, r6, #4
    and r10, r10, #1
    lsl r10, r10, #16
    orr r8, r8, r10

    // 61 mod 32
    lsr r10, r6, #0
    and r10, r10, #1
    lsl r10, r10, #15
    orr r8, r8, r10

    // 61 mod 32
    lsr r10, r7, #27
    and r10, r10, #1
    lsl r10, r10, #14
    orr r8, r8, r10

    // 53 mod 32
    lsr r10, r7, #23
    and r10, r10, #1
    lsl r10, r10, #13
    orr r8, r8, r10

    // 49 mod 32
    lsr r10, r7, #19
    and r10, r10, #1
    lsl r10, r10, #12
    orr r8, r8, r10

    // 45 mod 32
    lsr r10, r7, #15
    and r10, r10, #1
    lsl r10, r10, #11
    orr r8, r8, r10

    // 41 mod 32
    lsr r10, r7, #11
    and r10, r10, #1
    lsl r10, r10, #10
    orr r8, r8, r10

    // 37 mod 32
    lsr r10, r7, #7
    and r10, r10, #1
    lsl r10, r10, #9
    orr r8, r8, r10

    // 33 mod 32
    lsr r10, r7, #3
    and r10, r10, #1
    lsl r10, r10, #8
    orr r8, r8, r10

    // 29 mod 32
    lsr r10, r7, #31
    and r10, r10, #1
    lsl r10, r10, #7
    orr r8, r8, r10

    // 25 mod 32
    lsr r10, r6, #27
    and r10, r10, #1
    lsl r10, r10, #6
    orr r8, r8, r10

    // 21 mod 32
    lsr r10, r6, #23
    and r10, r10, #1
    lsl r10, r10, #5
    orr r8, r8, r10

    // 17 mod 32
    lsr r10, r6, #19
    and r10, r10, #1
    lsl r10, r10, #4
    orr r8, r8, r10

    // 13 mod 32
    lsr r10, r6, #15
    and r10, r10, #1
    lsl r10, r10, #3
    orr r8, r8, r10

    // 9 mod 32
    lsr r10, r6, #11
    and r10, r10, #1
    lsl r10, r10, #2
    orr r8, r8, r10

    // 5 mod 32
    lsr r10, r6, #7
    and r10, r10, #1
    lsl r10, r10, #1
    orr r8, r8, r10

    // 1 mod 32
    lsr r10, r6, #3
    and r10, r10, #1
    lsl r10, r10, #0
    orr r8, r8, r10 // This is Permute(shareB.part1)





//////////////////////////////////////////// PART 2
    // place from 31 to 0

    // 60 mod 32
    lsr r10, r6, #1
    and r10, r10, #1
    lsl r9, r10, #31

    // 56 mod 32
    lsr r10, r7, #30
    and r10, r10, #1
    lsl r10, r10, #30
    orr r9, r9, r10

    // 52 mod 32
    lsr r10, r7, #26
    and r10, r10, #1
    lsl r10, r10, #29
    orr r9, r9, r10

    // 48 mod 32
    lsr r10, r7, #22
    and r10, r10, #1
    lsl r10, r10, #28
    orr r9, r9, r10

    // 44 mod 32
    lsr r10, r7, #18
    and r10, r10, #1
    lsl r10, r10, #27
    orr r9, r9, r10

    // 40 mod 32
    lsr r10, r7, #14
    and r10, r10, #1
    lsl r10, r10, #26
    orr r9, r9, r10

    // 36 mod 32
    lsr r10, r7, #10
    and r10, r10, #1
    lsl r10, r10, #25
    orr r9, r9, r10

    // 32 mod 32
    lsr r10, r7, #6
    and r10, r10, #1
    lsl r10, r10, #24
    orr r9, r9, r10

    // 28 mod 32
    lsr r10, r7, #2
    and r10, r10, #1
    lsl r10, r10, #23
    orr r9, r9, r10

    lsr r10, r6, #30
    and r10, r10, #1
    lsl r10, r10, #22
    orr r9, r9, r10

    lsr r10, r6, #26
    and r10, r10, #1
    lsl r10, r10, #21
    orr r9, r9, r10

    lsr r10, r6, #22
    and r10, r10, #1
    lsl r10, r10, #20
    orr r9, r9, r10

    lsr r10, r6, #18
    and r10, r10, #1
    lsl r10, r10, #19
    orr r9, r9, r10

    lsr r10, r6, #14
    and r10, r10, #1
    lsl r10, r10, #18
    orr r9, r9, r10

    lsr r10, r6, #10
    and r10, r10, #1
    lsl r10, r10, #17
    orr r9, r9, r10

    // 63 mod 32
    lsr r10, r6, #6
    and r10, r10, #1
    lsl r10, r10, #16
    orr r9, r9, r10

    // 59 mod 32
    lsr r10, r6, #2
    and r10, r10, #1
    lsl r10, r10, #15
    orr r9, r9, r10

    // 55 mod 32
    lsr r10, r7, #29
    and r10, r10, #1
    lsl r10, r10, #14
    orr r9, r9, r10

    // 51 mod 32
    lsr r10, r7, #25
    and r10, r10, #1
    lsl r10, r10, #13
    orr r9, r9, r10

    // 47 mod 32
    lsr r10, r7, #21
    and r10, r10, #1
    lsl r10, r10, #12
    orr r9, r9, r10

    // 43 mod 32
    lsr r10, r7, #17
    and r10, r10, #1
    lsl r10, r10, #11
    orr r9, r9, r10

    // 39 mod 32
    lsr r10, r7, #13
    and r10, r10, #1
    lsl r10, r10, #10
    orr r9, r9, r10

    // 35 mod 32
    lsr r10, r7, #9
    and r10, r10, #1
    lsl r10, r10, #9
    orr r9, r9, r10

    // 31 mod 32
    lsr r10, r7, #5
    and r10, r10, #1
    lsl r10, r10, #8
    orr r9, r9, r10

    lsr r10, r7, #1
    and r10, r10, #1
    lsl r10, r10, #7
    orr r9, r9, r10

    lsr r10, r6, #29
    and r10, r10, #1
    lsl r10, r10, #6
    orr r9, r9, r10

    lsr r10, r6, #25
    and r10, r10, #1
    lsl r10, r10, #5
    orr r9, r9, r10

    lsr r10, r6, #21
    and r10, r10, #1
    lsl r10, r10, #4
    orr r9, r9, r10

    lsr r10, r6, #17
    and r10, r10, #1
    lsl r10, r10, #3
    orr r9, r9, r10

    lsr r10, r6, #13
    and r10, r10, #1
    lsl r10, r10, #2
    orr r9, r9, r10

    lsr r10, r6, #9
    and r10, r10, #1
    lsl r10, r10, #1
    orr r9, r9, r10

    // 64 mod 32
    lsr r10, r6, #5
    and r10, r10, #1
    lsl r10, r10, #0
    orr r9, r9, r10 // // This is Permute(shareB.part2)


    //store updated part 1 with lower bits
    str r8, [r1, #0]
    //store updated part 2 with higher bits
    str r9, [r1, #4]

    mov r6, #0
    mov r7, #0
    eor r8, r6, r7
    eor r9, r6, r7
    eor r10, r6, r7


////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////// PLAYER A ///////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////



    //updated registers
    mov r4, #0
    mov r5, #0


    //////////////////////////////////////////// PART 1

    // 0 -> 0
    and r4, r2, #1

    // 1 -> 16
    lsr r10, r2, #1 // get bit 1
    and r10, r10, #1
    lsl r10, r10, #16
    orr r4, r4, r10

    // 2 -> 32 % 32 = 0
    lsr r10, r2, #2 // get bit 2
    and r10, r10, #1
    orr r5, r5, r10

    // 3 -> 48
    lsr r10, r2, #3 // get bit 3
    and r10, r10, #1
    lsl r10, r10, #16
    orr r5, r5, r10

    // 4 -> 1
    lsr r10, r2, #4 // get bit 4
    and r10, r10, #1
    lsl r10, r10, #1
    orr r4, r4, r10

    // 5 -> 17
    lsr r10, r2, #5 // get bit
    and r10, r10, #1
    lsl r10, r10, #17
    orr r4, r4, r10

    // 6 -> 33 % 32 = 1
    lsr r10, r2, #6 // get bit
    and r10, r10, #1
    lsl r10, r10, #1
    orr r5, r5, r10


    // 7 -> 49 % 32 = 17
    lsr r10, r2, #7 // get bit
    and r10, r10, #1
    lsl r10, r10, #17
    orr r5, r5, r10


    // 8 -> 2
    lsr r10, r2, #8 // get bit
    and r10, r10, #1
    lsl r10, r10, #2
    orr r4, r4, r10

    // 9 -> 18
    lsr r10, r2, #9 // get bit
    and r10, r10, #1
    lsl r10, r10, #18
    orr r4, r4, r10

    // 10 -> 34 % 32 = 2
    lsr r10, r2, #10 // get bit
    and r10, r10, #1
    lsl r10, r10, #2
    orr r5, r5, r10

    // 11 -> 50 % 32 = 18
    lsr r10, r2, #11 // get bit
    and r10, r10, #1
    lsl r10, r10, #18
    orr r5, r5, r10

    // 12 -> 3
    lsr r10, r2, #12 // get bit
    and r10, r10, #1
    lsl r10, r10, #3
    orr r4, r4, r10

    // 13 -> 19
    lsr r10, r2, #13 // get bit
    and r10, r10, #1
    lsl r10, r10, #19
    orr r4, r4, r10

    // 14 -> 35 % 32 = 3
    lsr r10, r2, #14 // get bit
    and r10, r10, #1
    lsl r10, r10, #3
    orr r5, r5, r10

    // 15 -> 5 % 32 = 19
    lsr r10, r2, #15 // get bit
    and r10, r10, #1
    lsl r10, r10, #19
    orr r5, r5, r10

    // 16 -> 4
    lsr r10, r2, #16 // get bit
    and r10, r10, #1
    lsl r10, r10, #4
    orr r4, r4, r10

    // 17-> 20
    lsr r10, r2, #17 // get bit
    and r10, r10, #1
    lsl r10, r10, #20
    orr r4, r4, r10


    // 18 -> 36 % 32 = 4
    lsr r10, r2, #18 // get bit
    and r10, r10, #1
    lsl r10, r10, #4
    orr r5, r5, r10

    // 19 -> 52 % 32 = 20
    lsr r10, r2, #19 // get bit
    and r10, r10, #1
    lsl r10, r10, #20
    orr r5, r5, r10


    // 20-> 5
    lsr r10, r2, #20 // get bit
    and r10, r10, #1
    lsl r10, r10, #5
    orr r4, r4, r10


    // 21-> 21
    lsr r10, r2, #21 // get bit
    and r10, r10, #1
    lsl r10, r10, #21
    orr r4, r4, r10

    // 22 -> 37 % 32 = 5
    lsr r10, r2, #22 // get bit
    and r10, r10, #1
    lsl r10, r10, #5
    orr r5, r5, r10

    // 23 -> 53 % 32 = 21
    lsr r10, r2, #23 // get bit
    and r10, r10, #1
    lsl r10, r10, #21
    orr r5, r5, r10

    // 24 -> 6
    lsr r10, r2, #24 // get bit
    and r10, r10, #1
    lsl r10, r10, #6
    orr r4, r4, r10

    // 25 -> 22
    lsr r10, r2, #25 // get bit
    and r10, r10, #1
    lsl r10, r10, #22
    orr r4, r4, r10

    // 26 -> 38 % 32 = 6
    lsr r10, r2, #26 // get bit
    and r10, r10, #1
    lsl r10, r10, #6
    orr r5, r5, r10

    // 27 -> 54 % 32 =22
    lsr r10, r2, #27 // get bit
    and r10, r10, #1
    lsl r10, r10, #22
    orr r5, r5, r10

    // 28 -> 7
    lsr r10, r2, #28 // get bit
    and r10, r10, #1
    lsl r10, r10, #7
    orr r4, r4, r10

    // 29 -> 23
    lsr r10, r2, #29 // get bit
    and r10, r10, #1
    lsl r10, r10, #23
    orr r4, r4, r10

    // 30 -> 39 % 32 = 7
    lsr r10, r2, #30 // get bit
    and r10, r10, #1
    lsl r10, r10, #7
    orr r5, r5, r10

    // 31 -> 55 % 32 = 23
    lsr r10, r2, #31 // get bit
    and r10, r10, #1
    lsl r10, r10, #23
    orr r5, r5, r10

    //////////////////////////////////////////// PART 2

    // 0 -> 8
    and r10, r3, #1
    lsl r10, r10, #8
    orr r4, r4, r10

    // 1 -> 24
    lsr r10, r3, #1 // get bit
    and r10, r10, #1
    lsl r10, r10, #24
    orr r4, r4, r10


    // 2 -> 40 % 32 = 8
    lsr r10, r3, #2 // get bit
    and r10, r10, #1
    lsl r10, r10, #8
    orr r5, r5, r10

    // 3 -> 56 % 32 = 24
    lsr r10, r3, #3 // get bit
    and r10, r10, #1
    lsl r10, r10, #24
    orr r5, r5, r10

    // 4 -> 9
    lsr r10, r3, #4 // get bit
    and r10, r10, #1
    lsl r10, r10, #9
    orr r4, r4, r10

    // 5 -> 25
    lsr r10, r3, #5 // get bit
    and r10, r10, #1
    lsl r10, r10, #25
    orr r4, r4, r10

    // 6 -> 41 % 32 = 9
    lsr r10, r3, #6 // get bit
    and r10, r10, #1
    lsl r10, r10, #9
    orr r5, r5, r10

    // 7 -> 57 % 32 = 25
    lsr r10, r3, #7 // get bit
    and r10, r10, #1
    lsl r10, r10, #25
    orr r5, r5, r10

    // 8 -> 10
    lsr r10, r3, #8 // get bit
    and r10, r10, #1
    lsl r10, r10, #10
    orr r4, r4, r10

    // 9 -> 26
    lsr r10, r3, #9 // get bit
    and r10, r10, #1
    lsl r10, r10, #26
    orr r4, r4, r10

    // 10 -> 42 % 32 = 10
    lsr r10, r3, #10 // get bit
    and r10, r10, #1
    lsl r10, r10, #10
    orr r5, r5, r10

    // 11 -> 58 % 32 = 26
    lsr r10, r3, #11 // get bit
    and r10, r10, #1
    lsl r10, r10, #26
    orr r5, r5, r10

    // 12 -> 11
    lsr r10, r3, #12 // get bit
    and r10, r10, #1
    lsl r10, r10, #11
    orr r4, r4, r10

    // 13 -> 27
    lsr r10, r3, #13 // get bit
    and r10, r10, #1
    lsl r10, r10, #27
    orr r4, r4, r10

    // 14 -> 43 % 32 = 11
    lsr r10, r3, #14 // get bit
    and r10, r10, #1
    lsl r10, r10, #11
    orr r5, r5, r10


    // 15 -> 59 % 32 = 27
    lsr r10, r3, #15 // get bit
    and r10, r10, #1
    lsl r10, r10, #27
    orr r5, r5, r10


    // 16 -> 12
    lsr r10, r3, #16 // get bit
    and r10, r10, #1
    lsl r10, r10, #12
    orr r4, r4, r10

    // 17 -> 28
    lsr r10, r3, #17 // get bit
    and r10, r10, #1
    lsl r10, r10, #28
    orr r4, r4, r10

    // 18 -> 44 % 32 = 12
    lsr r10, r3, #18 // get bit
    and r10, r10, #1
    lsl r10, r10, #12
    orr r5, r5, r10

    // 19 -> 60 % 32 = 28
    lsr r10, r3, #19 // get bit
    and r10, r10, #1
    lsl r10, r10, #28
    orr r5, r5, r10

    // 20 -> 13
    lsr r10, r3, #20 // get bit
    and r10, r10, #1
    lsl r10, r10, #13
    orr r4, r4, r10

    // 21 -> 29
    lsr r10, r3, #21 // get bit
    and r10, r10, #1
    lsl r10, r10, #29
    orr r4, r4, r10

    // 22 -> 45 % 32 = 13
    lsr r10, r3, #22 // get bit
    and r10, r10, #1
    lsl r10, r10, #13
    orr r5, r5, r10

    // 23 -> 61 % 32 = 29
    lsr r10, r3, #23 // get bit
    and r10, r10, #1
    lsl r10, r10, #29
    orr r5, r5, r10

    // 24 -> 14
    lsr r10, r3, #24 // get bit
    and r10, r10, #1
    lsl r10, r10, #14
    orr r4, r4, r10

    // 25 -> 30
    lsr r10, r3, #25 // get bit
    and r10, r10, #1
    lsl r10, r10, #30
    orr r4, r4, r10

    // 26 -> 46 % 32 = 14
    lsr r10, r3, #26 // get bit
    and r10, r10, #1
    lsl r10, r10, #14
    orr r5, r5, r10

    // 27 -> 62 % 32 = 30
    lsr r10, r3, #27 // get bit
    and r10, r10, #1
    lsl r10, r10, #30
    orr r5, r5, r10

    // 28 -> 15
    lsr r10, r3, #28 // get bit
    and r10, r10, #1
    lsl r10, r10, #15
    orr r4, r4, r10

    // 29 -> 31
    lsr r10, r3, #29 // get bit
    and r10, r10, #1
    lsl r10, r10, #31
    orr r4, r4, r10

    // 30 -> 47 % 32 = 15
    lsr r10, r3, #30 // get bit
    and r10, r10, #1
    lsl r10, r10, #15
    orr r5, r5, r10


    // 31 -> 63 % 32 = 31
    lsr r10, r3, #31 // get bit
    and r10, r10, #1
    lsl r10, r10, #31
    orr r5, r5, r10


    //store updated part 1 with lower bits
    str r4, [r0, #0]
    //store updated part 2 with higher bits
    str r5, [r0, #4]


    add sp, sp, #(4 * 3)
    pop {r14}
    bx lr



    //////////////////////////////////////////////////////////////////////////
    ////////////////////////////////// PRESENT  //////////////////////////////
    //////////////////////////////////////////////////////////////////////////




.align 4
.global   masked_present
.type   masked_present, %function;
masked_present:

// r0 = shares0
// r1 = sharer2

// r12 = RK_H0
// r14 = RK_H1

// r10 = RK_L0
// r11 = RK_L1


    // Get the last two function's arguments from stack
    ldr r10, [sp, #0]
    ldr r11, [sp, #4]


    push {r4-r11,r14}
    sub sp, sp, #(4 * 15)

    mov r12, r2
    mov r14, r3

    // store arrays pointers in stack
    str r0, [sp, #0] // Shares A
    str r1, [sp, #4] // Shares B
    str r12, [sp, #8] // H0
    str r14, [sp, #12] // H1
    str r10, [sp, #16] // L0
    str r11, [sp, #20] // L1

    mov r10, #0
    str r10, [sp, #24]
    mov r11, #0
    str r11, [sp, #28]



//////////////////////////////////////////////////////////////////////////// ROUND 0 - 31 //////////////////////////////////////



loopT:

    /////////////////////////////////////////////////////////////////
    ///////////////////////// ADD ROUND KEY /////////////////////////
    /////////////////////////////////////////////////////////////////


    ////////////////// Update High //////////////////

    ldr r2, [r0, #4]
    ldr r6, [r1, #4]

    ldr r12, [sp, #8] // H0
    ldr r14, [sp, #12] // H1
    ldr r10, [sp, #16] // L0
    ldr r11, [sp, #20] // L1

    ldr r5, [sp, #28]


    add r4, r5, r12
    ldr r3, [r4, #0]
    add r4, r5, r14
    ldr r7, [r4, #0]

    eor r2, r2, r3
    eor r6, r6, r7

    str r2, [r0, #4] // sw r2, 4(r0)
    str r6, [r1, #4] // sw r6, 4(r1)

    ////////////////// Update LOW //////////////////
    ldr r2, [r0, #0]
    ldr r6, [r1, #0]


    add r4, r5, r10
    ldr r3, [r4, #0]

    add r4, r5, r11
    ldr r7, [r4, #0]

    eor r2, r2, r3
    eor r6, r6, r7

    str r2, [r0, #0]
    str r6, [r1, #0]

     // increase and store in memory offset for round keys array
    add r5, r5, #4
    str r5, [sp, #28]


    ////////////////////////////////////////////////////////
    ///////////////////////// SBOX /////////////////////////
    ////////////////////////////////////////////////////////



    bl sbox_player


    // LOOP ITERATION
    ldr r10, [sp, #24]
    add r10, r10, #1
    str r10, [sp, #24]
    cmp r10, #31
    blt loopT


    /////////////////////////////////////////////////////////////////////////////
    ///////////////////////// LAST ADD ROUND KEY RK[31] /////////////////////////
    /////////////////////////////////////////////////////////////////////////////

    ////////////////// Update High //////////////////

    ldr r2, [r0, #4]
    ldr r6, [r1, #4]

    ldr r12, [sp, #8] // H0
    ldr r14, [sp, #12] // H1
    ldr r10, [sp, #16] // L0
    ldr r11, [sp, #20] // L1

    ldr r5, [sp, #28]


    add r4, r5, r12
    ldr r3, [r4, #0]
    add r4, r5, r14
    ldr r7, [r4, #0]

    eor r2, r2, r3
    eor r6, r6, r7

    str r2, [r0, #4] // sw r2, 4(r0)
    str r6, [r1, #4] // sw r6, 4(r1)

    ////////////////// Update LOW //////////////////
    ldr r2, [r0, #0]
    ldr r6, [r1, #0]


    add r4, r5, r10
    ldr r3, [r4, #0]

    add r4, r5, r11
    ldr r7, [r4, #0]

    eor r2, r2, r3
    eor r6, r6, r7

    str r2, [r0, #0]
    str r6, [r1, #0]

    add sp, sp, #(4 * 15)
    pop {r4-r11,r14}
    bx lr
