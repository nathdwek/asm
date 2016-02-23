	movi 1, 0x00ff
	
	movi 2, 0x00ff
	
	addi 5, 0, 1 // mask avoiding useless additions
	addi 7, 0, 1 // initiate positive cst for shift left
	sw   1, 0, 0
loop:	lw   1, 0, 0
	and  6, 1, 5 // mask r1 
	lw   1, 0, 1
	beq  6, 0, skip // if masked r1 is 0, skip addition
	add  3, 3, 2, carry //addition
	beq  0, 0, skip
carry:	addi 4, 4, 1 // in case of overflow, carry in r4
skip:	shl  2, 2, 7, ovrflo // shift 1 left r2
	beq  0, 0, next
ovrflo:   	addi 1, 1, 1
	sw   1, 0, 1
	beq  6, 0, next
	add  4, 4, 1
next:	shl  5, 5, 7 // shift 1 left r5
	beq  5, 0, halt
	beq  0, 0, loop
halt:	halt