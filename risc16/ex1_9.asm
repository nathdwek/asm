	movi	1, 0xa060

	movi	2, 0x88dc

//Reasoning:
//Goal: r=a*b
//init: c = 0x0001 running mask
//loop 16 times: (until mask = 0x0000)
//d = a masked by c
//if d!=0{
//r = r + b
//}
//b = b + b
//shift mask c
//end loop

//b [r2,r5] and r [r3,r4] (spec) are always in registers!

	addi	6, 0, 1		//Running mask c

loop:	nand	7, 6, 1
	nand	7, 7, 7
	sw	6, 0, 0
	sw	1, 0, 1

	lui	1, 32768	//This is a mask for the MSB that we often use

	beq	7, 0, shftb	//nth bit of a = 0 => dont do r = r + b
				//So go to b = b + b
				//Else do it: here is a 32 + 32 bit addition
				// [r2,r5] + [r3,r4] = [r3,r4] and keep [r2,r5] intact

	nand 	6, 2, 1		//Keep MSB of r2 in r7
	nand 	6, 6, 6
	beq 	6, 0, zero1
	addi 	7, 0, 1
 	beq 	0, 0, msb2
zero1: 	addi 	7, 0, 0

msb2:	nand 	6, 3, 1		//Keep MSB of r3 in r6
	nand 	6, 6, 6
	beq 	6, 0, zero2
	addi 	6, 0, 1
	beq	0, 0, adl
zero2:	addi	6, 0, 0

adl:	add	3, 2, 3		//16 bits addition of the LSBs
	beq	7, 6, same	//If the LSBs registers' MSBs were equal, goto same
	nand	6, 3, 1		//Else, look at the MSB of the 16bits sum
	nand	6, 6, 6
	beq	6, 0, cyl	//If it's 0, there's a Cy from the Low addition
	beq	0, 0, adh	//Else go straight to High addition

same:	beq	0, 6, adh	//If both LSBs register's MSBs were 1

cyl:	addi	4, 4, 1		//There's a Cy from Low to High addition

adh:	add	4, 4, 5		//Else go straight to High addition

shftb:	nand 	1, 2, 1		//A simple shift
	nand 	1, 1, 1		//Keep the MSB of r2 in r1
	beq 	1, 0, shft0	//If it's zero, we shift a zero (so we actually do nothing)
	addi 	7, 0, 1		//Else we shift a one
 	beq 	0, 0, shift
shft0: 	addi 	7, 0, 0
shift:  add     2, 2, 2
	add     5, 5, 5
	add     5, 5, 7
				//Prepare for the next iteration of the loop.
	lw	1, 0, 1		//Load a in r1

	lw	6, 0, 0		//Load the running mask in r6
	add	6, 6, 6		//Shift it
	beq	6, 0, finish	//If it's zero, we iterated 16 times, so we're done
	beq	0, 0, loop	//Else, we be loopin'!

finish:	halt
