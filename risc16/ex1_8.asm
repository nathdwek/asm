	movi 	3, 0x88DC

	movi	4, 0

	movi	5, 0x88DC

	movi 	6, 0

	lui	1, 512		//Keep msb of 3 in 7
	nand 	2, 3, 1
	nand 	2, 2, 2
	beq 	2, 0, zero1
	addi 	7, 0, 1
 	beq 	0, 0, msb2
zero1: 	addi 	7, 0, 0

msb2:	nand 	2, 5, 1		//Keep msb of 5 in 2
	nand 	2, 2, 2
	beq 	2, 0, zero2
	addi 	2, 0, 1
	beq	0, 0, adl
zero2:	addi	2, 0, 0

adl:	add	3, 3, 5		//16bits addition of the LSBs
	beq	7, 2, same	//LSBs registers had the same MSB
	nand	1, 3, 1		//LSBs registers didn't have the same MSB
	nand	1, 1, 1
	beq	1, 0, cyl
	beq	0, 0, adh

same:	beq	0, 2, adh	//LSBs registers had the same MSB

cyl:	addi	4, 4, 1

adh:	add	4, 4, 6
	halt
