	movi	1, 0

	movi	2, 10

	bl	1, 2, true
	addi	3, 0, 0
	beq	0, 0, stop

true:	addi	3, 0, 1

stop:	halt
