.data
	array:	.word 0:5
	sum:	.word	0
.text

#test03: 
#expect result:
# $1 0xfffffffe
# $2 0x00000004
# $3 0x0000000c
# $4 0x01040000
# $5 0x00000004
# $6 0x00000000
# $7 0x00000001
# $8 0xfffffffe
# $9 0x0000001c
# $10 0x0000001f


main:
	ori $2, $0, 0x0002
	ori $3, $0, 0x0003
	lui $4, 0x0104
	
	add $1, $2, $3		#
	addu $1, $4, $1	#
	j target1
	sub $1, $3, $2
	
target1:
	addiu $1, $4, 0x0100	#
	sub $1, $4, $2		#
	ori $5, $0, 0x0002	# 令$5的值与$2的值相等
	beq $2, $5, target2
	ori $2, $0, 0x0004
	
target2:
	subu $1, $1, $2	#
	slt $6, $2, $3		# $6=1
	slt $7, $3, $2		# $7=0
	slti $6, $6, 0x0000	# $6=0
	slti $7, $7, 0x0001	# $7=1
	bne $6, $7, target3
	ori $2, $0, 0x0005
	ori $2, $0, 0x0006

target3:
	lui $2, 0		#
	addi $2, $2, 4		#
	
	lui $3, 0		#
	addi $3, $3, 4		#
	sw $2, array($3)	#
	lw $5, array($3)	#
	
	sb $2, array($3)
	lb $5, array($3)
	
	addi $3, $3, 4		#
	sh $2, array($3)
	lh $5, array($3)
	
	addi $3, $3, 4		#
	bgtz $7, target4	
	ori $2, $0, 0x00083	
	

target4:
	clz $9, $3
	ori $8, $0, -2
	clo $10, $8
	





	