.data
randomword: .asciiz "Hello"

.text
main:
	la $s0, randomword
	lb $a0, 0($s0)
	addi $v0, $0, 4
	syscall
	addi $s0, $s0, 1
	lb $a0, 0($s0)	
	syscall
	addi $v0, $0, 10
	syscall
