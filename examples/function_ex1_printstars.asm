# Write functions that help to print a random number of *s
# up to 100 to character output.

.text
.globl main
main:
	# Get a random number out of 100
	li	a0, 100
	jal	rand			# v0 = rand(100)
	
	move	a0, v0
	jal	printStars		# printStars(v0)
	
	# Print a newline
	li	a0, '\n'
	li	v0, 11
	syscall				# syscall(PRINT_CHARACTER, '\n')
	
	# Exit the program
	li	$v0,10			# syscall(EXIT)
	syscall
	
	# If we didn't exit the program... well... we'd have some
	# problems. Wouldn't we!!

# printStars(a0: number of stars to print)
#
# Prints the given number of stars to the output.
#
# Returns: nothing
printStars:
	# Preserve ra and v0
	push	ra
	push	v0
	
	# Initialize our counter
	# (we will clobber a0 later because of syscalls)
	move	t0, a0			# t0 = a0 (our first argument)

	# Perform our for loop (which decrements t0 to zero)
	# (notice our condition is negated!)
printStars_loop:
	beq	t0, 0, printStars_exit	# while (t0 != 0) {  # (negated condition!)
	
	# Print out an asterisk...
	li	a0, '*'
	li	v0, 11
	syscall				#	syscall(PRINT_CHARACTER, '*')
	
	add	t0, t0, -1		# 	t0 = t0 - 1
	j	printStars_loop		# }
	
printStars_exit:
	# Pop preserved values from stack
	pop	v0
	pop	ra
	
	jr	ra			# return;

# rand(a0: The upper bound)
#
# Get a random integer between 0 and the given max.
#
# Returns: integer in v0
rand:
	push	ra
	
	# We need a1 to be the max number (which is in a0)
	# This is the definition of the syscall
	move	a1, a0
	li	a0, 1	
	li	v0, 42			# syscall(RAND_INTEGER, our upper bound argument)
	syscall
	
	move	v0, a0		# set up return value from rand
	pop	ra
	jr	ra