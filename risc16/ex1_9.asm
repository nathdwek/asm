	movi	1, 0xa060

	movi	2, 0x88dc

			//Reasoning:
			//Goal: e=a*b
			//init: c = 0x0001 running mask
			//loop 16 times: (until mask = 0x0000)
			//d = a masked by c
			//if d!=0{
			//e = e + b
			//}
			//b = b + b
			//shift mask c
			//end loop

	add	5, 0, 2
	add	6, 0, 0

	addi	2, 0, 1	//Running mask c

	add	3, 0, 0
	add	4, 0, 0

loop:	nand	7, 2, 1
	nand	7, 7, 7
	sw	1, 0, 0
	sw	2, 0, 1

	sw	5, 0, 4
	sw	6, 0, 5

	beq	7, 0, inter1

	movi	1, 0x8000	//Keep msb
	nand 	1, 3, 1
	nand 	1, 1, 1
	beq 	1, 0, zero
	addi 	7, 0, 1
 	beq 	0, 0, msb2
zero: 	addi 	7, 0, 0

msb2:	movi	1, 0x8000	//Keep msb
	nand 	1, 5, 1
	nand 	1, 1, 1
	beq 	1, 0, ad15
	addi 	7, 7, 1

ad15:	movi	1, 0x7FFF	//Keep 15LSBs
	nand	3, 1, 3
	nand	3, 3, 3
	nand	5, 1, 5
	nand	5, 5, 5
	add	3, 3, 5		//15bits addition

	movi	1, 0x8000	//Keep msb
	nand 	1, 3, 1
	nand 	1, 1, 1
	beq 	1, 0, adcy1
	addi 	7, 7, 1
	beq	0, 0, adcy1

inter4:	beq	0, 0, loop

adcy1:	movi	1, 0x7FFF	//Keep 15LSBs of 15 bits sum
	nand	3, 3, 1
	nand	3, 3, 3
	movi	1, 0x0001	//Keep LSB of Cy
	nand	2, 1, 7
	nand	2, 2, 2
	beq	2, 0, adcy2
	movi	1, 0x8000	//Add MSB=1
	add	3, 1, 3

adcy2:	movi	1, 0x0002	//Keep 2nd bit of Cy
	nand	2, 1, 7
	nand	2, 2, 2
	beq	2, 0, nocy
	addi	5, 0, 1
	beq	0, 0, high
nocy:	addi	5, 0, 0

high:	movi	1, 0x8000	//Keep msb
	nand 	1, 4, 1
	nand 	1, 1, 1
	beq 	1, 0, zeroh
	addi 	7, 0, 1
 	beq 	0, 0, msb2h
zeroh: 	addi 	7, 0, 0
	beq	0, 0, msb2h

inter1:	beq	0, 0, noad

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
	beq	0, 0, adcy1h

inter3:	beq	0, 0, inter4

adcy1h:	movi	1, 0x7FFF	//Keep 15LSBs of 15 bits sum
	nand	4, 1, 4
	nand	4, 4, 4
	movi	1, 0x0001	//Keep LSB of Cy
	nand	2, 1, 7
	nand	2, 2, 2
	beq	2, 0, storee
	movi	1, 0x8000	//Add MSB=1
	add	4, 1, 4

storee:	sw	3, 0, 2		//Finished e = e + b. Store results
	sw	4, 0, 3

noad:	lw	5, 0, 4
	lw	6, 0, 5

	add	3, 0, 5		//Move b (5,6) to (3,4) in order to compute b = b + b
	add	4, 0, 6
				//start b =  b+ b
	movi	1, 0x8000	//Keep msb
	nand 	1, 3, 1
	nand 	1, 1, 1
	beq 	1, 0, zero_
	addi 	7, 0, 1
 	beq 	0, 0, msb2_
zero_: 	addi 	7, 0, 0

msb2_:	movi	1, 0x8000	//Keep msb
	nand 	1, 5, 1
	nand 	1, 1, 1
	beq 	1, 0, ad15_
	addi 	7, 7, 1

ad15_:	movi	1, 0x7FFF	//Keep 15LSBs
	nand	3, 1, 3
	nand	3, 3, 3
	nand	5, 1, 5
	nand	5, 5, 5
	add	3, 3, 5		//15bits addition

	movi	1, 0x8000	//Keep msb
	nand 	1, 3, 1
	nand 	1, 1, 1
	beq 	1, 0, adcy1_
	addi 	7, 7, 1

adcy1_:	movi	1, 0x7FFF	//Keep 15LSBs of 15 bits sum
	nand	3, 3, 1
	nand	3, 3, 3
	movi	1, 0x0001	//Keep LSB of Cy
	nand	2, 1, 7
	nand	2, 2, 2
	beq	2, 0, adcy2_
	movi	1, 0x8000	//Add MSB=1
	add	3, 1, 3
	beq	0, 0, adcy2_

inter2:	beq	0, 0, inter3

adcy2_:	movi	1, 0x0002	//Keep 2nd bit of Cy
	nand	2, 1, 7
	nand	2, 2, 2
	beq	2, 0, nocy_
	addi	5, 0, 1
	beq	0, 0, high_
nocy_:	addi	5, 0, 0

high_:	movi	1, 0x8000	//Keep msb
	nand 	1, 4, 1
	nand 	1, 1, 1
	beq 	1, 0, zroh_
	addi 	7, 0, 1
 	beq 	0, 0, msb2h_
zroh_: 	addi 	7, 0, 0

msb2h_:	movi	1, 0x8000	//Keep msb
	nand 	1, 6, 1
	nand 	1, 1, 1
	beq 	1, 0, ad15h_
	addi 	7, 7, 1

ad15h_:	movi	1, 0x7FFF	//Keep 15LSBs
	nand	4, 1, 4
	nand	4, 4, 4
	nand	6, 1, 6
	nand	6, 6, 6
	add	4, 4, 6		//15bits addition
	add	4, 4, 5

	movi	1, 0x8000	//Keep msb
	nand 	1, 4, 1
	nand 	1, 1, 1
	beq 	1, 0, adc1h_
	addi 	7, 7, 1

adc1h_:	movi	1, 0x7FFF	//Keep 15LSBs of 15 bits sum
	nand	4, 1, 4
	nand	4, 4, 4
	movi	1, 0x0001	//Keep LSB of Cy
	nand	2, 1, 7
	nand	2, 2, 2
	beq	2, 0, storeb
	movi	1, 0x8000	//Add MSB=1
	add	4, 1, 4

storeb:	add	5, 3, 0
	add	6, 4, 0

	lw	1, 0, 0

	lw	3, 0, 2
	lw	4, 0, 3

	lw	2, 0, 1
	add	2, 2, 2
	beq	2, 0, finish
	beq	0, 0, inter2

finish:	halt
