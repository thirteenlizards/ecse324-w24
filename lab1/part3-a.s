.global _start


Stuff:		.byte -5, 3, 1 // input array
			.space 1	// to align next word
N: 			.word	3	// number of elements in Stuff
Sorted:		.space 3	// (optional) sorted output
			.space 1	// to align next word

_start:
	ldr		A1, =Stuff	// get the address of Stuff
	ldr		A2, N		// get the number of things in Stuff
	bl		sort		// go!
	
stop:
	b		stop

// Sorting algorithm
// pre-- A1: Address of array of signed bytes to be sorted
// pre-- A2: Number of elements in array
// post- A1: Address of sorted array
sort:
// BIG NOTES:
	@ this is a bubble sort algorithm
	@ array is sorted in place because I didn't want to keep track of more registers
	@ note that all load and store to array is in bytes with signed load (ldrsb, strb)
	
// stuff here should only happen once
	// push  lr and all geneva convention registers to stack
	push {v1-v7, lr}
	
	// set index for outer loop to -1 so we can pre-index
	// this is because I forget how to post-index is this control structure
	mov r2, #0 //MOV, R2, #-1 is invalid
	sub r2, r2, #1 // now R2 has value -1

outer_loop:
// stuff here should happen the same number of times as array values

// increment outer index before checking conditions (i++)
	add r2, r2, #1 // R2 <- R2 + 1
	
// check outer loop conditions
// only do outer loop when i < (n-1)
	sub r1, r1, #1 // n <- n - 1 temporarially because why use more register when few register do trick
	cmp r2, r1 // compare i to (n-1)
	add r1, r1, #1 // restore n to OG form
	
	// loops for i < (n-1), goes elsewhere if n >= i
	bge sort_done // if fails outer loop condition check, code is done time to sleep

// here, we have passed outer loop checks

// reset inner loop index to -1 (no 0 so I can pre-index)
	mov r3, #0 // r3 <- 0
	sub r3, r3, #1 // r3 <- r3=0 -1 so not r3 = -1
	
inner_loop:
// increment inner loop index before checking conditions
	add r3, r3, #1 // j++, aka r3 <- r3 +1

// check inner loop conditions
// only do inner loop when j < (n - i - 1)

	// calculate n < - n - i - 1
	sub r1, r1, r2 // n <- n - i
	sub r1, r1, #1 // n <- n - i
	
	cmp r3, r1 // compare j to (n -1)
	
	// restore n <- n + i + 1
	add r1, r1, r2 // n <- n + i
	add r1, r1, #1 // n <- n + 1
	
	// if j <= (n - i - 1), start outer loop over again
	bge outer_loop

if:
// check conditions for if statement
// calculate and check if arr[j] > arr[j+1]

	// find arr[j] and load to r4
	// changed to ldrsb from ldrb here and elsewhere
	ldrsb r4, [r0, r3] // r4 <- addr(addr(stuff) + j)
	
	// find arr[j+1] and load to r5
	add r7, r3, #1 // r7 <- j + 1
	ldrsb r5, [r0, r7] // r5 <- addr(addr(stuff) + j + 1)
	
	// if arr[j] > arr[j+1] perform swap
	cmp r4, r5 // arr[j] - arr[j-1]
	blt inner_loop // arr[j] <= arr[j+1], skip swap
	
// perform swap

	// assign value of arr[j] to a register
	mov r6, r4 // r6 <- r4 = arr[j]
	
	//assign arr[j+1] to arr[j]
	mov r4, r5 // r4 <- r5 = arr[j+1]
	strb r4, [r0, r3] // r4 -> addr(addr(stuff) + j)
	// strsb isn't real, bc memory doesn't care
	
	// assign OG value of arr[j] to arr[j+1]
	mov r5, r6 // r5 <- r6 = temp
	strb r5, [r0, r7] // r5 -> addr(addr(stuff) + j + 1)
	
	// swap is done, return to inner loop
	b inner_loop
	

sort_done:
// pop convention registers and program counter to return to _start ins
	pop {v1-v7, pc} 
	
	

