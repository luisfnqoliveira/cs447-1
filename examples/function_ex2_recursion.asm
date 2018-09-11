# An implementation (naive, yes) of a factorial function.
# Factorial is represented in notation as n! where
# n! = the product of numbers from 1 to n,
#      where n must be greater than 0 and...
# 0! = 1

# This is implemented recursively, here.
# But we can implement this in a variety of ways,
#  which I will leave as an exercise to the reader. :)

# Explore:
#   1. Play with the input value. What happens if it is very large!
#   2. What happens if we use a negative value.
#      Fix it so this does not happen.

.data

.text
.globl main
main:

	li	a0, 3
	jal	factorial	# factorial(3)

	# Print the return value (the result of factorial)
	move	a0, v0
	li	v0, 1
	syscall			# syscall(PRINT_INTEGER, v0)
	
	# exit the program
	li	v0, 10
	syscall			# syscall(EXIT)

factorial:
	# push "activation frame"
	push	ra
	push	s0
	
	# Handle the base case when a0 is 0!
	li	v0, 1			# v0 = 1;

	# save copy of argument N
	move	s0, a0			# s0 = a0;
	
	# test for fact(0)
	beq	a0, 0, factorial_exit	# if (a0 != 0) {
	
	# call factorial(N-1)
	add	a0, a0, -1		#	a0 = a0 - 1
	jal	factorial		#	v0 = factorial(a0)
	
	# multiply fact(N-1)*N
	mul	v0, s0, v0		#	v0 = s0 * v0
	
factorial_exit:				# }
	# pop activation frame (reverse order!)
	pop	s0
	pop	ra
	jr	ra			# return v0