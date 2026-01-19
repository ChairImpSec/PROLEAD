////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////// CORTEX M4 Masked Keccak-f[800] //////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////

.syntax unified
.thumb

.data

.align 4
.globl KeccakP800_RotationConstants
KeccakP800_RotationConstants:
    .word 0x00000001
    .word 0x00000003
    .word 0x00000006
    .word 0x0000000a
    .word 0x0000000f
    .word 0x00000015
    .word 0x0000001c
    .word 0x00000004
    .word 0x0000000d
    .word 0x00000017
    .word 0x00000002
    .word 0x0000000e
    .word 0x0000001b
    .word 0x00000009
    .word 0x00000018
    .word 0x00000008
    .word 0x00000019
    .word 0x0000000b
    .word 0x0000001e
    .word 0x00000012
    .word 0x00000007
    .word 0x0000001d
    .word 0x00000014
    .word 0x0000000c

.align 4
.globl KeccakP800_PiLane
KeccakP800_PiLane:
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
    .word 0x00008082
    .word 0x0000808a
    .word 0x80008000
    .word 0x0000808b
    .word 0x80000001
    .word 0x80008081
    .word 0x00008009
    .word 0x0000008a
    .word 0x00000088
    .word 0x80008009
    .word 0x8000000a
    .word 0x8000808b
    .word 0x0000008b
    .word 0x00008089
    .word 0x00008003
    .word 0x00008002
    .word 0x00000080
    .word 0x0000800a
    .word 0x8000000a
    .word 0x80008081
    .word 0x00008080

.text

.align 4
// return (x)+5*(y)
// r0 = x, r1=y
index:
    add r0, r0, r1
    lsl r1,r1, #2
    add r0,r0,r1
    lsl r0,r0, #2

    bx lr

///////////////////////////////////////////////////////////////////////////
////////////////////////////////// THETA //////////////////////////////////
///////////////////////////////////////////////////////////////////////////

.align 4
.global   theta
.type   theta, %function;
theta:

    sub sp, sp, #(4 * 5)

    // load sheet 1
    ldr r6, [r0, #0]
    ldr r7, [r0, #20]
    ldr r8, [r0, #40]
    ldr r9, [r0, #60]
    ldr r10, [r0, #80]
    eor r11, r6, r7
    eor r11, r11, r8
    eor r11, r11, r9
    eor r11, r11, r10 // sum of Sheet 1 in r11
    //store sum of Sheet 1 in stack #0
    str r11, [sp, #0]


    // load sheet 2
    ldr r1, [r0, #4]
    ldr r2, [r0, #24]
    ldr r3, [r0, #44]
    ldr r4, [r0, #64]
    ldr r5, [r0, #84]
    eor r12, r1, r2
    eor r12, r12, r3
    eor r12, r12, r4
    eor r12, r12, r5 // sum of Sheet 2 in r12
    //store sum of Sheet 2 in stack #4
    str r12, [sp, #4]

    // load sheet 3
    ldr r6, [r0, #8]
    ldr r7, [r0, #28]
    ldr r8, [r0, #48]
    ldr r9, [r0, #68]
    ldr r10, [r0, #88]
    eor r12, r6, r7
    eor r12, r12, r8
    eor r12, r12, r9
    eor r12, r12, r10 // sum of Sheet 3 in r12
    //store sum of Sheet 3 in stack #8
    str r12, [sp, #8]


    //Compute θ step on sheet 2
    ror r12, #31
    eor r12, r11, r12
    eor r1, r1, r12
    eor r2, r2, r12
    eor r3, r3, r12
    eor r4, r4, r12
    eor r5, r5, r12
    // Store updated sheet 2
    str r1, [r0, #4]
    str r2, [r0, #24]
    str r3, [r0, #44]
    str r4, [r0, #64]
    str r5, [r0, #84]

    // load sheet 4
    ldr r1, [r0, #12]
    ldr r2, [r0, #32]
    ldr r3, [r0, #52]
    ldr r4, [r0, #72]
    ldr r5, [r0, #92]
    eor r11, r1, r2
    eor r11, r11, r3
    eor r11, r11, r4
    eor r11, r11, r5 // sum of Sheet 4 in r11
    //store sum of Sheet 4 in stack #12
    str r11, [sp, #12]

    //Compute θ step on sheet 3
    ldr r12, [sp, #4]
    ror r11, #31
    eor r12, r12, r11
    eor r6, r6, r12
    eor r7, r7, r12
    eor r8, r8, r12
    eor r9, r9, r12
    eor r10, r10, r12
    // Store updated sheet 3
    str r6, [r0, #8]
    str r7, [r0, #28]
    str r8, [r0, #48]
    str r9, [r0, #68]
    str r10, [r0, #88]

    // load sheet 5
    ldr r6, [r0, #16]
    ldr r7, [r0, #36]
    ldr r8, [r0, #56]
    ldr r9, [r0, #76]
    ldr r10, [r0, #96]
    // compute sum of sheet 5 in r12
    eor r12, r6, r7
    eor r12, r12, r8
    eor r12, r12, r9
    eor r12, r12, r10
    str r12, [sp, #16]

    // Compute step of θ on sheet 4
    ldr r11, [sp, #8]
    ror r12, #31
    eor r12, r11, r12
    eor r1, r1, r12
    eor r2, r2, r12
    eor r3, r3, r12
    eor r4, r4, r12
    eor r5, r5, r12
    // Store updated sheet 4
    str r1, [r0, #12]
    str r2, [r0, #32]
    str r3, [r0, #52]
    str r4, [r0, #72]
    str r5, [r0, #92]

    //Load sheet 1
    ldr r1, [r0, #0]
    ldr r2, [r0, #20]
    ldr r3, [r0, #40]
    ldr r4, [r0, #60]
    ldr r5, [r0, #80]

    // Compute θ step on sheet 1
    ldr r11, [sp, #16]
    ldr r12, [sp, #4]
    ror r12, #31
    eor r12, r12, r11

    eor r1, r1, r12
    eor r2, r2, r12
    eor r3, r3, r12
    eor r4, r4, r12
    eor r5, r5, r12
    //Store updated sheet 1
    str r1, [r0, #0]
    str r2, [r0, #20]
    str r3, [r0, #40]
    str r4, [r0, #60]
    str r5, [r0, #80]

    // Compute θ step on sheet 5
    ldr r11, [sp, #12]
    ldr r12, [sp, #0]
    ror r12, #31
    eor r12, r12, r11
    eor r6, r6, r12
    eor r7, r7, r12
    eor r8, r8, r12
    eor r9, r9, r12
    eor r10, r10, r12
    // Store updated sheet 5
    str r6, [r0, #16]
    str r7, [r0, #36]
    str r8, [r0, #56]
    str r9, [r0, #76]
    str r10, [r0, #96]

    add sp, sp, #(4 * 5)
    bx lr


//////////////////////////////////////////////////////////////////////////
////////////////////////////////// RHO_PI ////////////////////////////////
//////////////////////////////////////////////////////////////////////////


.align 4
.global   rhoPi
.type   rhoPi, %function;
rhoPi:

    ldr r11, =KeccakP800_RotationConstants
    ldr r12, =KeccakP800_PiLane

    mov r10, #24 // r10 = limit of for loop
    mov r9, #0 //r9 = x
    ldr r1, [r0, #4] // t1 = tempA
loop:
    lsl r8, r9, #2
    ldr r3, [r12, r8] // KeccakP800_PiLane[x] value
    lsl r7, r3, #2
    ldr r2, [r0, r7] // t2 = BC[x]

    ldr r4, [r11, r8] // KeccakP800_RotationConstants[x] value

    mov r5, #32
    sub r5, r5, r4
    ror r6, r1, r5 // ROL32(tempA,s8)

    str r6, [r0, r7] // store rotated at new position

    mov r1, r2 // temp = BC[x]
    add r9, #1
    cmp r9, r10

    blt loop

    bx lr

//////////////////////////////////////////////////////////////////////////
////////////////////////////////// CHI ///////////////////////////////////
//////////////////////////////////////////////////////////////////////////

// r1 for share 0 randomness
// r7 for share 1 randomness
// r2-r6 for input shares state0
// r8-r12 for input shares state1
// r14 temporary register for cross-products

.align 4
.global   chi
.type   chi, %function;
chi:

    push {r4-r11,r14}
    sub sp, sp, #(4 * 15)

    str r0, [sp, #32]// save pt state A in stack
    str r1, [sp, #36]// save pt state B in stacK
    str r2, [sp, #40]// save pt Randomness R0 in stack
    str r3, [sp, #44]// save pt Randomness R1 in stack

    mov r14, #0
    str r14, [sp, #8]


loopChi:

    // compute all index(x,y) values

    mov r0, #0 // r0 = x = 0
    ldr r1, [sp, #8] // r1 = y
    bl index
    str r0, [sp, #12] // store value index(0, y)

    mov r0, #1 // r0 = x = 1
    ldr r1, [sp, #8] // r1 = y
    bl index
    str r0, [sp, #16] // store value index(1, y)

    mov r0, #2 // r0 = x = 2
    ldr r1, [sp, #8] // r1 = y
    bl index
    str r0, [sp, #20] // store value index(2, y)

    mov r0, #3 // r0 = x = 3
    ldr r1, [sp, #8] // r1 = y
    bl index
    str r0, [sp, #24] // store value index(3, y)

    mov r0, #4 // r0 = x = 4
    ldr r1, [sp, #8] // r1 = y
    bl index
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
    blt loopChi

    add sp, sp, #(4 * 15)
    pop {r4-r11,r14}
    bx lr


//////////////////////////////////////////////////////////////////////////
/////////////////////////////////// IOTA//////////////////////////////////
//////////////////////////////////////////////////////////////////////////


.align 4
.global   iota
.type   iota, %function;
iota:
    // r0 = void * state0
    // r1 = nround

    ldr r12, =KeccakRoundConstants
    lsl r7, r1, #2
    ldr r7, [r12,r7] // value KeccakRoundConstants[x]
    ldr r2, [r0] // get state0(0,0)
    eor r2, r2, r7
    str r2, [r0]

    bx lr


///////////////////////////////////////////////////////////////////////
/////////////////////////// KeccakF800_StatePermute ///////////////////
///////////////////////////////////////////////////////////////////////

.align 4
.global   KeccakF800_StatePermute
.type   KeccakF800_StatePermute, %function;
KeccakF800_StatePermute:

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
    bl chi
    ldr r0, [sp, #8]
    ldr r1, [sp, #0]
    /////// iota ///////
    bl iota
    ldr r1, [sp, #4]

    ldr r11, [sp, #0]
    add r11, r11, #1
    str r11, [sp, #0]
    cmp r11, #22
    blt mainloop

    add sp, sp, #(4 * 6)
    pop {r4-r11,lr}
    bx lr
