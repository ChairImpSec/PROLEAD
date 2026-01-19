////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////// CORTEX M4 Masked Keccak-f[1600] //////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////

.syntax unified
.thumb

.data

.align 4
.globl KeccakP1600_RotationConstants
KeccakP1600_RotationConstants:
    .word 0x00000001
    .word 0x00000003
    .word 0x00000006
    .word 0x0000000a
    .word 0x0000000f
    .word 0x00000015
    .word 0x0000001c
    .word 0x00000024
    .word 0x0000002d
    .word 0x00000037
    .word 0x00000002
    .word 0x0000000e
    .word 0x0000001b
    .word 0x00000029
    .word 0x00000038
    .word 0x00000008
    .word 0x00000019
    .word 0x0000002b
    .word 0x0000003e
    .word 0x00000012
    .word 0x00000027
    .word 0x0000003d
    .word 0x00000014
    .word 0x0000002c


.align 4
.globl KeccakP1600_PiLane
KeccakP1600_PiLane:
    .word 0x0000000a
    .word 0x00000007
    .word 0x0000000b
    .word 0x00000011
    .word 0x00000012
    .word 0x00000003
    .word 0x00000005
    .word 0x00000010
    .word 0x00000008
    .word 0x00000015
    .word 0x00000018
    .word 0x00000004
    .word 0x0000000f
    .word 0x00000017
    .word 0x00000013
    .word 0x0000000d
    .word 0x0000000c
    .word 0x00000002
    .word 0x00000014
    .word 0x0000000e
    .word 0x00000016
    .word 0x00000009
    .word 0x00000006
    .word 0x00000001


.align 4
.globl KeccakRoundConstants
KeccakRoundConstants:

.word 0x00000001
.word 0x00000000
.word 0x00000000
.word 0x00000089
.word 0x00000000
.word 0x8000008b
.word 0x00000000
.word 0x80008080
.word 0x00000001
.word 0x0000008b
.word 0x00000001
.word 0x00008000
.word 0x00000001
.word 0x80008088
.word 0x00000001
.word 0x80000082
.word 0x00000000
.word 0x0000000b
.word 0x00000000
.word 0x0000000a
.word 0x00000001
.word 0x00008082
.word 0x00000000
.word 0x00008003
.word 0x00000001
.word 0x0000808b
.word 0x00000001
.word 0x8000000b
.word 0x00000001
.word 0x8000008a
.word 0x00000001
.word 0x80000081
.word 0x00000000
.word 0x80000081
.word 0x00000000
.word 0x80000008
.word 0x00000000
.word 0x00000083
.word 0x00000000
.word 0x80008003
.word 0x00000001
.word 0x80008088
.word 0x00000000
.word 0x80000088
.word 0x00000001
.word 0x00008000
.word 0x00000000
.word 0x80008082


.text

.align 4
.global   iA
.type   iA, %function;
// return 2*(x)+10*(y);
// r0 = x, a1=y
// r7 temp
iA:
    mov r7, r1
    lsl r1,r1, #2
    add r1,r1,r7
    lsl r1,r1, #1 // 10*y
    lsl r0,r0, #1 // 2*x
    add r0,r0,r1
    lsl r0,r0, #2
    mov r7, #0 // CLEAR
    bx lr


.align 4
.global   iB
.type   iB, %function;
// return 2x+10*(y) + 1;
// r0 = x, r1=y
iB:
    mov r7, r1
    lsl r1,r1, #2
    add r1,r1,r7
    lsl r1,r1, #1 // 10*y
    lsl r0,r0, #1 // 2*x
    add r0,r0,r1
    add r0, r0, #1
    lsl r0,r0, #2
    mov r7, #0 // CLEAR
    bx lr


///////////////////////////////////////////////////////////////////////////
////////////////////////////////// THETA //////////////////////////////////
///////////////////////////////////////////////////////////////////////////

.align 4
.global   theta
.type   theta, %function;
// r0 = state

theta:
    push {r4-r11,r14}
    sub sp, sp, #(4 * 16)

// CODE
    // load sheet 1A
    ldr r6, [r0, #0]
    ldr r7, [r0, #40]
    ldr r8, [r0, #80]
    ldr r9, [r0, #120]
    ldr r10, [r0, #160]
    eor r11, r6, r7
    eor r11, r11, r8
    eor r11, r11, r9
    eor r11, r11, r10
    str r11, [sp, #0]

    // load sheet 1B
    ldr r1, [r0, #4]
    ldr r2, [r0, #44]
    ldr r3, [r0, #84]
    ldr r4, [r0, #124]
    ldr r5, [r0, #164]
    eor r12, r1, r2
    eor r12, r12, r3
    eor r12, r12, r4
    eor r12, r12, r5
    str r12, [sp, #4]

    // load sheet 3A
    ldr r6, [r0, #16]
    ldr r7, [r0, #56]
    ldr r8, [r0, #96]
    ldr r9, [r0, #136]
    ldr r10, [r0, #176]
    eor r11, r6, r7
    eor r11, r11, r8
    eor r11, r11, r9
    eor r11, r11, r10
    str r11, [sp, #8]

    // load sheet 3B
    ldr r1, [r0, #20]
    ldr r2, [r0, #60]
    ldr r3, [r0, #100]
    ldr r4, [r0, #140]
    ldr r5, [r0, #180]
    eor r12, r1, r2
    eor r12, r12, r3
    eor r12, r12, r4
    eor r12, r12, r5
    str r12, [sp, #12]

    ///////////////////////////////////////////////////////////////////////////
    /////////////////////////Compute θ step on sheet 2/////////////////////////
    ///////////////////////////////////////////////////////////////////////////
    // load sheet 2A
    ldr r6, [r0, #8]
    ldr r7, [r0, #48]
    ldr r8, [r0, #88]
    ldr r9, [r0, #128]
    ldr r10, [r0, #168]
    eor r11, r6, r7
    eor r11, r11, r8
    eor r11, r11, r9
    eor r11, r11, r10
    str r11, [sp, #16]

    // load sheet 2B
    ldr r1, [r0, #12]
    ldr r2, [r0, #52]
    ldr r3, [r0, #92]
    ldr r4, [r0, #132]
    ldr r5, [r0, #172]
    eor r12, r1, r2
    eor r12, r12, r3
    eor r12, r12, r4
    eor r12, r12, r5
    str r12, [sp, #20]

    // ADD SUM S1A
    ldr r11, [sp, #0]
    eor r6, r6, r11
    eor r7, r7, r11
    eor r8, r8, r11
    eor r9, r9, r11
    eor r10, r10, r11

    // ADD SUM S1B
    ldr r12, [sp, #4]
    eor r1, r1, r12
    eor r2, r2, r12
    eor r3, r3, r12
    eor r4, r4, r12
    eor r5, r5, r12

    // Do 64 bit rotation of ONE on the ***LEFT*** between summ of sheet 3A and 3B
    ldr r11, [sp, #8] // 3A
    ldr r12, [sp, #12] // 3B
    ror r12, #31 // ROL 1



    // ADD ROL S3A
    eor r6, r6, r12
    eor r7, r7, r12
    eor r8, r8, r12
    eor r9, r9, r12
    eor r10, r10, r12

    // ADD ROL S3B
    eor r1, r1, r11
    eor r2, r2, r11
    eor r3, r3, r11
    eor r4, r4, r11
    eor r5, r5, r11

    // Store updated Sheet 2
    // store sheet 2A
    str r6, [r0, #8]
    str r7, [r0, #48]
    str r8, [r0, #88]
    str r9, [r0, #128]
    str r10, [r0, #168]

    // store sheet 2B
    str r1, [r0, #12]
    str r2, [r0, #52]
    str r3, [r0, #92]
    str r4, [r0, #132]
    str r5, [r0, #172]

    ///---------------------------------------------------//

    // load sheet 4A
    ldr r6, [r0, #24]
    ldr r7, [r0, #64]
    ldr r8, [r0, #104]
    ldr r9, [r0, #144]
    ldr r10, [r0, #184]
    eor r11, r6, r7
    eor r11, r11, r8
    eor r11, r11, r9
    eor r11, r11, r10
    str r11, [sp, #24]

    // load sheet 4B
    ldr r1, [r0, #28]
    ldr r2, [r0, #68]
    ldr r3, [r0, #108]
    ldr r4, [r0, #148]
    ldr r5, [r0, #188]
    eor r12, r1, r2
    eor r12, r12, r3
    eor r12, r12, r4
    eor r12, r12, r5
    str r12, [sp, #28]

    ///////////////////////////////////////////////////////////////////////////
    /////////////////////////Compute θ step on sheet 3/////////////////////////
    ///////////////////////////////////////////////////////////////////////////
    // load sheet 3A
    ldr r6, [r0, #16]
    ldr r7, [r0, #56]
    ldr r8, [r0, #96]
    ldr r9, [r0, #136]
    ldr r10, [r0, #176]

    // load sheet 3B
    ldr r1, [r0, #20]
    ldr r2, [r0, #60]
    ldr r3, [r0, #100]
    ldr r4, [r0, #140]
    ldr r5, [r0, #180]


    ldr r11, [sp, #16]
    // ADD SUM S2A
    eor r6, r6, r11
    eor r7, r7, r11
    eor r8, r8, r11
    eor r9, r9, r11
    eor r10, r10, r11

    ldr r12, [sp, #20]
    // ADD SUM S2B
    eor r1, r1, r12
    eor r2, r2, r12
    eor r3, r3, r12
    eor r4, r4, r12
    eor r5, r5, r12

    // Do 64 bit rotation of ONE on the ***LEFT*** between summ of sheet 4A and 4B
    ldr r11, [sp, #24] // 4A
    ldr r12, [sp, #28] // 4B
    ror r12, #31 // ROL 1



    // ADD ROL S4A
    eor r6, r6, r12
    eor r7, r7, r12
    eor r8, r8, r12
    eor r9, r9, r12
    eor r10, r10, r12

    // ADD ROL S4B
    eor r1, r1, r11
    eor r2, r2, r11
    eor r3, r3, r11
    eor r4, r4, r11
    eor r5, r5, r11

    // Store updated Sheet 3
    // store sheet 3A
    str r6, [r0, #16]
    str r7, [r0, #56]
    str r8, [r0, #96]
    str r9, [r0, #136]
    str r10, [r0, #176]

    // store sheet 3B
    str r1, [r0, #20]
    str r2, [r0, #60]
    str r3, [r0, #100]
    str r4, [r0, #140]
    str r5, [r0, #180]

///---------------------------------------------------//

    // load sheet 5A
    ldr r6, [r0, #32]
    ldr r7, [r0, #72]
    ldr r8, [r0, #112]
    ldr r9, [r0, #152]
    ldr r10, [r0, #192]
    eor r11, r6, r7
    eor r11, r11, r8
    eor r11, r11, r9
    eor r11, r11, r10
    str r11, [sp, #32]

    // load sheet 5B
    ldr r1, [r0, #36]
    ldr r2, [r0, #76]
    ldr r3, [r0, #116]
    ldr r4, [r0, #156]
    ldr r5, [r0, #196]
    eor r12, r1, r2
    eor r12, r12, r3
    eor r12, r12, r4
    eor r12, r12, r5
    str r12, [sp, #36]

    ///////////////////////////////////////////////////////////////////////////
    /////////////////////////Compute θ step on sheet 4/////////////////////////
    ///////////////////////////////////////////////////////////////////////////
    // load sheet 4A
    ldr r6, [r0, #24]
    ldr r7, [r0, #64]
    ldr r8, [r0, #104]
    ldr r9, [r0, #144]
    ldr r10, [r0, #184]

    // load sheet 4B
    ldr r1, [r0, #28]
    ldr r2, [r0, #68]
    ldr r3, [r0, #108]
    ldr r4, [r0, #148]
    ldr r5, [r0, #188]

    ldr r11, [sp, #8]
    // ADD SUM S3A
    eor r6, r6, r11
    eor r7, r7, r11
    eor r8, r8, r11
    eor r9, r9, r11
    eor r10, r10, r11

    ldr r12, [sp, #12]
    // ADD SUM S3B
    eor r1, r1, r12
    eor r2, r2, r12
    eor r3, r3, r12
    eor r4, r4, r12
    eor r5, r5, r12

    // Do 64 bit rotation of ONE on the ***LEFT*** between summ of sheet 5A and 5B
    ldr r11, [sp, #32] // 5A
    ldr r12, [sp, #36] // 5B
    ror r12, #31 // ROL 1



    // ADD ROL S5A
    eor r6, r6, r12
    eor r7, r7, r12
    eor r8, r8, r12
    eor r9, r9, r12
    eor r10, r10, r12

    // ADD ROL S5B
    eor r1, r1, r11
    eor r2, r2, r11
    eor r3, r3, r11
    eor r4, r4, r11
    eor r5, r5, r11

    // store sheet 4A
    str r6, [r0, #24]
    str r7, [r0, #64]
    str r8, [r0, #104]
    str r9, [r0, #144]
    str r10, [r0, #184]

    // store sheet 4B
    str r1, [r0, #28]
    str r2, [r0, 68]
    str r3, [r0, #108]
    str r4, [r0, #148]
    str r5, [r0, #188]

    ///////////////////////////////////////////////////////////////////////////
    /////////////////////////Compute θ step on sheet 5/////////////////////////
    ///////////////////////////////////////////////////////////////////////////
    // load sheet 5A
    ldr r6, [r0, #32]
    ldr r7, [r0, #72]
    ldr r8, [r0, #112]
    ldr r9, [r0, #152]
    ldr r10, [r0, #192]

    // load sheet 5B
    ldr r1, [r0, #36]
    ldr r2, [r0, #76]
    ldr r3, [r0, #116]
    ldr r4, [r0, #156]
    ldr r5, [r0, #196]

    // ADD SUM S4A
    ldr r11, [sp, #24]
    eor r6, r6, r11
    eor r7, r7, r11
    eor r8, r8, r11
    eor r9, r9, r11
    eor r10, r10, r11

    // ADD SUM S4B
    ldr r12, [sp, #28]
    eor r1, r1, r12
    eor r2, r2, r12
    eor r3, r3, r12
    eor r4, r4, r12
    eor r5, r5, r12

    // Do 64 bit rotation of ONE on the ***LEFT*** between summ of sheet 1A and 1B
    ldr r11, [sp, #0] // 1A
    ldr r12, [sp, #4] // 1B
    ror r12, #31 // ROL 1



    // ADD ROL S1A
    eor r6, r6, r12
    eor r7, r7, r12
    eor r8, r8, r12
    eor r9, r9, r12
    eor r10, r10, r12

    // ADD ROL S1B
    eor r1, r1, r11
    eor r2, r2, r11
    eor r3, r3, r11
    eor r4, r4, r11
    eor r5, r5, r11

    // store sheet 5A
    str r6, [r0, #32]
    str r7, [r0, #72]
    str r8, [r0, #112]
    str r9, [r0, #152]
    str r10, [r0, #192]

    // store sheet 5B
    str r1, [r0, #36]
    str r2, [r0, #76]
    str r3, [r0, #116]
    str r4, [r0, #156]
    str r5, [r0, #196]


    ///////////////////////////////////////////////////////////////////////////
    /////////////////////////Compute θ step on sheet 1/////////////////////////
    ///////////////////////////////////////////////////////////////////////////

    // load sheet 1A
    ldr r6, [r0, #0]
    ldr r7, [r0, #40]
    ldr r8, [r0, #80]
    ldr r9, [r0, #120]
    ldr r10, [r0, #160]

    // load sheet 1B
    ldr r1, [r0, #4]
    ldr r2, [r0, #44]
    ldr r3, [r0, #84]
    ldr r4, [r0, #124]
    ldr r5, [r0, #164]

    // ADD SUM S5A
    ldr r11, [sp, #32]
    eor r6, r6, r11
    eor r7, r7, r11
    eor r8, r8, r11
    eor r9, r9, r11
    eor r10, r10, r11

    // ADD SUM S5B
    ldr r12, [sp, #36]
    eor r1, r1, r12
    eor r2, r2, r12
    eor r3, r3, r12
    eor r4, r4, r12
    eor r5, r5, r12

    // Do 64 bit rotation of ONE on the ***LEFT*** between summ of sheet 2A and 2B
    ldr r11, [sp, #16] // 2A
    ldr r12, [sp, #20] // 2B
    ror r12, #31 // ROL 1



    // ADD ROL S2A
    eor r6, r6, r12
    eor r7, r7, r12
    eor r8, r8, r12
    eor r9, r9, r12
    eor r10, r10, r12

    // ADD ROL S2B
    eor r1, r1, r11
    eor r2, r2, r11
    eor r3, r3, r11
    eor r4, r4, r11
    eor r5, r5, r11

    // store sheet 5A
    str r6, [r0, #0]
    str r7, [r0, #40]
    str r8, [r0, #80]
    str r9, [r0, #120]
    str r10, [r0, #160]

    // store sheet 5B
    str r1, [r0, #4]
    str r2, [r0, #44]
    str r3, [r0, #84]
    str r4, [r0, #124]
    str r5, [r0, #164]


    add sp, sp, #(4 * 16)
    pop {r4-r11,r14}
    bx lr


//////////////////////////////////////////////////////////////////////////
////////////////////////////////// RHO_PI ////////////////////////////////
//////////////////////////////////////////////////////////////////////////


.align 4
.global   rhoPi
.type   rhoPi, %function;
rhoPi:
    push {r4-r11,r14}
    sub sp, sp, #(4 * 5)


    ldr r14, =KeccakP1600_PiLane


//////////////////////////////////////////////////////////////////////////////////////////////// ROUND  0 : odd and tau =  0.0


    mov r5, #0 //r5 = x
    mov r8, #1
    lsl r9, r8, #3
    add r3, r9, r0
    ldr r1, [r3, #0]
    ldr r6, [r3, #4]


    lsl r4, r5, #2
    add r3, r4, r14 // offset for KeccakP1600_PiLane[x]
    ldr r3, [r3, #0] //// KeccakP1600_PiLane[x] value
    lsl r11, r3, #3
    add r10, r0, r11 // offset for ((uint32_t*)state)[KeccakP1600_PiLane[x]]
    ldr r2, [r10, #0] // r2 = BCA[x] = ((uint32_t*)state)[KeccakP1600_PiLane[x]]
    ldr r7, [r10, #4] // r7 = BCB[x] = ((uint32_t*)state)[KeccakP1600_PiLane[x]]


    // *****ODD ***** ROL64(tempA-tempB,r11) (left rotation)
    ror r6, #31
    str r6, [r10, #0]
    str r1, [r10, #4]

    mov r1, r2 // temp = BCA[x];
    mov r6, r7 // temp = BCB[x];
    add r5, r5, #1


//////////////////////////////////////////////////////////////////////////////////////////////// ROUND  1 : odd and tau =  1.0

    lsl r4, r5, #2
    add r3, r4, r14
    ldr r3, [r3, #0]
    lsl r11, r3, #3
    add r10, r0, r11
    ldr r2, [r10, #0]
    ldr r7, [r10, #4]



    // *****ODD ***** ROL64(tempA-tempB,r11) (left rotation)
    ror r6, #30
    ror r1, #31

    str r6, [r10, #0]
    str r1, [r10, #4]

    mov r1, r2
    mov r6, r7
    add r5, r5, #1

//////////////////////////////////////////////////////////////////////////////////////////////// ROUND  2 : even and tau =  3.0


    lsl r4, r5, #2
    add r3, r4, r14
    ldr r3, [r3, #0]
    lsl r11, r3, #3
    add r10, r0, r11
    ldr r2, [r10, #0]
    ldr r7, [r10, #4]

    ror r1, #29
    ror r6, #29

    str r1, [r10, #0]
    str r6, [r10, #4]

    mov r1, r2
    mov r6, r7
    add r5, r5, #1


//////////////////////////////////////////////////////////////////////////////////////////////// ROUND  3 : even and tau =  5.0


    lsl r4, r5, #2
    add r3, r4, r14
    ldr r3, [r3, #0]
    lsl r11, r3, #3
    add r10, r0, r11
    ldr r2, [r10, #0]
    ldr r7, [r10, #4]


    ror r1, #27
    ror r6, #27

    str r1, [r10, #0]
    str r6, [r10, #4]

    mov r1, r2
    mov r6, r7
    add r5, r5, #1

//////////////////////////////////////////////////////////////////////////////////////////////// ROUND  4 : odd and tau =  7.0
    lsl r4, r5, #2
    add r3, r4, r14
    ldr r3, [r3, #0]
    lsl r11, r3, #3
    add r10, r0, r11
    ldr r2, [r10, #0]
    ldr r7, [r10, #4]


    ror r6, #24
    ror r1, #25

    str r6, [r10, #0]
    str r1, [r10, #4]

    mov r1, r2
    mov r6, r7
    add r5, r5, #1


//////////////////////////////////////////////////////////////////////////////////////////////// ROUND  5 : odd and tau =  10.0
    lsl r4, r5, #2
    add r3, r4, r14
    ldr r3, [r3, #0]
    lsl r11, r3, #3
    add r10, r0, r11
    ldr r2, [r10, #0]
    ldr r7, [r10, #4]

    ror r6, #21
    ror r1, #22


    str r6, [r10, #0]
    str r1, [r10, #4]

    mov r1, r2
    mov r6, r7
    add r5, r5, #1


//////////////////////////////////////////////////////////////////////////////////////////////// ROUND  6 : even and tau =  14.0

    lsl r4, r5, #2
    add r3, r4, r14
    ldr r3, [r3, #0]
    lsl r11, r3, #3
    add r10, r0, r11
    ldr r2, [r10, #0]
    ldr r7, [r10, #4]


    ror r1, #18
    ror r6, #18

    str r1, [r10, #0]
    str r6, [r10, #4]

    mov r1, r2
    mov r6, r7
    add r5, r5, #1

//////////////////////////////////////////////////////////////////////////////////////////////// ROUND  7 : even and tau =  18.0
    lsl r4, r5, #2
    add r3, r4, r14
    ldr r3, [r3, #0]
    lsl r11, r3, #3
    add r10, r0, r11
    ldr r2, [r10, #0]
    ldr r7, [r10, #4]

    ror r1, #14
    ror r6, #14



    str r1, [r10, #0]
    str r6, [r10, #4]

    mov r1, r2
    mov r6, r7
    add r5, r5, #1

//////////////////////////////////////////////////////////////////////////////////////////////// ROUND  8 : odd and tau =  22.0

    lsl r4, r5, #2
    add r3, r4, r14
    ldr r3, [r3, #0]
    lsl r11, r3, #3
    add r10, r0, r11
    ldr r2, [r10, #0]
    ldr r7, [r10, #4]

    ror r6, #9
    ror r1, #10

    str r6, [r10, #0]
    str r1, [r10, #4]

    mov r1, r2
    mov r6, r7
    add r5, r5, #1


//////////////////////////////////////////////////////////////////////////////////////////////// ROUND  9 : odd and tau =  27.0

    lsl r4, r5, #2
    add r3, r4, r14
    ldr r3, [r3, #0]
    lsl r11, r3, #3
    add r10, r0, r11
    ldr r2, [r10, #0]
    ldr r7, [r10, #4]


    ror r6, #4
    ror r1, #5

    str r6, [r10, #0]
    str r1, [r10, #4]

    mov r1, r2
    mov r6, r7
    add r5, r5, #1

//////////////////////////////////////////////////////////////////////////////////////////////// ROUND  10 : even and tau =  1.0

    lsl r4, r5, #2
    add r3, r4, r14
    ldr r3, [r3, #0]
    lsl r11, r3, #3
    add r10, r0, r11
    ldr r2, [r10, #0]
    ldr r7, [r10, #4]


    ror r1, #31
    ror r6, #31

    str r1, [r10, #0]
    str r6, [r10, #4]

    mov r1, r2
    mov r6, r7
    add r5, r5, #1

//////////////////////////////////////////////////////////////////////////////////////////////// ROUND  11 : even and tau =  7.0

    lsl r4, r5, #2
    add r3, r4, r14
    ldr r3, [r3, #0]
    lsl r11, r3, #3
    add r10, r0, r11
    ldr r2, [r10, #0]
    ldr r7, [r10, #4]

    ror r1, #25
    ror r6, #25


    str r1, [r10, #0]
    str r6, [r10, #4]

    mov r1, r2
    mov r6, r7
    add r5, r5, #1


//////////////////////////////////////////////////////////////////////////////////////////////// ROUND  12 : odd and tau =  13.0

    lsl r4, r5, #2
    add r3, r4, r14
    ldr r3, [r3, #0]
    lsl r11, r3, #3
    add r10, r0, r11
    ldr r2, [r10, #0]
    ldr r7, [r10, #4]

    ror r6, #18
    ror r1, #19



    str r6, [r10, #0]
    str r1, [r10, #4]

    mov r1, r2
    mov r6, r7
    add r5, r5, #1


//////////////////////////////////////////////////////////////////////////////////////////////// ROUND  13 : odd and tau =  20.0

    lsl r4, r5, #2
    add r3, r4, r14
    ldr r3, [r3, #0]
    lsl r11, r3, #3
    add r10, r0, r11
    ldr r2, [r10, #0]
    ldr r7, [r10, #4]


    ror r6, 11
    ror r1, 12

    str r6, [r10, #0]
    str r1, [r10, #4]

    mov r1, r2
    mov r6, r7
    add r5, r5, #1


//////////////////////////////////////////////////////////////////////////////////////////////// ROUND  14 : even and tau =  28.0

    lsl r4, r5, #2
    add r3, r4, r14
    ldr r3, [r3, #0]
    lsl r11, r3, #3
    add r10, r0, r11
    ldr r2, [r10, #0]
    ldr r7, [r10, #4]

    ror r1, #4
    ror r6, #4


    str r1, [r10, #0]
    str r6, [r10, #4]

    mov r1, r2
    mov r6, r7
    add r5, r5, #1

//////////////////////////////////////////////////////////////////////////////////////////////// ROUND  15 : even and tau =  4.0
    lsl r4, r5, #2
    add r3, r4, r14
    ldr r3, [r3, #0]
    lsl r11, r3, #3
    add r10, r0, r11
    ldr r2, [r10, #0]
    ldr r7, [r10, #4]


    ror r1, #28
    ror r6, #28

    str r1, [r10, #0]
    str r6, [r10, #4]

    mov r1, r2
    mov r6, r7
    add r5, r5, #1

//////////////////////////////////////////////////////////////////////////////////////////////// ROUND  16 : odd and tau =  12.0

    lsl r4, r5, #2
    add r3, r4, r14
    ldr r3, [r3, #0]
    lsl r11, r3, #3
    add r10, r0, r11
    ldr r2, [r10, #0]
    ldr r7, [r10, #4]

    ror r6, #19
    ror r1, #20


    str r6, [r10, #0]
    str r1, [r10, #4]

    mov r1, r2
    mov r6, r7
    add r5, r5, #1

//////////////////////////////////////////////////////////////////////////////////////////////// ROUND  17 : odd and tau =  21.0

    lsl r4, r5, #2
    add r3, r4, r14
    ldr r3, [r3, #0]
    lsl r11, r3, #3
    add r10, r0, r11
    ldr r2, [r10, #0]
    ldr r7, [r10, #4]

    ror r6, #10
    ror r1, #11


    str r6, [r10, #0]
    str r1, [r10, #4]

    mov r1, r2
    mov r6, r7
    add r5, r5, #1

//////////////////////////////////////////////////////////////////////////////////////////////// ROUND  18 : even and tau =  31.0
    lsl r4, r5, #2
    add r3, r4, r14
    ldr r3, [r3, #0]
    lsl r11, r3, #3
    add r10, r0, r11
    ldr r2, [r10, #0]
    ldr r7, [r10, #4]

    ror r1, #1
    ror r6, #1

    str r1, [r10, #0]
    str r6, [r10, #4]

    mov r1, r2
    mov r6, r7
    add r5, r5, #1


//////////////////////////////////////////////////////////////////////////////////////////////// ROUND  19 : even and tau =  9.0
    lsl r4, r5, #2
    add r3, r4, r14
    ldr r3, [r3, #0]
    lsl r11, r3, #3
    add r10, r0, r11
    ldr r2, [r10, #0]
    ldr r7, [r10, #4]


    ror r1, #23
    ror r6, #23

    str r1, [r10, #0]
    str r6, [r10, #4]

    mov r1, r2
    mov r6, r7
    add r5, r5, #1

//////////////////////////////////////////////////////////////////////////////////////////////// ROUND  20 : odd and tau =  19.0

    lsl r4, r5, #2
    add r3, r4, r14
    ldr r3, [r3, #0]
    lsl r11, r3, #3
    add r10, r0, r11
    ldr r2, [r10, #0]
    ldr r7, [r10, #4]

    ror r6, #12
    ror r1, #13


    str r6, [r10, #0]
    str r1, [r10, #4]

    mov r1, r2
    mov r6, r7
    add r5, r5, #1

//////////////////////////////////////////////////////////////////////////////////////////////// ROUND  21 : odd and tau =  30.0
    lsl r4, r5, #2
    add r3, r4, r14
    ldr r3, [r3, #0]
    lsl r11, r3, #3
    add r10, r0, r11
    ldr r2, [r10, #0]
    ldr r7, [r10, #4]

    ror r6, #1
    ror r1, #2


    str r6, [r10, #0]
    str r1, [r10, #4]

    mov r1, r2
    mov r6, r7
    add r5, r5, #1

//////////////////////////////////////////////////////////////////////////////////////////////// ROUND  22 : even and tau =  10.0
    lsl r4, r5, #2
    add r3, r4, r14
    ldr r3, [r3, #0]
    lsl r11, r3, #3
    add r10, r0, r11
    ldr r2, [r10, #0]
    ldr r7, [r10, #4]

    ror r1, #22
    ror r6, #22


    str r1, [r10, #0]
    str r6, [r10, #4]

    mov r1, r2
    mov r6, r7
    add r5, r5, #1

//////////////////////////////////////////////////////////////////////////////////////////////// ROUND  23 : even and tau =  22.0
    lsl r4, r5, #2
    add r3, r4, r14
    ldr r3, [r3, #0]
    lsl r11, r3, #3
    add r10, r0, r11
    ldr r2, [r10, #0]
    ldr r7, [r10, #4]

    ror r1, #10
    ror r6, #10

    str r1, [r10, #0]
    str r6, [r10, #4]


    add sp, sp, #(4 * 5)
    pop {r4-r11,r14}
    bx lr



//////////////////////////////////////////////////////////////////////////
////////////////////////////////// CHI_pA ///////////////////////////////////
//////////////////////////////////////////////////////////////////////////

// r1 for share 0 randomness
// r7 for share 1 randomness
// r2-r6 for input shares state0
// r8-r12 for input shares state1
// r14 temporary register for cross-products

.align 4
.global   chi_pA
.type   chi_pA, %function;
chi_pA:

    push {r4-r11,r14}
    sub sp, sp, #(4 * 15)

    str r0, [sp, #32]// save pt state A in stack
    str r1, [sp, #36]// save pt state B in stacK
    str r2, [sp, #40]// save pt Randomness R0 in stack
    str r3, [sp, #44]// save pt Randomness R1 in stack

    mov r14, #0
    str r14, [sp, #8]


loopChi_A:

    // compute all index(x,y) values

    mov r0, #0 // r0 = x = 0
    ldr r1, [sp, #8] // r1 = y
    bl iA
    str r0, [sp, #12] // store value index(0, y)

    mov r0, #1 // r0 = x = 1
    ldr r1, [sp, #8] // r1 = y
    bl iA
    str r0, [sp, #16] // store value index(1, y)

    mov r0, #2 // r0 = x = 2
    ldr r1, [sp, #8] // r1 = y
    bl iA
    str r0, [sp, #20] // store value index(2, y)

    mov r0, #3 // r0 = x = 3
    ldr r1, [sp, #8] // r1 = y
    bl iA
    str r0, [sp, #24] // store value index(3, y)

    mov r0, #4 // r0 = x = 4
    ldr r1, [sp, #8] // r1 = y
    bl iA
    str r0, [sp, #28] // store value index(4, y)

    ldr r0, [sp, #32] // place back pt share A in r0
    ldr r1, [sp, #36] // place back pt share B in r1

////////////////// x = 0 (A)
    ldr r14, [sp, #12] // get index(x,y) offset
    ldr r2, [r0, r14] // get (((uint32_t *)stateA)[i(x, y)])
    ldr r8, [r1, r14] // get (((uint32_t *)stateB)[i(x, y)])

////////////////// x = 1 (B)
    ldr r14, [sp, #16] // get index(x,y) offset
    ldr r3, [r0, r14] // get (((uint32_t *)stateA)[i(x, y)])
    ldr r9, [r1, r14] // get (((uint32_t *)stateB)[i(x, y)])

////////////////// x = 2 (C)
    ldr r14, [sp, #20] // get index(x,y) offset
    ldr r4, [r0, r14] // get (((uint32_t *)stateA)[i(x, y)])
    ldr r10, [r1, r14] // get (((uint32_t *)stateB)[i(x, y)])

////////////////// x = 3 (D)
    ldr r14, [sp, #24] // get index(x,y) offset
    ldr r5, [r0, r14] // get (((uint32_t *)stateA)[i(x, y)])
    ldr r11, [r1, r14] // get (((uint32_t *)stateB)[i(x, y)])

////////////////// x = 4 (E)
    ldr r14, [sp, #28] // get index(x,y) offset
    ldr r6, [r0, r14] // get (((uint32_t *)stateA)[i(x, y)])
    ldr r12, [r1, r14] // get (((uint32_t *)stateB)[i(x, y)])

    ldr r14, [sp, #40] // get pt randomness R0
    ldr r1, [r14] // get value R0
    ldr r14, [sp, #44] // get pt randomness R1
    ldr r7, [r14] // get value R1

    // Compute χ on the plane
    // update R0
    and r14, r2, r6 // e0a0
    eor r1, r1, r14 // r0 + e0a0
    eor r1, r1, r2 // r0 + e0a0 + a0
    ror r6, #2
    ror r8, #1
    and r14, r6, r8 // e0a1
    ror r6, #30
    ror r8, #31
    // shift r1 to index 2
    ror r1, #2
    eor r1, r1, r14
    // shift back r1 to index 0
    ror r1, #30


    // update R1
    and r14, r8, r12 // e1a1
    eor r7, r7, r14 // r1 + e1a1
    eor r7, r7, r8 // r1 + e1a1 + a1
    ror r2, #2
    ror r12, #1
    and r14, r2, r12 // e1a0
    ror r2, #30
    ror r12, #31
    // shift r7 to index 2
    ror r7, #1
    eor r7, r7, r14
    // shift back r7 to index 1
    ror r7, #31


    //update A0
    and r14, r3, r4 // b0c0
    eor r2, r2, r14 // a0 + b0c0
    eor r2, r2, r4 // a0 + b0c0 + c0
    ror r3, #2
    ror r10, #1
    and r14, r3, r10 // b0c1
    ror r3, #30
    ror r10, #31
    // shift r2 to index 2
    ror r2, #2
    eor r2, r2, r14
    // shift back r2 to index 0
    ror r2, #30
    // store A0 in memory
    ldr r0, [sp, #32] // load pointer to share A
    ldr r14, [sp, #12] // load offset index(0,y)
    str r2, [r0,r14] // store in memory A0


    //update A1
    and r14, r9, r10 // b1c1
    eor r8, r8, r14 // a1 + b1c1
    eor r8, r8, r10 // a1 + b1c1 + c1
    ror r4, #2
    ror r9, #1
    and r14, r4, r9 // b1c0
    ror r4, #30
    ror r9, #31
    // shift r8 to index 2
    ror r8, #1
    eor r8, r8, r14
    // shift back r8 to index 1
    ror r8, #31
    // store A1 in memory
    ldr r0, [sp, #36] // load pointer to share B
    ldr r14, [sp, #12] // load offset index(0,y)
    str r8, [r0,r14] // store in memory A1

    //update C0
    and r14, r5, r6 // d0e0
    eor r4, r4, r14 // c0 + d0e0
    eor r4, r4, r6 // c0 + d0e0 + e0
    ror r5, #2
    ror r12, #1
    and r14, r5, r12 // d0e1
    ror r5, #30
    ror r12, #31
    // shift r4 to index 2
    ror r4, #2
    eor r4, r4, r14
    // shift back r4 to index 0
    ror r4, #30
    // store C0 in memory
    ldr r0, [sp, #32] // load pointer to share A
    ldr r14, [sp, #20] // load offset index(2,y)
    str r4, [r0,r14] // store in memory C0

    //update C1
    and r14, r11, r12 // d1e1
    eor r10, r10, r14 // c1 + d1e1
    eor r10, r10, r12 // c1 + d1e1 + e1
    ror r6, #2
    ror r11, #1
    and r14, r6, r11 // d1e0
    ror r6, #30
    ror r11, #31
    // shift r10 to index 2
    ror r10, #1
    eor r10, r10, r14
    // shift back r10 to index 1
    ror r10, #31
    ldr r0, [sp, #36] // load pointer to share B
    ldr r14, [sp, #20] // load offset index(2,y)
    str r10, [r0,r14] // store in memory C1

    //update E0
    and r14, r2, r3 // a0b0
    eor r6, r6, r14 // e0 + a0b0
    eor r6, r6, r3 // e0 + a0b0 + b0
    ror r2, #2
    ror r9, #1
    and r14, r2, r9 // a0b1
    ror r2, #30
    ror r9, #31
    // shift r6 to index 2
    ror r6, #2
    eor r6, r6, r14
    // shift back r6 to index 0
    ror r6, #30
    // store E0 in memory
    ldr r0, [sp, #32] // load pointer to share A
    ldr r14, [sp, #28] // load offset index(4,y)
    str r6, [r0,r14] // store in memory C0

    //update E1
    and r14, r8, r9 // a1b1
    eor r12, r12, r14 // e1 + a1b1
    eor r12, r12, r9 // e1 + a1b1 + b1
    ror r3, #2
    ror r8, #1
    and r14, r3, r8 // a1b0
    ror r3, #30
    ror r8, #31
    // shift r12 to index 2
    ror r12, #1
    eor r12, r12, r14
    // shift back r12 to index 1
    ror r12, #31
    // store E1 in memory
    ldr r0, [sp, #36] // load pointer to share B
    ldr r14, [sp, #28] // load offset index(4,y)
    str r12, [r0,r14] // store in memory C1

    //update B0
    and r14, r4, r5 // c0d0
    eor r3, r3, r14 // b0 + c0d0
    eor r3, r3, r5 // b0 + c0d0 + d0
    ror r4, #2
    ror r11, #1
    and r14, r4, r11 // c0d1
    ror r4, #30
    ror r11, #31
    // shift r3 to index 2
    ror r3, #2
    eor r3, r3, r14
    // shift back r3 to index 0
    ror r3, #30
    // store B0 in memory
    ldr r0, [sp, #32] // load pointer to share A
    ldr r14, [sp, #16] // load offset index(1,y)
    str r3, [r0,r14] // store in memory B0


    //update B1
    and r14, r10, r11 // c1d1
    eor r9, r9, r14 // b1 + c1d1
    eor r9, r9, r11 // b1 + c1d1 + d1
    ror r5, #2
    ror r10, #1
    and r14, r5, r10 // c1d0
    ror r5, #30
    ror r10, #31
    // shift r9 to index 2
    ror r9, #1
    eor r9, r9, r14
    // shift back r9 to index 1
    ror r9, #31
    // store B1 in memory
    ldr r0, [sp, #36] // load pointer to share B
    ldr r14, [sp, #16] // load offset index(1,y)
    str r9, [r0,r14] // store in memory B1

    //update D0
    eor r5, r5, r1 // d0 + r0
    // store D0 in memory
    ldr r0, [sp, #32] // load pointer to share A
    ldr r14, [sp, #24] // load offset index(3,y)
    str r5, [r0,r14] // store in memory D0

    //update D1
    eor r11, r11, r7 // d1 + r1
    // store D1 in memory
    ldr r0, [sp, #36] // load pointer to share B
    ldr r14, [sp, #24] // load offset index(3,y)
    str r11, [r0,r14] // store in memory B1

    //update the randomness R0 and R1 with A1
    mov r1, r8 // update R0
    mov r7, r8 // update R1
    //rotate R1
    ror r7, #1
    // store in memory R0, R1
    ldr r14, [sp, #40] // pt randomness R0
    str r1, [r14]
    ldr r14, [sp, #44] // pt randomness R1
    str r7, [r14]

    // UPDATE loop counter and store it
    ldr r14, [sp, #8]
    add r14, r14, #1 // update value y = y+1
    str r14, [sp, #8] // store in stack the new y value
    cmp r14, #5
    blt loopChi_A

    add sp, sp, #(4 * 15)
    pop {r4-r11,r14}
    bx lr



//////////////////////////////////////////////////////////////////////////
////////////////////////////////// CHI_pB ///////////////////////////////////
//////////////////////////////////////////////////////////////////////////

// r1 for share 0 randomness
// r7 for share 1 randomness
// r2-r6 for input shares state0
// r8-r12 for input shares state1
// r14 temporary register for cross-products

.align 4
.global   chi_pB
.type   chi_pB, %function;
chi_pB:

    push {r4-r11,r14}
    sub sp, sp, #(4 * 15)

    str r0, [sp, #32]// save pt state A in stack
    str r1, [sp, #36]// save pt state B in stacK
    str r2, [sp, #40]// save pt Randomness R0 in stack
    str r3, [sp, #44]// save pt Randomness R1 in stack

    mov r14, #0
    str r14, [sp, #8]


loopChi_B:

    // compute all index(x,y) values

    mov r0, #0 // r0 = x = 0
    ldr r1, [sp, #8] // r1 = y
    bl iB
    str r0, [sp, #12] // store value index(0, y)

    mov r0, #1 // r0 = x = 1
    ldr r1, [sp, #8] // r1 = y
    bl iB
    str r0, [sp, #16] // store value index(1, y)

    mov r0, #2 // r0 = x = 2
    ldr r1, [sp, #8] // r1 = y
    bl iB
    str r0, [sp, #20] // store value index(2, y)

    mov r0, #3 // r0 = x = 3
    ldr r1, [sp, #8] // r1 = y
    bl iB
    str r0, [sp, #24] // store value index(3, y)

    mov r0, #4 // r0 = x = 4
    ldr r1, [sp, #8] // r1 = y
    bl iB
    str r0, [sp, #28] // store value index(4, y)

    ldr r0, [sp, #32] // place back pt share A in r0
    ldr r1, [sp, #36] // place back pt share B in r1

////////////////// x = 0 (A)
    ldr r14, [sp, #12] // get index(x,y) offset
    ldr r2, [r0, r14] // get (((uint32_t *)stateA)[i(x, y)])
    ldr r8, [r1, r14] // get (((uint32_t *)stateB)[i(x, y)])

////////////////// x = 1 (B)
    ldr r14, [sp, #16] // get index(x,y) offset
    ldr r3, [r0, r14] // get (((uint32_t *)stateA)[i(x, y)])
    ldr r9, [r1, r14] // get (((uint32_t *)stateB)[i(x, y)])

////////////////// x = 2 (C)
    ldr r14, [sp, #20] // get index(x,y) offset
    ldr r4, [r0, r14] // get (((uint32_t *)stateA)[i(x, y)])
    ldr r10, [r1, r14] // get (((uint32_t *)stateB)[i(x, y)])

////////////////// x = 3 (D)
    ldr r14, [sp, #24] // get index(x,y) offset
    ldr r5, [r0, r14] // get (((uint32_t *)stateA)[i(x, y)])
    ldr r11, [r1, r14] // get (((uint32_t *)stateB)[i(x, y)])

////////////////// x = 4 (E)
    ldr r14, [sp, #28] // get index(x,y) offset
    ldr r6, [r0, r14] // get (((uint32_t *)stateA)[i(x, y)])
    ldr r12, [r1, r14] // get (((uint32_t *)stateB)[i(x, y)])

    ldr r14, [sp, #40] // get pt randomness R0
    ldr r1, [r14, #4] // get value R0
    ldr r14, [sp, #44] // get pt randomness R1
    ldr r7, [r14, #4] // get value R1

    // Compute χ on the plane

    // update R0
    and r14, r2, r6 // e0a0
    eor r1, r1, r14 // r0 + e0a0
    eor r1, r1, r2 // r0 + e0a0 + a0
    ror r6, #2
    ror r8, #1
    and r14, r6, r8 // e0a1
    ror r6, #30
    ror r8, #31
    // shift r1 to index 2
    ror r1, #2
    eor r1, r1, r14
    // shift back r1 to index 0
    ror r1, #30


    // update R1
    and r14, r8, r12 // e1a1
    eor r7, r7, r14 // r1 + e1a1
    eor r7, r7, r8 // r1 + e1a1 + a1
    ror r2, #2
    ror r12, #1
    and r14, r2, r12 // e1a0
    ror r2, #30
    ror r12, #31
    // shift r7 to index 2
    ror r7, #1
    eor r7, r7, r14
    // shift back r7 to index 1
    ror r7, #31


    //update A0
    and r14, r3, r4 // b0c0
    eor r2, r2, r14 // a0 + b0c0
    eor r2, r2, r4 // a0 + b0c0 + c0
    ror r3, #2
    ror r10, #1
    and r14, r3, r10 // b0c1
    ror r3, #30
    ror r10, #31
    // shift r2 to index 2
    ror r2, #2
    eor r2, r2, r14
    // shift back r2 to index 0
    ror r2, #30
    // store A0 in memory
    ldr r0, [sp, #32] // load pointer to share A
    ldr r14, [sp, #12] // load offset index(0,y)
    str r2, [r0,r14] // store in memory A0


    //update A1
    and r14, r9, r10 // b1c1
    eor r8, r8, r14 // a1 + b1c1
    eor r8, r8, r10 // a1 + b1c1 + c1
    ror r4, #2
    ror r9, #1
    and r14, r4, r9 // b1c0
    ror r4, #30
    ror r9, #31
    // shift r8 to index 2
    ror r8, #1
    eor r8, r8, r14
    // shift back r8 to index 1
    ror r8, #31
    // store A1 in memory
    ldr r0, [sp, #36] // load pointer to share B
    ldr r14, [sp, #12] // load offset index(0,y)
    str r8, [r0,r14] // store in memory A1

    //update C0
    and r14, r5, r6 // d0e0
    eor r4, r4, r14 // c0 + d0e0
    eor r4, r4, r6 // c0 + d0e0 + e0
    ror r5, #2
    ror r12, #1
    and r14, r5, r12 // d0e1
    ror r5, #30
    ror r12, #31
    // shift r4 to index 2
    ror r4, #2
    eor r4, r4, r14
    // shift back r4 to index 0
    ror r4, #30
    // store C0 in memory
    ldr r0, [sp, #32] // load pointer to share A
    ldr r14, [sp, #20] // load offset index(2,y)
    str r4, [r0,r14] // store in memory C0

    //update C1
    and r14, r11, r12 // d1e1
    eor r10, r10, r14 // c1 + d1e1
    eor r10, r10, r12 // c1 + d1e1 + e1
    ror r6, #2
    ror r11, #1
    and r14, r6, r11 // d1e0
    ror r6, #30
    ror r11, #31
    // shift r10 to index 2
    ror r10, #1
    eor r10, r10, r14
    // shift back r10 to index 1
    ror r10, #31
    ldr r0, [sp, #36] // load pointer to share B
    ldr r14, [sp, #20] // load offset index(2,y)
    str r10, [r0,r14] // store in memory C1

    //update E0
    and r14, r2, r3 // a0b0
    eor r6, r6, r14 // e0 + a0b0
    eor r6, r6, r3 // e0 + a0b0 + b0
    ror r2, #2
    ror r9, #1
    and r14, r2, r9 // a0b1
    ror r2, #30
    ror r9, #31
    // shift r6 to index 2
    ror r6, #2
    eor r6, r6, r14
    // shift back r6 to index 0
    ror r6, #30
    // store E0 in memory
    ldr r0, [sp, #32] // load pointer to share A
    ldr r14, [sp, #28] // load offset index(4,y)
    str r6, [r0,r14] // store in memory C0

    //update E1
    and r14, r8, r9 // a1b1
    eor r12, r12, r14 // e1 + a1b1
    eor r12, r12, r9 // e1 + a1b1 + b1
    ror r3, #2
    ror r8, #1
    and r14, r3, r8 // a1b0
    ror r3, #30
    ror r8, #31
    // shift r12 to index 2
    ror r12, #1
    eor r12, r12, r14
    // shift back r12 to index 1
    ror r12, #31
    // store E1 in memory
    ldr r0, [sp, #36] // load pointer to share B
    ldr r14, [sp, #28] // load offset index(4,y)
    str r12, [r0,r14] // store in memory C1

    //update B0
    and r14, r4, r5 // c0d0
    eor r3, r3, r14 // b0 + c0d0
    eor r3, r3, r5 // b0 + c0d0 + d0
    ror r4, #2
    ror r11, #1
    and r14, r4, r11 // c0d1
    ror r4, #30
    ror r11, #31
    // shift r3 to index 2
    ror r3, #2
    eor r3, r3, r14
    // shift back r3 to index 0
    ror r3, #30
    // store B0 in memory
    ldr r0, [sp, #32] // load pointer to share A
    ldr r14, [sp, #16] // load offset index(1,y)
    str r3, [r0,r14] // store in memory B0


    //update B1
    and r14, r10, r11 // c1d1
    eor r9, r9, r14 // b1 + c1d1
    eor r9, r9, r11 // b1 + c1d1 + d1
    ror r5, #2
    ror r10, #1
    and r14, r5, r10 // c1d0
    ror r5, #30
    ror r10, #31
    // shift r9 to index 2
    ror r9, #1
    eor r9, r9, r14
    // shift back r9 to index 1
    ror r9, #31
    // store B1 in memory
    ldr r0, [sp, #36] // load pointer to share B
    ldr r14, [sp, #16] // load offset index(1,y)
    str r9, [r0,r14] // store in memory B1

    //update D0
    eor r5, r5, r1 // d0 + r0
    // store D0 in memory
    ldr r0, [sp, #32] // load pointer to share A
    ldr r14, [sp, #24] // load offset index(3,y)
    str r5, [r0,r14] // store in memory D0

    //update D1
    eor r11, r11, r7 // d1 + r1
    // store D1 in memory
    ldr r0, [sp, #36] // load pointer to share B
    ldr r14, [sp, #24] // load offset index(3,y)
    str r11, [r0,r14] // store in memory B1

    //update the randomness R0 and R1 with A1
    mov r1, r8 // update R0
    mov r7, r8 // update R1
    //rotate R1
    ror r7, #1
    // store in memory R0, R1
    ldr r14, [sp, #40] // pt randomness R0
    str r1, [r14, #4]
    ldr r14, [sp, #44] // pt randomness R1
    str r7, [r14, #4]

    // UPDATE loop counter and store it
    ldr r14, [sp, #8]
    add r14, r14, #1 // update value y = y+1
    str r14, [sp, #8] // store in stack the new y value
    cmp r14, #5
    blt loopChi_B

    add sp, sp, #(4 * 15)
    pop {r4-r11,r14}
    bx lr


///////////////////////////////////////////////////////////////////////////
/////////////////////////////////// IOTA //////////////////////////////////
///////////////////////////////////////////////////////////////////////////

.align 4
.global iota
.type   iota, %function;
iota:
// r0 = void * state0
// r1 = nround


    ldr r12, =KeccakRoundConstants

    // PART A
    lsl r2, r1, #3
    add r12, r12, r2
    add r8, r12, #4
    ldr r2, [r12, #0]
    ldr r8, [r8, #0]

    ldr r12, [r0, #0]
    eor r12, r12, r2
    str r12, [r0, #0]

    ldr r12, [r0, #4]
    eor r12, r12, r8
    str r12, [r0, #4]

    bx lr


///////////////////////////////////////////////////////////////////////
/////////////////////////// KeccakF1600_StatePermute_TI ///////////////////
///////////////////////////////////////////////////////////////////////


.align 4
.global   KeccakF1600_StatePermute_TI
.type   KeccakF1600_StatePermute_TI, %function;
KeccakF1600_StatePermute_TI:

// r0 = void * state0
// r1 = void * state1
// r2 = void * randomness0
// r3 = void * randomness1

    push {r4-r11,lr}
    sub sp, sp, #(4 * 6)
    str r2, [sp, #12]
    str r3, [sp, #16]

// Round 0-22
    mov r11, #0
    str r11, [sp, #0]
    str r1, [sp, #4]
    str r0, [sp, #8]

mainloop:

   /////// theta share A ///////
    bl theta
    bl rhoPi
    /////// theta share B ///////
    ldr r0, [sp, #4]
    bl theta
    bl rhoPi
    mov r1, r0
    ldr r0, [sp, #8]
    /////// chi ///////
    ldr r2, [sp, #12]
    ldr r3, [sp, #16]
    bl chi_pA
    ldr r0, [sp, #8]
    ldr r1, [sp, #4]
    ldr r2, [sp, #12]
    ldr r3, [sp, #16]
    bl chi_pB
    ldr r0, [sp, #8]
    ldr r1, [sp, #0]
    /////// iota ///////
    bl iota
    ldr r1, [sp, #4]

    ldr r11, [sp, #0]
    add r11, r11, #1
    str r11, [sp, #0]
    cmp r11, #24
    blt mainloop

    add sp, sp, #(4 * 6)
    pop {r4-r11,lr}
    bx lr
