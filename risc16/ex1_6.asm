	movi	5, 0

	movi    6, 0

	movi	2, 0x8000
	nand 	2, 5, 2
	nand 	2, 2, 2
	beq 	2, 0, zero
	addi 	7, 0, 1
 	beq 	0, 0, shift
zero: 	addi 	7, 0, 0
shift:  add     5, 5, 5
	add     6, 6, 6
	add     6, 6, 7
	halt
