# Arrays and loops: Shifting arrays

# We will have an array defined by 'myArray'
# We will then have a loop shift the values over 1
# And then we will replace the last item with a new value.

# Exercises:
#   1. Can you alter this to do the opposite?
#      Shift the items to the right and assign
#      myArray[0]
#   2. How about shifting at a *certain point*
#      and assigning to a value within?
#   3. Make the shift array routine the given function:
#
#      int arrayInsert(a0: arrayAddress, a1: arrayLength, a2: index, a3: value)
#        Insert 'value' into the finite array at the given index.
#        The values from index to the end of the array are shifted to 
#        make room for the new value. The value at the end of the array
#        is returned in $v0.
#      returns: $v0 contains the previous last item which was removed from the
#               array.

.data
myArray:	.word	0,5,3,7,3,1,2,9,4,5
myArraySize:	.word	10

.text
.globl main
main:
	
	# We will begin our loop
	
	# It will be a for-loop style
	
	# We need a counter register
	# So, we'll use $t0
	li	t0, 1				# t0 = 1;
_mainLoop:

	# Now we need an invariant expression
	# This tells us when to *not* loop
	# So, in assembly, we write the opposite
	# expression we would in Java, etc.
	lw	t1, myArraySize
	bge	t0, t1, _mainLoopExit		# while(t0 < myArraySize) {
	
	# Determine the address of the current
	# item: A + (i*b)

	# Get the address of our array (A)
	la	t1, myArray			# 	t1 = &myArray[0];
	
	# Get the offset by multiplying the
	# index by the element size (i * b)
	# b is 4 because the array holds words
	mul	t2, t0, 4			# 	t2 = t0 * 4;
	
	# Now, do the A + (i*b) part.
	# Note: t1 is currently A
	#       t2 is currently i * b
	add	t1, t1, t2			#	t1 = t1 + t2;
	
	# Now we need the address of the
	# previous item. Here's a simple
	# trick... that is the address
	# we computed minus...?			#	t2 = t1 - 4;
	sub	t2, t1, 4
	
	# Now t1 is the address of myArray[i]
	# and t2 is the address of myArray[i-1]
	
	lw	t3, (t1)			# 	t3 = *t1; (aka t3 = myArray[i])
	sw	t3, (t2)			#	*t2 = t3; (aka myArray[i-1] = myArray[i])
	
	# Don't forget the increment!!!
	add	t0, t0, 1			#	t0++;
	
	j	_mainLoop			# }  (the end of our loop)
_mainLoopExit:

	# Now, assign myArray[9]
	li	t0, 9
	la	t1, myArray
	mul	t2, t0, 4
	add	t1, t1, t2			# t1 = &myArray[9];
	
	# When this construction makes more
	# sense, we can shorten our pseudo-code
	# comments to what we have there...
	#   just the t1 = &myArray[i], etc
	
	li	t0, 42
	sw	t0, (t1)			# myArray[9] = 42;

_mainExit:
	# exit
	li	v0, 10
	syscall				# syscall(EXIT)