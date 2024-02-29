.global _start

N: 		.word 12
Numbers: 	.short 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13
Primes: 	.space 24

_start:
// your code starts here


// ASSIGN INIT VALUES TO REGISTERS

	LDR A1, N // A1 <- value(N)

// give A2 address of input array
	LDR A2, =Numbers // A2 <- addr(Numbers)

// DOES THIS WORK???
	LDR A3, =Primes // A3 <- addr(Primes)

	MOV A4, #0 // A4 = num_index (num)

	MOV V1, #0 // V1 = pri_index (pri)

	MOV V2, #1 // V2 = prime_flag (prime)

	MOV V3, #0 // done = V3, 0=false and 1=true

OUTER_LOOP:
	// while (!done), V3 = done
	TST V3, #1 // if V3==0, Z=0
	BNE END // branch to end if V==1
	
	// find next index from last prime number
		// num_index = prime_flag -1
	SUB A4, V2, #1 // A4 <- V2 -1
	
	//addr(Numbers[i]) = addr(Numbers) + (num_index * 2)
		// use LSL to shift half-word (A4 = num_index)
	LSL A4, A4, #1  // num_index <- (num_index * 2)
	
		// V4 = Numbers[i]
	LDRH V4, [A2, A4] // V4 <- value @ addr(A2+A4) in Numbers
	
		// use LSR to restore OG num_index value
	LSR A4, A4, #1 // num_index <- (num_index/2) 
	
NEXT_PRIME: // increment to next prime number
	CMP A4, A1 // flags for num_index - N
	BGE IF // AND condition so if first not true, move on
	
		//addr(Numbers[i]) = addr(Numbers) + (num_index * 2)
		// use LSL to shift half-word (A4 = num_index)
	LSL A4, A4, #1  // num_index <- (num_index * 2)
	
		// V4 = Numbers[i]
	LDRH V4, [A2, A4] // V4 <- value @ addr(A2+A4) in Numbers
	
		// use LSR to restore OG num_index value
	LSR A4, A4, #1 // num_index <- (num_index/2) 
	
	// stay in loop only if prev. condition true (checked)
	// AND Numbers[i] = 0
	CMP V4, #0
	BNE IF
	
	// if neither condiion triggers escape
	// num_index++ 
	// I think fine not to store bc don't need at the end
	ADD A4, A4, #1 // A4 <- A4 +1
	B	NEXT_PRIME

// at this point, found next unmarked number
IF: // only progress if num_index < N
	CMP A4, A1 // num_index - N
	BLT ELSE // if NO index maxed, jump to else

	// if YES index maxed, change done flag to 1
	// triggers when num_index >= N
	MOV V3, #1  // V3 <- 1
	B OUTER_LOOP // skip over ELSE condition

ELSE:
	//DOESN"T CHANGE PAST 2, WHAT IS HAPPENING??????
	// copy discovered prime value in Numbers[i] to prime_flag
	//LDRH V2, [V4] // prime_flag <- Numbers[i]
	LSL A4, A4, #1  // num_index <- (num_index * 2)
	
		// V4 = Numbers[i]
	LDRH V4, [A2, A4] // V4 <- value @ addr(A2+A4) in Numbers
	
		// use LSR to restore OG num_index value
	LSR A4, A4, #1 // num_index <- (num_index/2) 
	MOV V2, V4 // V2=prime_flag <- V4=value(Numbers[i])
	
	// copy discovered prime value from prime_flag to primes[pri_index]
	
		// compute index in primes array from integer index
	LSL V1, V1, #1 // pri_index <- (pri_index * 2)
	
		// load Primes(j) into V5
	LDRH V5, [A3, V1] // V5=value(Primes[j]) <- ptr(primes) + (pri_index * 2)
	
		// store value in V2=prime to addr(Primes[j])
	//STRH V2, [V5] // prime -> Primes(j) //V5 IS VALUE NOT ADDR
	STRH V2, [A3,V1] // prime -> addr(Primes[j])
	
		// reset index in primes array back to integer index
	LSR V1, V1, #1 // pri_index <- (pri_index / 2)
	
		// increment integer index for Primes
	ADD V1, V1, #1 // pri_index++

INNER_LOOP:
	// only progress if num_index < N
	CMP A4, A1 
	BGE OUTER_LOOP // if array limit exceeded, restart outer loop
	
	// mark off divisible number
		// load 0 into random register
	MOV V4, #0 // Numbers[i] <- 0 
	
		// calculate offset of addr(Numbers) to get Numbers[i]
	LSL A4, A4, #1  // A4=num_index <- (A4=num_index * 2)
	
		// load V4 into addr(Numbers[i])
	STRH V4, [A2, A4] //V4=Numbers[i] -> addr(Numbers[i])
	
		// restore integer index value for Numbers
	LSR A4, A4, #1 // num_index <- (num_index/2)

	// increment integer index in Numbers array
	ADD A4, A4, V2 //num_index <- num_index + prime_flag
	
	//B OUTER_LOOP // I THINK SHOULD BE BRANCH TO INNER LOOP
	B INNER_LOOP

END: // infinite loop to finish
	B END

	
	



