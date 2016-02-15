	movi 	1, 0

	movi 	2, 0

	movi	5, 0x8000	//Keep msb
	nand 	5, 1, 5
	nand 	5, 5, 5
	beq 	5, 0, zero
	addi 	7, 0, 1
 	beq 	0, 0, msb2
zero: 	addi 	7, 0, 0

msb2:	movi	5, 0x8000	//Keep msb
	nand 	5, 2, 5
	nand 	5, 5, 5
	beq 	5, 0, add15
	addi 	7, 7, 1

add15:	movi	5, 0x7FFF	//Keep 15LSBs
	nand	1, 5, 1
	nand	1, 1, 1
	nand	2, 5, 2
	nand	2, 2, 2
	add	6, 1, 2		//15bits addition
	
	movi	5, 0x8000	//Keep msb
	nand 	5, 6, 5
	nand 	5, 5, 5
	beq 	5, 0, addCy1
	addi 	7, 7, 1

addCy1:	movi	5, 0x7FFF	//Keep 15LSBs of 15 bits sum
	nand	3, 6, 5
	nand	3, 3, 3
	movi	5, 0x0001	//Keep LSB of Cy
	nand	6, 5, 7
	nand	6, 6, 6
	beq	6, 0, addCy2
	movi	5, 0x8000	//Add MSB=1
	add	3, 5, 3

addCy2:	movi	5, 0x0002	//Keep 2nd bit of Cy
	nand	6, 5, 7
	nand	6, 6, 6
	beq	6, 0, noCy
	addi	4, 0, 1
	beq	0, 0, halt
noCy:	addi	4, 0, 0
halt:	halt
