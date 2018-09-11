# Shows how a do-while loop is constructed.

# Prints a string one character at a time.
# (implement the print string syscall using
#  the print character syscall :)

# Explore:
#   1. What would a while loop look like? (condition at top)
#   2. Update to print every *other* character.
#      What does our loop condition look like, now?
#      We should be concerned about missing the null character!

.data
	# 'asciiz' creates a string where the last character is null
	# The null character can be referred to by '\0'
	str:	.asciiz		"Hello World!"
	
.text
.globl main
main:

	# Load the address of the string
	la		t0, str		# ptr = &str[0] (ptr to string in t0)
	

	# Get first character into a0
	lbu		a0, (t0)	# a0 = *ptr
	
loop:					# do {
	# Use syscall number 11
	# a0 is already set to the current character
	li		v0, 11
	syscall				#	syscall(PRINT_CHARACTER, *ptr)
	
	# go to the next char by incrementing the address
	addi		t0, t0, 1	#	ptr = ptr + 1
	
	# get the next character
	lbu		a0, (t0)	#	a0 = *ptr

	# check for null character
	bne		a0, '\0', loop	# } while(a0 != '\0');
exit:
	li		v0, 10		# syscall(EXIT)
	syscall