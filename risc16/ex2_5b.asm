//Gauthier Duchene -- Nathan Dwek -- Jason Rosa

//Check if r1 is strictly smaller than r2 (r3 = r1 < r2)
//Using IS1
	movi	1, 0

	movi	2, 10

	bl	1, 2, true
	addi	3, 0, 0
	beq	0, 0, stop

true:	addi	3, 0, 1

stop:	halt
