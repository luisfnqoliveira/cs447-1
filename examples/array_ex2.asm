# This program creates an array of four integers
# and prints out each integer.

# This is fairly exhausting code, isn't it?
# We pull the address of the array using "la"
# and then manipulate the address to point at
# the array item we care about.

# We then do that over and over again.
# We probably want a loop instead. Stay tuned!
# (or look at array_loop_ex1.asm)

# Explore: (Once you learn about functions and loops)
#   1. Try to clean this up by using a loop instead.
#      (see array_loop_ex1.asm for solution)
#   2. Make a function to print an array item by
#      passing the array address and index:
#      printInteger(a0: array, a1: index)

.data
	# int[] myArray = {1, 2, 3, 4}
	myArray: .word 1, 2, 3, 4
	
.text
.globl main
main:
	# Print myArray[0]
	la t0, myArray	# t0 = &myArray (address of myArray)
	lw t1, (t0)	# t1 = myArray[0]
	
	move a0, t1	# syscall(PRINT_INTEGER, t1)
	li v0, 1
	syscall
	
	# Print myArray[1]
	la t0, myArray	# t0 = &myArray (address of myArray)
	add t0, t0, 4	# t0 = t0 + 4 (move to second word, which is a 4 byte integer)
	lw t1, (t0)	# t1 = myArray[1]
	
	move a0, t1	# syscall(PRINT_INTEGER, t1)
	li v0, 1
	syscall
	
	# Print myArray[2]
	la t0, myArray	# t0 = &myArray (address of myArray)
	add t0, t0, 8	# t0 = t0 + 8 (move to third word, which is a 4 byte integer)
	lw t1, (t0)	# t1 = myArray[2]
	
	move a0, t1	# syscall(PRINT_INTEGER, t1)
	li v0, 1
	syscall
	
	# Print myArray[3]
	la t0, myArray	# t0 = &myArray (address of myArray)
	add t0, t0, 12	# t0 = t0 + 12 (move to fourth word, which is a 4 byte integer)
	lw t1, (t0)	# t1 = myArray[3]
	
	move a0, t1	# syscall(PRINT_INTEGER, t1)
	li v0, 1
	syscall
	
	li v0, 10	# syscall(EXIT)
	syscall
