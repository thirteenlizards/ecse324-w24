.global _start

N: 			.word	5	// input parameter n
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
pell:
// push linked register and v1, v2 used in function
	push {r4, r5, lr}
	
// check base cases
	// if n==1, return n
	cmp r0, #1 // flags for r0-1
	beq special_end_pell
	
	// if n==0, return 0
	cmp r0, #0 // flags for r0-0
	beq special_end_pell
	
// loop initial conditions
	mov r4, #3 // set index=i to 3
	mov r1, #1 // set pell(n-2) to 1
	mov r2, #2 // set pell(n-1) to 2
loop:
// check conditions
	// cmp r0, r4 // flags for n-i
	cmp r4, r0 // flags for i-n
	bgt end_pell // if NOT i<=n, escape loop
	
// calculate pell number
	// calculate 2 * pell (n-1)
	mov r5, #2// r5 <- 2
	mul r5, r5, r2 // r5 <- r5=2 * r2=pell(n-1)
	
	// calculate sum P = [2 * pell (n-1)] + pell(n-2)
	add r3, r5, r1 // r3 <- r5 + r1

// compute pell(n-1), pell(n-2), index for next iteration
	// pell(n-2) = pell(n-1)
	mov r1, r2 // r1 <- r2
	
	// pell(n-1) = pell(n)
	mov r2, r3 // r2 <- r3
	
	// index++
	add r4, r4, #1 // r4 <- r4 + 1
	
// unconditional branch to top of loop
	b loop
	
end_pell:
	// return value in register r0 (aka a1 wearing a hat with glasses, nose, and mustache)
	mov r0, r3 // r0 <- r3

// runs when special cases are end sequence SO
// r0 is already return value
special_end_pell:
	// return to pc value, restore registers used in function
	pop {r4, r5, pc}
	