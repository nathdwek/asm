//Gauthier Duchene -- Nathan Dwek -- Jason Rosa

//Check if r1 is strictly smaller than r2 (r3 = r1 < r2)
//r3 is 1 if true, else 0
//TEST VECTORS
//	op1	op2	expected output
//Basic test
//	0x0000	0x0000	0	Strict equality
//	0x0001	0x0000	0	Basic
//	0x0000	0x0001	1	The other way
//	0xFFFF	0x0000	1	Work with negatives?
//Maybe weird stuff could happen
//	0xFFFF	0x0001	1	Opposites
//	0xEEEE	0x1112	0	Big opposites!
//	0x7FFF	0x8000	0	0x8000 = 0x7FFF+1 but since we're in 2's complement, 0x8000<0x7FFF because we wrapped around. Did we?
//How many bits can you handle?
//	0x0002	0x0001	0
//	0x0051	0x0072	1
//	0x009A	0x0087	0
//	0x01A6	0x017D	0
//	0x0345	0x02AB	0
//	0x0789	0x07F0	1
//	0x0EF8	0x0FFF	1
//	0x1234	0x1ABC	1
//	0x3FBD	0x2890	0
//	0x5555	0x6FED	0
//	0xEFEF	0xEFEE	0
//A journey 15 bits below zero
//	0x0003	0xfffe	0
//	0x0007	0xfff9  	0
//	0xfff8	0x0009	1
//	0x001c	0xffeb	0
//	0x002d	0xffd2	0
//	0xffb7	0x007d	1
//	0x00c2	0xff2f	0
//	0xfeb4	0x01d0	1
//	0x0221	0xfe00	0
//	0x0527	0xfa3e	0
//	0xf150	0xf4c4	1
//	0x1087    0xe264	0
//	0xdcc0	0xd931	0
//	0x8fcd	0xadfa	1
//	0x6b21	0x265c	0

//REASONING
//If r1 and r2 have the same sign: iff r1-r2 is of different sign then r1<r2
//If r1 and r2 have different signs: iff r2 is positive then r1>r2
	movi	1, 0x7FFF
	
	movi	2, 0x8000

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

