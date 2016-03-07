#30secs, ugly code to generate test vectors for
#signed 16 bits comparison

from random import randint, choice


for n in range(1,16):
	op1 = randint(2**n, 2**(n+1)-1)
	op2 = randint(2**n, 2**(n+1)-1)
	signs = choice(((-1,-1), (1, -1), (-1, 1)))
	op1 = signs[0]*op1
	op2 = signs[1]*op2
	ans = op1<op2
	if ans:
		ans = 1
	else:
		ans = 0
	if op1 < 0:
		op1 = hex(((abs(op1) ^ 0xffff) + 1) & 0xffff)
	else:
		op1 = hex(op1)
		op1 = op1[:2]+(6-len(op1))*'0'+op1[2:]
	if op2 < 0:
		op2 = hex(((abs(op2) ^ 0xffff) + 1) & 0xffff)
	else:
		op2 = hex(op2 & 0xffff)
		op2 = op2[:2]+(6-len(op2))*'0'+op2[2:]
	print('//'+op1+'\t'+op2+'\t'+str(ans))

