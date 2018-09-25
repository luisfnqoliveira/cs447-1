# An "advanced" use of the stack to store local variables
#
# Often, we don't need this level of sophistication for our programs
# in CS 447. You might never place variables on the stack!
#
# And that's OK if you avoid them. We have, generally, enough registers
# and we only deal with smaller data in this course. But when you have
# a lot of variables or bigger data, this is how it works.

.data
	# These are GLOBALS.
	
	# Just as an example, here's a global variable:
	
	# public static int myVariable = 0;
	myVariable:	.word	0

.text
.globl main
main:
	# Call myFunction
	li	a0, 10
	jal	myFunction
	
	move	a0, v0
	li	v0, 1
	syscall						# syscall(PRINT_INTEGER, myFunction(10));

	# Exit so we don't koolaid-man
	li	v0, 10
	syscall						# syscall(EXIT)

# int myFunction(a0: count)
myFunction:
	# Set up our "Activation Frame"
	# This is the "prologue"
	
	# Recall that push is the same as:
	# sub	sp, sp, 4
	# sw	ra, 0(sp)
	push	ra
	
	# Allocate space on the stack for each of
	# our two variables:
	
	# result = 4(sp) = 0
	sub	sp, sp, 4				# int result;
	# counter = 0(sp) = count
	sub	sp, sp, 4				# int counter;
	
	# Often, people will do this all in one go:
	# sub	sp, sp, 8
	# And then they "sw" each variable afterward:
	
	# Set our variables to their initial values
	li	t0, 0
	sw	t0, 4(sp)				# result = 0

	sw	a0, 0(sp)				# counter = count;
	
	# Add count+count-1+...+1
_myFunctionLoop:	
	# Load "counter"
	lw	t0, 0(sp)
	blt	t0, 1, _myFunctionExit			# while(counter >= 1) {
	
	# Load-Modify-Store "result"
	lw	t1, 4(sp)				#
	add	t1, t1, t0				#
	sw	t1, 4(sp)				# 	result += counter;
	
	# Modify-Store "counter"
	sub	t0, t0, 1				#
	sw	t0, 0(sp)				# 	counter--;
	
	# Loop back around
	j	_myFunctionLoop				# }

_myFunctionExit:
	# Return "result"
	lw	v0, 4(sp)
	
	# Dismantle our Activation Frame
	# This is the "epilogue"
	
	# Deallocate our variables!!
	# IMPORTANT!!
	
	# Deallocate "counter"
	add	sp, sp, 4
	
	# Deallocate "result"
	add	sp, sp, 4
	
	# Again, people usually just do this in one line:
	# add	sp, sp, 8
	# Or they use the $fp register to "remember" the
	# old $sp.

	pop	ra
	jr	ra