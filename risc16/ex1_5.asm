	movi	1,0

	movi	2, 0x8000
	nand 	2, 1, 2
	nand 	2, 2, 2
	beq 	2, 0, zero
	addi 	7, 0, 1
 	beq 	0, 0, stop
zero: 	addi 	7, 0, 0
stop: 	halt
