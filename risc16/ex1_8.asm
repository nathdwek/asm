	movi 	3, 0x88DC

	movi	4, 0

	movi	5, 0x88DC

	movi 	6, 0

	movi	1, 0x8000	//Keep msb of 3
	nand 	1, 3, 1
	nand 	1, 1, 1
	beq 	1, 0, zero
	addi 	7, 0, 1		//if there is a msb, increment 7
 	beq 	0, 0, msb2
zero: 	addi 	7, 0, 0

msb2:	movi	1, 0x8000	//Keep msb of 5
	nand 	1, 5, 1
	nand 	1, 1, 1
	beq 	1, 0, ad15
	addi 	7, 7, 1		//if there is a msb, increment 7

ad15:	movi	1, 0x7FFF	//Keep 15LSBs of 3 and 5
	nand	3, 1, 3
	nand	3, 3, 3
	nand	5, 1, 5
	nand	5, 5, 5
	add	3, 3, 5		//15bits addition
	
	movi	1, 0x8000	//Keep msb of the sum
	nand 	1, 3, 1
	nand 	1, 1, 1
	beq 	1, 0, adcy1
	addi 	7, 7, 1		//if there is a msb, increment 7

adcy1:	movi	1, 0x7FFF	//Keep 15LSBs of 15 bits sum
	nand	3, 3, 1
	nand	3, 3, 3
	movi	1, 0x0001	//Keep LSB of Cy
	nand	2, 1, 7
	nand	2, 2, 2
	beq	2, 0, adcy2
	movi	1, 0x8000	//Add MSB=1 to the 15bits sum
	add	3, 1, 3

adcy2:	movi	1, 0x0002	//Keep 2nd bit of Cy
	nand	2, 1, 7
	nand	2, 2, 2
	beq	2, 0, nocy
	addi	5, 0, 1		// if there is a cy we increment 5
	beq	0, 0, high	// go to addition of 15 high weight bits
nocy:	addi	5, 0, 0

high:	movi	1, 0x8000	//Keep msb
	nand 	1, 4, 1
	nand 	1, 1, 1
	beq 	1, 0, zeroh
	addi 	7, 0, 1
 	beq 	0, 0, msb2h
zeroh: 	addi 	7, 0, 0

msb2h:	movi	1, 0x8000	//Keep msb
	nand 	1, 6, 1
	nand 	1, 1, 1
	beq 	1, 0, ad15h
	addi 	7, 7, 1

ad15h:	movi	1, 0x7FFF	//Keep 15LSBs
	nand	4, 1, 4
	nand	4, 4, 4
	nand	6, 1, 6
	nand	6, 6, 6
	add	4, 4, 6		//15bits addition
	add	4, 4, 5

	movi	1, 0x8000	//Keep msb
	nand 	1, 4, 1
	nand 	1, 1, 1
	beq 	1, 0, adcy1h
	addi 	7, 7, 1

adcy1h:	movi	1, 0x7FFF	//Keep 15LSBs of 15 bits sum
	nand	4, 1, 4
	nand	4, 4, 4
	movi	1, 0x0001	//Keep LSB of Cy
	nand	2, 1, 7
	nand	2, 2, 2
	beq	2, 0, halt
	movi	1, 0x8000	//Add MSB=1
	add	4, 1, 4

halt:	halt
