	movi	1, 0xa060

	movi	2, 0x88dc

//Reasoning:
//Goal: r=a*b
//init: c = 0x0001 running mask
//loop 16 times: (until mask = 0x0000)
//d = a masked by c
//if d!=0{
//r = r + b
//}
//b = b + b
//shift mask c
//end loop

//b [2,5] and r [3,4] (spec) are always in registers!

	addi	6, 0, 1		//Running mask c

loop:	nand	7, 6, 1
	nand	7, 7, 7
	sw	6, 0, 0
	sw	1, 0, 1

	beq	7, 0, shftb1	//nth bit of a = 0 => dont do r = r + b
				//So go to b = b + b
				//Else do it: here is a 32 + 32 bit addition
				// [2,5] + [3,4] = [3,4] and keep [2,5] intact
	lui	1, 512		//Keep MSB
	nand 	6, 2, 1
	nand 	6, 6, 6
	beq 	6, 0, nomsb 	//First MSB is 0 initialize carry to 0
				//and go to second MSB
	addi 	7, 0, 1		//Else initialize carry to 1 and go to second msb
 	beq 	0, 0, msb2
nomsb: 	addi 	7, 0, 0

msb2:	nand 	6, 3, 1		//Keep MSB of 15LSBs of second operand
	nand 	6, 6, 6
	beq 	6, 0, ad15	//Other MSB is 0 go straight to 15 bits addition
	addi 	7, 7, 1

ad15:	movi	1, 0x7FFF	//Keep 15LSBs
	nand	6, 1, 2
	nand	6, 6, 6
	nand	3, 1, 3
	nand	3, 3, 3
	add	3, 3, 6		//15bits addition

	lui	1, 512		//Keep msb of result
	nand 	1, 3, 1
	nand 	1, 1, 1
	beq 	1, 0, adcy1	//MSB of result = 0 go to add LSB of carry to result
	addi 	7, 7, 1		//Else, add 1 to carry
	beq	0, 0, adcy1	//Then add LSB of carry to result

loop2:	beq	0, 0, loop

adcy1:	movi	1, 0x7FFF	//Keep 15LSBs of 15 bits sum
	nand	3, 3, 1
	nand	3, 3, 3
	addi	1, 0, 1		//Keep LSB of Cy
	nand	1, 1, 7
	nand	1, 1, 1
	beq	1, 0, adcy2	//LSB of Cy is 0 go look MSB of carry.
	movi	1, 0x8000	//Else add MSB = 1 to result of 15bits addition
	add	3, 1, 3

adcy2:	addi	1, 0, 2		//Keep 2nd bit of Cy
	nand	1, 1, 7
	nand	1, 1, 1
	beq	1, 0, nocy	//No carry from low weight addition to the
				//result of the high weight addition
				//=> initialize the high weight addition result
				//to 0 and proceed. Else initialize it to 1 and
				//proceed
	addi	6, 0, 1
	beq	0, 0, high	//Go to high bits addition
nocy:	addi	6, 0, 0

high:	lui	1, 512		//Keep msb
	nand 	1, 5, 1		//From here on its the same structure as the
				//The previous addition (same labels suffixed by h)
	nand 	1, 1, 1
	beq 	1, 0, nmsbh
	addi 	7, 0, 1
 	beq 	0, 0, msb2h
nmsbh: 	addi 	7, 0, 0
	beq	0, 0, msb2h

shftb1:	beq	0, 0, shftb

msb2h:	lui	1, 512		//Keep msb
	nand 	1, 4, 1
	nand 	1, 1, 1
	beq 	1, 0, ad15h
	addi 	7, 7, 1

ad15h:	movi	1, 0x7FFF	//Keep 15LSBs
	nand	4, 1, 4
	nand	4, 4, 4
	nand	1, 1, 5
	nand	1, 1, 1
	add	4, 4, 6		//high 15 bits of first operand + carry
	add	4, 4, 1		//+high 15bits of second operand

	lui	1, 512		//Keep msb
	nand 	1, 4, 1
	nand 	1, 1, 1
	beq 	1, 0, adcy1h
	addi 	7, 7, 1
	beq	0, 0, adcy1h

loop1:	beq	0, 0, loop2

adcy1h:	movi	1, 0x7FFF	//Keep 15LSBs of 15 bits sum of the high bits
	nand	4, 1, 4
	nand	4, 4, 4
	addi	1, 0, 1		//Keep LSB of Cy
	nand	6, 1, 7
	nand	6, 6, 6
	beq	6, 0, shftb
	lui	1, 512		//Add MSB=1 to high bits of result
	add	4, 1, 4

shftb:	lui	1, 512
	nand 	1, 2, 1
	nand 	1, 1, 1
	beq 	1, 0, shft0
	addi 	7, 0, 1
 	beq 	0, 0, shift
shft0: 	addi 	7, 0, 0
shift:  add     2, 2, 2
	add     5, 5, 5
	add     5, 5, 7

	lw	1, 0, 1

	lw	6, 0, 0
	add	6, 6, 6
	beq	6, 0, finish
	beq	0, 0, loop1

finish:	halt
