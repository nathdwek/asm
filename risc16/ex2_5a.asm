//Check if 1 is strictly smaller than 2
	movi	1, 0x8000
	
	movi	2, 0x7FFF

	beq	1, 2, false
	lui	7, 32768	//Compare MSBs of r1 and r2
	nand	6, 1, 7
	nand 	6, 6, 6
	nand	5, 2, 7
	nand	5, 5, 5
	beq	5, 6, same

	beq	6, 0, false
	beq	0, 0, true

same:	nand	2, 2, 2
	addi	2, 2, 1
	add	1, 2, 1
	nand	1, 7, 1
	nand	1, 1, 1
	beq	1, 6, false
	beq	0, 0, true

true:	addi	3, 0, 1
	beq	0, 0, stop

false:	addi	3, 0, 0
stop:	halt

