# This program creates an array of four integers
# and prints out each integer.

# Unlike previous code, this uses a loop. Which
# is a fairly convenient and conventional method
# of traversing lists.

# Compare this to array_ex1.asm

.data
	# int[] myArray = {1, 2, 3, 4}
	myArray: .word 1, 2, 3, 4
	
.text
.globl main
main:
	# Print myArray
	
	# This will be a for loop
	# Initialize our counter
	li t0, 0			# t0 = 0
main_loopStart:				# while(t0 < 4) {
	# Our comparison (negated)	#
	bge t0, 4, main_loopExit	#
	
	# Calculating myArray + (i * b) #
	# Where i is our counter (t0)	#
	# And b is 4, the size of the	#
	# array element.		#
	la t1, myArray			# 	t1 = &myArray (address of myArray)
	mul t2, t0, 4			#	t2 = t0 * 4 (the offset)
	add t2, t2, t1			#	t2 = t2 + t1 (which is now: myArray + (t0 * 4))
	lw t2, (t2)			# 	t2 = myArray[t0]

	move a0, t2			# 	syscall(PRINT_INTEGER, t2)
	li v0, 1			#
	syscall				#
	
	# Increment our counter		#
	add t0, t0, 1			# 	t0 = t0 + 1
	
	# And loop			#
	b main_loopStart		# }
main_loopExit:
	
	li v0, 10			# syscall(EXIT)
	syscall
