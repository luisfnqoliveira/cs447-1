# A simple function to compute the greatest
# common denominator of a set of two numbers.

# Exercises:
#   1. What happens when we remove the exit system call?
#      This is why this is important!
#   2. The LCM (lowest-common-multiple) is defined as
#      lcm(a,b) = (a * b) / gcd(a, b)
#
#      Given this, implement the function lcm to call gcd.
#
#      Note: We must strengthen our gcd call by pushing
#        $ra to the stack.

.globl main
main:

	li	a0, 81
	li	a1, 6
	jal	gcd				# v0 = gcd(81, 6);   (result should be 3)
	
	move	a0, v0
	li	v0, 1
	syscall					# syscall(PRINT_INTEGER, v0);
	
	# exit
	li	v0, 10
	syscall					# syscall(EXIT);

# int gcd(a0: int a, a1: int b)
#
gcd:
	move	t0, a0
	move	t1, a1
	
_gcdLoop:
	beq	t0, t1, _gcdLoopExit		# while(a != b) {
	
	ble	t0, t1, _gcdLoopElse		# 	if (a > b) {
	sub	t0, t0, t1			# 		a -= b;
	j	_gcdLoopEndIf
_gcdLoopElse:					# 	} else {
	sub	t1, t1, t0			# 		b -= a;	
_gcdLoopEndIf:					#	}
	j	_gcdLoop			# }
_gcdLoopExit:
	move	v0, t0
	jr	ra				# return a;