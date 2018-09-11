# This is a demonstration of loops over strings.
#
# We will take a string, and replace the spaces with some
# other character. We will do this "in place" which means
# we will alter the string directly in memory (not copy it
# to a new string)

# Explore:
#   1. Change the character that gets replaced.
#   2. Add the ability to input your own string.
#      (look up the system call you might need in the MARS Help)
#   3. Add the ability to select what character gets replaced.
#   4. Add the stringReplace function so you can reuse this
#      code elsewhere! Consider: What arguments should it take?

.data
	# This is a string.
	# The 'asciiz' means the string ends with a null character
	# The null character is represented as '\0'
	str:	.asciiz		"Hello CS 477!\n"
	
.text
.globl main
main:

	la	a0, str
	li	v0, 4
	syscall				# syscall(PRINT_STRING, str)

	la	t0, str			# t0 = &str[0] (the address of the string in memory)
	
main_loop:				# loop {
	lbu	t1, (t0)		# 	t1 = *t0; (value in memory at the address in t0)
	beq	t1, '\0', main_loopExit #	if (t1 == '\0') { break; }

	# Condition (note the negation!)
	bne	t1, ' ', main_loopSkip	#	if (t1 == ' ') {
	li	t1, '+'			#		t1 = '+';
	sb	t1, (t0)		#		*t0 = t1;	(set current character to a '+')
main_loopSkip:				#	}
	add	t0, t0, 1		# 	t0 = t0 + 1; (increment the address... t0 looks at the next character)
	b	main_loop		# }
main_loopExit:

	# Print the string again
	# (notice, it is the SAME)
	la	a0, str
	li	v0, 4
	syscall				# syscall(PRINT_STRING, str)
		
	li	v0, 10			# syscall(EXIT)
	syscall
