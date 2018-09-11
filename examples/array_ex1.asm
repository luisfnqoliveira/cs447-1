# This program creates an array of four integers
# and prints out a single integer.

# Let's print out the 3rd element (the number 3)
# Recall: we want to get the address of this
#         array element: myArray + (i * b)
# i will be 2 (the 1st element is at index 0!)
# b is 4 since this is an array of "word" types
#        which are 4 bytes in size.

# Explore:
#   1. Print myArray[3] instead.
#   2. What happens if we try to print myArray[4],
#      Does it let us? What does it print?

.data
	# int[] myArray = {1, 2, 3, 4}
	myArray: .word 1, 2, 3, 4
	
.text
.globl main
main:
	# Print myArray[2]
	la t0, myArray	# t0 = &myArray (address of myArray)
	li t1, 2	# t1 = 2 (we want the 3rd element)
	mul t1, t1, 4	# t1 = t1 * 4 (multiplied by 4 bytes per item)
	add t2, t0, t1	# t2 = t0 + t1 ... that is: t2 = myArray + (2 * 4)
	
	lw t0, (t2)	# t0 = myArray[2]
	
	move a0, t0	# syscall(PRINT_INTEGER, t0)
	li v0, 1
	syscall
		
	li v0, 10	# syscall(EXIT)
	syscall
