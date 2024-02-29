.global _start

N: 			.word	1	// input parameter n
P:			.space 4	// Pell number result

_start:
	ldr		A1, N		// get the input parameter
	bl		pell		// go!
	str		A1, P		// save the result
	
stop:
	b		stop

// Pell number calculation
// pre-- A1: Pell number index i to calculate, n >= 0
// post- A1: Pell number P = pell(n)
pell: // start of pell function
//NOTE: a1=r0, I use r0 for ease

// push linked register
	push {lr}

// check base cases
	// if n==1, return n
	cmp r0, #1 
	beq end_pell

	// if n==0, return n
	cmp r0, #0
	beq end_pell

// recursive case (base cases not fullfilled)
	push {r0} // save current n to stack
	
	// pell(n-1)
	sub r0, r0, #1 // decrement current n
	bl pell // recursive call
	pop {r1} // pop OG n to r1
	push {r0} // save pell(n-1) to stack

	// pell(n-2)
	sub r0, r1, #2 // double decrement current n
	bl pell // recursive call for pell(n-2)
	
// compute result
	pop {r1} // pell(n-1)
	mov r2, #2 // r2 <- 2
	mul r2, r2, r1 // r2 <- R2=2 * pell(n-1)
	add r0, r2, r0 // r0 <- [2*pell(n-1)] + pell(n-2)
	

end_pell: // modify stack at end of pell
// return to pc value
	pop {pc}

