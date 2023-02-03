.syntax unified
.thumb

.text

.align 4
.global   test_Sboxes
.type   test_Sboxes, %function;
test_Sboxes:

// r0 = void * state0
// r1 = void * state1
// r2 = void * out0
// r3 = void * out1

    push {r4-r11,lr}
    // load share 0 into register
    ldr r4, [r0, #0]
    ldr r5, [r0, #4]
    ldr r6, [r0, #8]
    ldr r7, [r0, #12]

    // load share 1 into register
    ldr r8, [r1, #0]
    ldr r9, [r1, #4]
    ldr r10, [r1, #8]
    ldr r11, [r1, #12]


    ////////////////////////////////
    ////////////SboxesQ4////////////
    ////////////////////////////////
    ////////////// d0 + a0b0
      // b0c0
      and R12, R4, R5
      eor R7, R7, R12

     ////////////// d0 + a0b0 + a0b1
      // a0b1
      ror R4, #2
      ror R9, #1
      and R12, R4, R9
      ror R4, #30
      ror R9, #31
      ror R7, #2
      eor R7, R7, R12
      ror R7, #30

      ////////////// d1 + a1b1
      // b1c1
      and R12, R8, R9
      eor R11, R11, R12

      ////////////// d1 + a1b1 + a1b0
      // a1b0
      ror R5, #2
      ror R8, #1
      and R12, R5, R8
      ror R5, #30
      ror R8, #31
      ror R11, #1
      eor R11, R11, R12
      ror R11, #31

    ////////////////////////////////
    ////////////SboxesQ12////////////
    ////////////////////////////////

    /////////// PTs(b,a,c) ///////////

    // b0c0
    and R12, R4, R6
    eor R5, R5, R12

    ////////////// R5 + b0c0 + b0c1
    // b0c1
    ror R4, #2
    ror R10, #1
    and R12, R4, R10
    ror R4, #30
    ror R10, #31
    ror R5, #2
    eor R5, R5, R12
    ror R5, #30
    ////////////// R4 + b1c1
    // b1c1
    and R12, R8, R10
    eor R9, R9, R12
    ////////////// R4 + b1c1 + b1c0
    // b1c0
    ror R6, #2
    ror R8, #1
    and R12, R6, R8
    ror R6, #30
    ror R8, #31
    ror R9, #1
    eor R9, R9, R12
    ror R9, #31

 /////////// PTs(c,a,b) ///////////
    ////////////// R6 + b0c0
    // b0c0
    and R12, R4, R5
    eor R6, R6, R12

    ////////////// R6 + b0c0 + b0c1
    // b0c1
    ror R4, #2
    ror R9, #1
    and R12, R4, R9
    ror R4, #30
    ror R9, #31
    ror R6, #2
    eor R6, R6, R12
    ror R6, #30

    ////////////// R4 + b1c1
    // b1c1
    and R12, R8, R9
    eor R10, R10, R12

    ////////////// R4 + b1c1 + b1c0
    // b1c0
    ror R5, #2
    ror R8, #1
    and R12, R5, R8
    ror R5, #30
    ror R8, #31
    ror R10, #1
    eor R10, R10, R12
    ror R10, #31

////////////////////////////////
    ////////////SboxesQ293//////////
    ////////////////////////////////

    /////////// PTs(d,b,c) ///////////
    ////////////// R7 + b0c0
    // b0c0
    and R12, R5, R6
    eor R7, R7, R12

    ////////////// R7 + b0c0 + b0c1
    // b0c1
    ror R5, #2
    ror R10, #1
    and R12, R5, R10
    ror R5, #30
    ror R10, #31
    ror R7, #2
    eor R7, R7, R12
    ror R7, #30

    ////////////// R5 + b1c1
    // b1c1
    and R12, R9, R10
    eor R11, R11, R12

    ////////////// R5 + b1c1 + b1c0
    // b1c0
    ror R6, #2
    ror R9, #1
    and R12, R6, R9
    ror R6, #30
    ror R9, #31
    ror R11, #1
    eor R11, R11, R12
    ror R11, #31

  /////////// PTs(b,a,c) ///////////
    ////////////// R5 + b0c0
    // b0c0
    and R12, R4, R6
    eor R5, R5, R12

    ////////////// R5 + b0c0 + b0c1
    // b0c1
    ror R4, #2
    ror R10, #1
    and R12, R4, R10
    ror R4, #30
    ror R10, #31
    ror R5, #2
    eor R5, R5, R12
    ror R5, #30

    ////////////// R4 + b1c1
    // b1c1
    and R12, R8, R10
    eor R9, R9, R12

    ////////////// R4 + b1c1 + b1c0
    // b1c0
    ror R6, #2
    ror R8, #1
    and R12, R6, R8
    ror R6, #30
    ror R8, #31
    ror R9, #1
    eor R9, R9, R12
    ror R9, #31

  /////////// PTs(c,a,b) ///////////
    ////////////// R6 + b0c0
    // b0c0
    and R12, R4, R5
    eor R6, R6, R12

    ////////////// R6 + b0c0 + b0c1
    // b0c1
    ror R4, #2
    ror R9, #1
    and R12, R4, R9
    ror R4, #30
    ror R9, #31
    ror R6, #2
    eor R6, R6, R12
    ror R6, #30

    ////////////// R4 + b1c1
    // b1c1
    and R12, R8, R9
    eor R10, R10, R12

    ////////////// R4 + b1c1 + b1c0
    // b1c0
    ror R5, #2
    ror R8, #1
    and R12, R5, R8
    ror R5, #30
    ror R8, #31
    ror R10, #1
    eor R10, R10, R12
    ror R10, #31

    ////////////////////////////////
    ////////////SboxesQ294//////////
    ////////////////////////////////

    /////////// PTs(c,a,b) ///////////
    ////////////// R6 + b0c0
    // b0c0
    and R12, R4, R5
    eor R6, R6, R12

    ////////////// R6 + b0c0 + b0c1
    // b0c1
    ror R4, #2
    ror R9, #1
    and R12, R4, R9
    ror R4, #30
    ror R9, #31
    ror R6, #2
    eor R6, R6, R12
    ror R6, #30

    ////////////// R4 + b1c1
    // b1c1
    and R12, R8, R9
    eor R10, R10, R12

    ////////////// R4 + b1c1 + b1c0
    // b1c0
    ror R5, #2
    ror R8, #1
    and R12, R5, R8
    ror R5, #30
    ror R8, #31
    ror R10, #1
    eor R10, R10, R12
    ror R10, #31


  /////////// PTs(d,a,b) ///////////
    ////////////// R7 + b0c0
    // b0c0
    and R12, R4, R5
    eor R7, R7, R12

    ////////////// R7 + b0c0 + b0c1
    // b0c1
    ror R4, #2
    ror R9, #1
    and R12, R4, R9
    ror R4, #30
    ror R9, #31
    ror R7, #2
    eor R7, R7, R12
    ror R7, #30

    ////////////// R4 + b1c1
    // b1c1
    and R12, R8, R9
    eor R11, R11, R12

    ////////////// R4 + b1c1 + b1c0
    // b1c0
    ror R5, #2
    ror R8, #1
    and R12, R5, R8
    ror R5, #30
    ror R8, #31
    ror R11, #1
    eor R11, R11, R12
    ror R11, #31

     /////////// PTs(d,a,c) ///////////
    ////////////// R7 + b0c0
    // b0c0
    and R12, R4, R6
    eor R7, R7, R12

    ////////////// R7 + b0c0 + b0c1
    // b0c1
    ror R4, #2
    ror R10, #1
    and R12, R4, R10
    ror R4, #30
    ror R10, #31
    ror R7, #2
    eor R7, R7, R12
    ror R7, #30

    ////////////// R4 + b1c1
    // b1c1
    and R12, R8, R10
    eor R11, R11, R12

    ////////////// R4 + b1c1 + b1c0
    // b1c0
    ror R6, #2
    ror R8, #1
    and R12, R6, R8
    ror R6, #30
    ror R8, #31
    ror R11, #1
    eor R11, R11, R12
    ror R11, #31


    ////////////////////////////////
    ////////////SboxesQ299//////////
    ////////////////////////////////

    /////////// PTs(b,a,c) ///////////
    ////////////// R5 + b0c0
    // b0c0
    and R12, R4, R6
    eor R5, R5, R12

    ////////////// R5 + b0c0 + b0c1
    // b0c1
    ror R4, #2
    ror R10, #1
    and R12, R4, R10
    ror R4, #30
    ror R10, #31
    ror R5, #2
    eor R5, R5, R12
    ror R5, #30

    ////////////// R4 + b1c1
    // b1c1
    and R12, R8, R10
    eor R9, R9, R12

    ////////////// R4 + b1c1 + b1c0
    // b1c0
    ror R6, #2
    ror R8, #1
    and R12, R6, R8
    ror R6, #30
    ror R8, #31
    ror R9, #1
    eor R9, R9, R12
    ror R9, #31

      /////////// PTs(c,a,b) ///////////
    ////////////// R6 + b0c0
    // b0c0
    and R12, R4, R5
    eor R6, R6, R12
    ////////////// R6 + b0c0 + b0c1
    // b0c1
    ror R4, #2
    ror R9, #1
    and R12, R4, R9
    ror R4, #30
    ror R9, #31
    ror R6, #2
    eor R6, R6, R12
    ror R6, #30
    ////////////// R4 + b1c1
    // b1c1
    and R12, R8, R9
    eor R10, R10, R12
    ////////////// R4 + b1c1 + b1c0
    // b1c0
    ror R5, #2
    ror R8, #1
    and R12, R5, R8
    ror R5, #30
    ror R8, #31
    ror R10, #1
    eor R10, R10, R12
    ror R10, #31


     /////////// PTs(b,a,c) ///////////
    ////////////// R5 + b0c0
    // b0c0
    and R12, R4, R6
    eor R5, R5, R12
    ////////////// R5 + b0c0 + b0c1
    // b0c1
    ror R4, #2
    ror R10, #1
    and R12, R4, R10
    ror R4, #30
    ror R10, #31
    ror R5, #2
    eor R5, R5, R12
    ror R5, #30
    ////////////// R4 + b1c1
    // b1c1
    and R12, R8, R10
    eor R9, R9, R12
    ////////////// R4 + b1c1 + b1c0
    // b1c0
    ror R6, #2
    ror R8, #1
    and R12, R6, R8
    ror R6, #30
    ror R8, #31
    ror R9, #1
    eor R9, R9, R12
    ror R9, #31


      /////////// PTs(c,a,d) ///////////
    ////////////// R6 + b0c0
    // b0c0
    and R12, R4, R7
    eor R6, R6, R12
    ////////////// R6 + b0c0 + b0c1
    // b0c1
    ror R4, #2
    ror R11, #1
    and R12, R4, R11
    ror R4, #30
    ror R11, #31
    ror R6, #2
    eor R6, R6, R12
    ror R6, #30
    ////////////// R4 + b1c1
    // b1c1
    and R12, R8, R11
    eor R10, R10, R12
    ////////////// R4 + b1c1 + b1c0
    // b1c0
    ror R7, #2
    ror R8, #1
    and R12, R7, R8
    ror R7, #30
    ror R8, #31
    ror R10, #1
    eor R10, R10, R12
    ror R10, #31

     /////////// PTs(d,a,c) ///////////
    ////////////// R7 + b0c0
    // b0c0
    and R12, R4, R6
    eor R7, R7, R12
    ////////////// R7 + b0c0 + b0c1
    // b0c1
    ror R4, #2
    ror R10, #1
    and R12, R4, R10
    ror R4, #30
    ror R10, #31
    ror R7, #2
    eor R7, R7, R12
    ror R7, #30
    ////////////// R4 + b1c1
    // b1c1
    and R12, R8, R10
    eor R11, R11, R12
    ////////////// R4 + b1c1 + b1c0
    // b1c0
    ror R6, #2
    ror R8, #1
    and R12, R6, R8
    ror R6, #30
    ror R8, #31
    ror R11, #1
    eor R11, R11, R12
    ror R11, #31


       ////////////////////////////////
    ////////////SboxesQ300//////////
    ////////////////////////////////


    eor R5, R5, R4
    eor R9, R9, R8


    eor R6, R6, R4
    eor R10, R10, R8

    /////////// PTs(a,b,c) ///////////
    ////////////// R4 + b0c0
    // b0c0
    and R12, R5, R6
    eor R4, R4, R12
    ////////////// R4 + b0c0 + b0c1
    // b0c1
    ror R5, #2
    ror R10, #1
    and R12, R5, R10
    ror R5, #30
    ror R10, #31
    ror R4, #2
    eor R4, R4, R12
    ror R4, #30
    ////////////// R5 + b1c1
    // b1c1
    and R12, R9, R10
    eor R8, R8, R12
    ////////////// R5 + b1c1 + b1c0
    // b1c0
    ror R6, #2
    ror R9, #1
    and R12, R6, R9
    ror R6, #30
    ror R9, #31
    ror R8, #1
    eor R8, R8, R12
    ror R8, #31

    /////////// PTs(b,a,c) ///////////
    ////////////// R5 + b0c0
    // b0c0
    and R12, R4, R6
    eor R5, R5, R12
    ////////////// R5 + b0c0 + b0c1
    // b0c1
    ror R4, #2
    ror R10, #1
    and R12, R4, R10
    ror R4, #30
    ror R10, #31
    ror R5, #2
    eor R5, R5, R12
    ror R5, #30
    ////////////// R4 + b1c1
    // b1c1
    and R12, R8, R10
    eor R9, R9, R12
    ////////////// R4 + b1c1 + b1c0
    // b1c0
    ror R6, #2
    ror R8, #1
    and R12, R6, R8
    ror R6, #30
    ror R8, #31
    ror R9, #1
    eor R9, R9, R12
    ror R9, #31


      /////////// PXs(c,b,a) ///////////

    ////////////// R6 + b0c0 + c0
    // b0c0
    and R12, R5, R4
    eor R6, R6, R12
    eor R6, R6, R4
    ////////////// R6 + b0c1 + c1
    // b0c1
    ror R5, #2
    ror R8, #1
    and R12, R5, R8
    // b0c1 + c1
    eor R12, R12, R8
    ror R5, #30
    ror R8, #31
    // R6 + b0c1 + c1
    ror R6, #2
    eor R6, R6, R12
    ror R6, #30
    ////////////// R5 + b1c1
    // b1c1
    and R12, R9, R8
    eor R10, R10, R12
    ////////////// R5 + b1c0
    // b1c0
    ror R4, #2
    ror R9, #1
    and R12, R4, R9
    ror R4, #30
    ror R9, #31
    ror R10, #1
    eor R10, R10, R12
    ror R10, #31


    str R4, [r2, #0]//a0
    str R5, [r2, #4]//b0
    str R6, [r2, #8]//c0
    str R7, [r2, #12] //d0

    str R8, [r3, #0]//a1
    str R9, [r3, #4]//b1
    str R10, [r3, #8]//c1
    str R11, [r3, #12] //d1

    pop {r4-r11,lr}
    bx lr
