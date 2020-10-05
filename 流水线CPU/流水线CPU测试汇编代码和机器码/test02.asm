.org 0x0
.set noat
.set noreorder
.set nomacro
.global _start

#test02: 
#expect result:
# $1 0x00000007

_start:
	ori $1, $0, 0x0001 		#
	j target1			
	ori $1, $0, 0x0002
	ori $1, $0, 0x1111
	ori $1, $0, 0x1100
	
target1:
	ori $1, $0, 0x0003 		# 		#
	jal target2
	ori $1, $0, 0x0004
	
	ori $1, $0, 0x0005
	ori $1, $0, 0x0006
	j target3
	
target2:
	or $1, $2, $0 			#
	ori $1, $0, 0x0009 		#
	ori $1, $0, 0x000a 		#
	ori $1, $0, 0x0004
	j target3
	
target3:
	ori $1, $0, 0x0007 		#
	jal target4
	ori $1, $0, 0x0008
	ori $1, $0, 0x1111
	ori $1, $0, 0x1100
	
target4:
	
_loop:
	j _loop
	
	
	
	
	
	
	
	
