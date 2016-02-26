	movi	1, 0x00ff

	movi	2, 0x00ff

//c [r3, r4] = a [r1] * b [r2]
//Same reasoning as 1.9 (c=c+b iff nth bit of a=1, b=b+b, loop 16 times)
//Because we do b=b+b, b is going to take up to 32bits. We choose to place the
//MSBs in r5

	addi	6, 0, 1 		//Running mask

loop:	and	7, 1, 6			 //See if addition is needed
	beq	7, 0, pre		 // if masked r1 is 0, skip addition

	add	3, 3, 2, carry 		//c [r3, r4] = c + b [r2, r5]
	addi	7, 0, 0
	beq	0, 0, adh
carry:	addi	7, 0, 1 		//In case of overflow, remember cy in r6
adh:	add	4, 4, 5
	add	4, 4, 7

pre:	add	6, 6, 6, halt		//Shift the running mask. Overflow
					//means we looped 16 times so stop
					//in that case

	add	2, 2, 2, shft1		//b [r2, r5] = b + b
	addi	7, 0, 0
	beq	0, 0, shftbh
shft1: 	addi	7, 0, 1
shftbh:	add	5, 5, 5
	add	5, 5, 7

	beq	0, 0, loop
halt:	halt
