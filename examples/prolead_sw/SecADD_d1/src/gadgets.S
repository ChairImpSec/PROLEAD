#define ASM
#define D 2
#define D4 128
#define DM 1

.syntax unified
.thumb

#define CODESECT .section .text
#define EXPORT .global

CODESECT
      EXPORT my_masked_and_asm
      EXPORT my_masked_xor_asm
      EXPORT copy_sharing_asm
/*
r0 -> tmp 
r1 -> tmp
r2 -> tmp
r3 -> tmp
r4 -> 4 * a_stride
r5 -> b
r6 -> 4 * b_stride
r7 -> NSHARES
r8 -> a
*/
my_masked_and_asm:
    stmdb sp!, {r4,r5,r6,r7,r8,r9,sl,fp,r12,lr} // write done 10 registers -> 40 bytes
    ldr r4, [sp, #40]
    ldr r5, [sp, #44]
    ldr r6, [sp, #48]
    lsl r4, #2
    lsl r6, #2
    // put the stack down to store NSHARES words
    mov r7, r0
    mov r8, r3
    
    push {r1,r2} // push z and z_stride (only need them at the end)
    sub sp, D4
    str r4, [sp,D4-4]

    mov r0, #0 // r0 is i
loop_ab: // loop to compute z_tmp[i] = a[i * a_stride] & b[i * b_stride];
    mul r2, r0, r4   // i * a_stride
    ldr r1, [sp,D4-4]
    ldr r1, [r8,r2]  // r1 = a[ i * a_stride]
    ldr r2, [sp,D4-4]
    mul r2, r0, r6   // i * b_stride
    ldr r2, [r5,r2]  // r2 = b[ i * b_stride]
    and r2,r2,r1     // r2 = r1 & r2
    lsl r1, r0, #2   //
    str r2, [sp,r1]  // z_tmp[i] = r1 & r2
    str r1, [sp,D4-4]
    mov r2, #0
    add r0, #1
    cmp r7, r0
    bne loop_ab
    // no loop if nshares = 1
    cmp r7, #1
    beq my_out

    // r9 = i, r10 = j
    mov r9, #0 

loop_cross_ext:
    add r10, r9, #1
    loop_cross_in:
        bl get_random
        // pini core r1 = ai, r2 = bj // r3 = tmp // r11 s 
        mul r2, r10, r6
        ldr r2, [r5, r2]    // r2 = b[j * b_stride]
        ldr r3, [sp,D4-4]   // dummy read
        eor r2, r2, r0     // r2 = bj ^ r                                      eors -----------------------------------------------------------------------------------------------
        mul r1, r9, r4     
        ldr r1, [r8,r1]     // r1 = a[i * a_stride]
        bic r3, r0, r1      // r3 = r & (ai ^ 1)
        str r0, [sp,D4-8]     // store randomness on the stack and erase
        str r9, [sp,D4-4]   // dummy
        mov r0, #0          // clear alea
        and r2, r1, r2      // r2 = ai & ( bj ^ r)
        lsl r1, r9, #2    
        eor r3, r2, r3      // r3 = pini_core 
        ldr r2, [sp,D4-4]   // dummy
        ldr r2, [sp, r1]   
        eor r2,r2,r3
        str r2, [sp, r1]
        str r1, [sp, D4-4] // dummy writting
        mov r2, #0
        mov r3, #0

        ldr r0, [sp,D4-8]     // load randomness from the stack 
        mul r2, r9, r6
        ldr r2, [r5, r2]    // r2 = b[i * b_stride]
        ldr r3, [sp,D4-4]   // dummy read
        eor r2, r2, r0     // r2 = bj ^ r                                       eors ---------------------------------------------------------------------------------------------
        mul r1, r10, r4     
        ldr r1, [r8,r1]     // r1 = a[j * a_stride]
        bic r3, r0, r1      // r3 = r & (ai ^ 1)
        mov r0, #0          // clear randomness on the stack and reg
        str r0, [sp,D4-8]     // store randomness on the stack and erase
        and r2, r1, r2      // r2 = ai & ( bj ^ r)
        lsl r1, r10, #2    
        eor r3, r2, r3      // r3 = pini_core 
        ldr r2, [sp,D4-4]   // dummy
        ldr r2, [sp, r1]   
        eor r2,r2,r3
        str r2, [sp, r1]
        str r1, [sp, D4-4] // dummy writting
        mov r2, #0
        mov r3, #0

        // control of the loop
        add r10, #1
        cmp r7,r10
        bne loop_cross_in // end inner loop

    // control of the loop
    sub r7, #1
    add r9, #1
    cmp r7,r9
    add r7, #1
    bne loop_cross_ext

my_out:
    add sp, D4
    pop {r1,r2}
    push {r1,r2}
    sub sp, D4

    mov r0, #0 // r0 is i
    lsl r2, r2, #2
    // r2 = z_stride
    // r1 = z
loop_cmp: // z[i * z_stride] = ztmp[i] 
    ldr r4, [sp,D4-4]
    lsl r4, r0, #2
    ldr r4, [sp, r4] // ztmp[i]
    mul r3, r0, r2   
    str r0, [r1,r3]
    str r4, [r1,r3]  // z_[i*z_stride] = ztmp[i]
    ldr r3, [sp,D4-4]
    add r0, #1
    mov r4, #0
    cmp r7, r0
    bne loop_cmp

my_out_full:
    add sp, D4
    pop {r1,r2}
    ldmia.w sp!, {r4,r5,r6,r7,r8,r9,sl,fp,r12,pc}

/*
r0 -> NSHARES
r1 -> z
r2 -> z_stride
r3 -> a
r4 -> 4 * a_stride
r5 -> b
r6 -> 4 * b_stride
r7 -> loop count
r8 -> tmp
r9 -> tmp
*/

my_masked_xor_asm:
    stmdb sp!, {r4,r5,r6,r7,r8,r9,sl,fp,r12,lr} // write done 10 registers -> 40 bytes
    ldr r4, [sp, #40]
    ldr r5, [sp, #44]
    ldr r6, [sp, #48]
    lsl r0, #2    
    sub sp, #4

    mov r7, #0 // r0 is i
    str r7, [sp]
loop_ab_xor: // loop to compute z_tmp[i] = a[i * a_stride] & b[i * b_stride];
    ldr r8, [sp]     // dummy writing 
    mul r8, r7, r4   // i * a_stride
    ldr r8, [r3,r8]  // r8 =a[ i * a_stride]
    ldr r9, [sp]     // dummy writing 
    mul r9, r7, r6   // i * b_stride
    ldr r9, [r5,r9]  // r9 = b[ i * a_stride]
    eor r9, r9, r8   // r9 = a ^ b
    mul r8, r7, r2   // 
    str r7, [sp]     // dummy writing 
    str r7, [r1,r8]     // dummy writing 
    str r9, [r1, r8] //
    ldr r7, [sp]     // dummy writing 
    mov r9, #0
    add r7, #4
    cmp r7, r0
    bne loop_ab_xor
    add sp, #4
    ldmia.w sp!, {r4,r5,r6,r7,r8,r9,sl,fp,r12,pc}


copy_sharing_asm:
   	cbz	r0, cp_out 
   	push	{r4, r5, r6,r0}
   	lsls	r5, r2, #2
   	ldr	r2, [sp, #16]
   	lsls	r6, r2, #2
   	movs	r2, #0
copy_sharing_loop:
    adds	r2, #1
    ldr r4, [sp]
   	ldr	r4, [r3, #0]
    str r0, [sp] 
   	str	r4, [r1, #0]
    mov r4, #0
   	cmp	r0, r2
   	add	r3, r6
   	add	r1, r5
   	bne.n copy_sharing_loop	
    str r0, [sp] 
   	pop	{r4, r5, r6, r0}
   	bx	lr
cp_out:
    bx	lr

