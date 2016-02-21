	movi 	3, 0x88DC

	movi	4, 0

	movi	5, 0x88DC

	movi 	6, 0

	lui	1, 512		//Keep msb of r3 in r7
	nand 	2, 3, 1
	nand 	2, 2, 2
	beq 	2, 0, zero1
	addi 	7, 0, 1
 	beq 	0, 0, msb2
zero1: 	addi 	7, 0, 0

msb2:	nand 	2, 5, 1		//Keep msb of r5 in r2
	nand 	2, 2, 2
	beq 	2, 0, zero2
	addi 	2, 0, 1
	beq	0, 0, adl
zero2:	addi	2, 0, 0

adl:	add	3, 3, 5		//16bits addition of the LSBs
	beq	7, 2, same	//If the LSBs register have the same MSB
	nand	1, 3, 1		//Else, look at the MSB of the 16bits sum
	nand	1, 1, 1
	beq	1, 0, cyl	//If it's 0, there's a Cy from the Low addition
	beq	0, 0, adh	//Else go straight to High addition

same:	beq	0, 2, adh	//If both LSBs register's MSBs were 1

cyl:	addi	4, 4, 1		//There's a Cy from Low to High addition

adh:	add	4, 4, 6		//Else go straight to High addition
	halt
