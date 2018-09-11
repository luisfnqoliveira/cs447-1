# This is a loop that reverses a string.

# Explore:
#   1. Update the string and step through the code.
#   2. What happens if we add a null character manually?
#      That is, update the variable to the following:
#      str: .asciiz "Hello\0 World!"
#      Look at why.
#   3. Write a stringReverse() function!
	
.data
	str:	.asciiz	"Hello World!"

.text
.globl main
main:
	# Get the address of the string
	# So both s0 and s1 point to the string
	la	s0, str				# s0 = &str 
	move	s1, s0				# s1 = s0

	# We need to find the end of the string
	# in one of our pointers.
	
	# Let's move s1 to the end of the string
main_findEndLoop:				# loop {
	# Look at the character currently at s1
	lbu	t0, (s1)			#	t0 = *s1;
	
	# Is it the null character?
	beq	t0, '\0', main_findEndLoop_exit	#	if (t0 == '\0') { break; }
	
	# Go to the next character
	addi	s1, s1, 1			#	s1 = s1 + 1;
	
	# Keep looping
	j	main_findEndLoop		# }
	
main_findEndLoop_exit:
	# We are at the null character
	# So, go backward a single position to
	#     point to the last printed character!
	addi	s1, s1, -1			# s1 = s1 - 1

	# Now, we have two string pointers
	# We will use both and proceed down the string
	#   while also going backward, and swap each byte.
	
	# s0: pointing at the first character
	# s1: pointing at the last character
	
main_swapLoop:					# do {
	lbu	t0, (s0)			#	t0  = *s0
	lbu	t1, (s1)			#	t1  = *s1
	sb	t0, (s1)			#	*s0 = t1
	sb	t1, (s0)			#	*s1 = t0
	addi	s0, s0,  1			#	s0  = s0 + 1
	addi	s1, s1, -1			#	s1  = s1 - 1
	blt	s0, s1, main_swapLoop		# } while(s0 < s1);
	
	# Print out our (updated) string!
	li	v0, 4
	la	a0, str
	syscall					# syscall(PRINT_STRING, str)
	
	# exit
	li	v0, 10
	syscall					# syscall(EXIT)