.global _start


Stuff:		.byte 6,-11, 2 // input array
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
	@ this is a selection sort algorithm
	@ array is sorted in place 
	
	// push preserved registers and lr to stack
	push {v1-v7, lr}
	
	// initialize i = -1 for outer loop
	// first i value will be 0
	mov r2, #0
	sub r2, r2, #1 
	
	// n-1 for condition checks (static)
	sub r4, r1, #1
	
outer_loop:
	// increment i
	add r2, r2, #1 // i++
	
	// check loop condition i < (n-1)
	cmp r2, r4 // flags for i - (n-1)
	bge sort_done // if i >= (n-1), sorting is complete
	
	// small = i
	mov r5, r2 
	
	// initial j=i for inner loop
	// first j value will be j = i + 1
	mov r3, r2 // j <- i

inner_loop:
	// increment j
	add r3, r3, #1 // j++
	
	// check loop conditionn j<n
	cmp r3, r1 // flags for j - n
	bge swap // if j >= n, done inner loop


if: // part of inner_loop

	//load arr[small] from memory
	ldrsb r6, [r0, r5] // arr[small] <- mem(=Stuff + small)
	
	// load arr[j] from memory
	ldrsb r7, [r0, r3] // arr[j] <- mem(=Stuff + j)
	
	// compare arr[j] < arr[small]
	cmp r7, r6 // flags for arr[j] - arr[small]
	bge inner_loop // if arr[j] >= arr[small], skip if and return to innter_loop
	
	// if is TRUE
	mov r5, r3 // small <- j
	
swap:
	// re-load new arr[small]
	ldrsb r6, [r0, r5] // arr[small] <- mem(=Stuff + small)
	
	// move arr[small] to temp
	mov r8, r6 // temp <- arr[small]
	
	// load arr[i] overwriting arr[j]
	ldrsb r7, [r0, r2] // arr[i] <- mem(=Stuff + i)
	
	// store arr[i] in location of arr[small]
	strb r7, [r0, r5] // arr[i] -> mem(=Stuff + small)
	
	// store temp to arr[i]
	strb r8, [r0, r2] // temp -> mem(=Stuff + i)
	
	// restart outer loop
	b outer_loop
	
sort_done: // return to pc=lr, restore convention registers
	pop {v1-v7, pc}

	
