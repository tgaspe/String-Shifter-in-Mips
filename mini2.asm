# 	Program to shift a string by a specific number of characters
# 	Theodoro Gasperin Terra Camargo 260842764
#
#	Registers:
#	$t0 => Used to get bytes from string
#	$t1 => Used to get bytes from back of string
#	$t2 => Used to count the number of characters in the string passed by the user
#	$s1 => Pointer to begging of the array
#	$s2 => Pointer to possition of last char in the array
#	$s3 => Used to save offset ammount by which second pointer knows the position of last char
#	$s4 => Saves second user input tell by how many char string must be shifted (x)
#	$s5 => Remainder of the division: (n_char/x)
#	$s6 => Quotient of the divisino: (n_char/x)


	.data
buffer:	.space 32	# My array of 32 bytes (30 char + \n + \0) 
msg:	.asciiz "Input a string 30 characters or less: "
msg1:	.asciiz "Input an integer greater than 0: "
msg2:	.asciiz "Shifted string = ["
msg3:	.asciiz "]"
	.text
main:
	#printing first message
	la $a0, msg
	li $v0, 4
	syscall
	
	#getting user input
	li $v0, 8		#read string -> take user input
	la $a0, buffer		#saving address of my array into $a0
	li $a1, 32		# Giving limit of char(bytes) to be read in the array
	syscall
	
	lb $t0, 0($a0)		# loading firs byte for input validation
	beq $t0, 10, Exit	# if user does not input anything program exits
	
	#printing second message
	la $a0, msg1
	li $v0, 4
	syscall
	
	#Getting second user input
	li $v0, 5
	syscall
	move $s4, $v0		# x = user input
	
	ble $s4, $0, Exit	# Exit if x less equal than 0
	
	
	la $s1, buffer		# Getting my base address of my array
	li $t2, 0		# Setting number of characters to 0 i.e n_char = 0

size_loop:
	lb $t0, 0($s1)		# load first char from array -> char = array[i]
	addiu $t2, $t2, 1	# increase n_char by 1 -> n_char ++
	addiu $s1, $s1, 1	# Increase counter by 1: i ++ (increment pointer by 8 bits)
	bne $t0, $0 size_loop	# while char != \0 keep looping
	# End loop
	
	la $s1, buffer		# Getting my base address of my array to loop again (setting pointer back to beggining of array)
	la $s2, buffer		# Creating second pointer to my array
	
	
	subi $t2, $t2, 2	# n_char = n_char - 2 bcs last char is \n and \0
	addu $s2, $s2, $t2	# Second pointer pointing to \n
	sb $0, 0($s2)		# Removing "\n" from array
	la $s2, buffer		# reseting second pointer to begging of array
	
	
	
	# if x > n_char: 	i.e shift bigger than string 
	divu $s4, $t2		# x / char_n 
	mfhi $s5 		# Remainder of division stored in s5
	mflo $s6		# Quotient of division stored in s6
	beq $s6, $0, quotient_zero
	# Else
	move $s4, $s5		# n_char gets remainder
	
quotient_zero:			
	subu $t2, $t2, $s4	# n_char - X so that it points 
	addu $s2, $s2, $t2	# Setting second pointer to end of string	
	
	# While loop
	move $s0, $0		# i = 0
loop:	
	
	lb $t0, 0($s1)		# Load Byte: temp = array[i]
	lb $t1, 0($s2)		# Load Byte: temp1 = array[len(s)-i]
	
	sb $t0, 0($s2)		# store byte in temp to array[len(s) - i]
	sb $t1, 0($s1)		# store byte in temp1 to array[i]
	
	addi $s1, $s1, 1	# Increase first pointer by 8 bits (i.e. i ++)
	addi $s2, $s2, 1	# Increase second pointer by 8 bits (i.e. len(s)-2 - X + i)
	
	
	addi $s0, $s0, 1	# i++
	bne $s0, $s4, loop	# while i != x keep looping
	# END loop
	
	#printing first message
	la $a0, msg2
	li $v0, 4
	syscall
	
	#printing result
	la $a0, buffer
	li $v0, 4
	syscall
	
	#printing first message
	la $a0, msg3
	li $v0, 4
	syscall
	
Exit:	# exit program
	li $v0, 10
	syscall


