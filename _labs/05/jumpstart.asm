
# LED colors
.eqv	LED_OFF		0
.eqv	LED_RED		1
.eqv	LED_ORANGE	2
.eqv	LED_YELLOW	3
.eqv	LED_GREEN	4
.eqv	LED_BLUE	5
.eqv	LED_MAGENTA	6
.eqv	LED_WHITE	7

# Board size
# The board is a 64x64 display
# Here you can make pixels larger by increasing LED_SIZE (e.g. 2x2), but reducing resolution!!
#    Both LED_WIDTH*LED_SIZE and LED_HEIGHT*LED_SIZE which must less than 64. Or bad things may happen
.eqv	LED_SIZE	2
.eqv	LED_WIDTH	32
.eqv	LED_HEIGHT	32

.text
.globl main
main:
	# Clear the display by setting a0 != 0
	li	a0, 1
	jal	displayRedraw				# displayRedraw(1);

	# Add code here
	
	# exit
	li	v0, 10
	syscall						# syscall(EXIT);

# drawHorizontalLine(a0: int x, a1: int y, a2: int size, a3: int colour)
drawHorizontalLine:
	# Function Prologue
	push	ra
	push	s0
	push	s1
	push	s2
	push	s3
	push	s4

	# Preserve all input parameters
	move	s0, a0					# s0 = x;
	move	s1, a1					# s1 = y;
	move	s2, a2					# s2 = size;
	move	s3, a3					# s3 = color;
	
# for(i=0; i<size; i++) {
#   displaySetLED(x+i, y, colour);
# }

	# Go into our for loop
	li	s4, 0					# s4 = 0;
_drawHorizontalLineLoop:
	bge	s4, s2, _drawHorizontalLineLoopExit	# while(s4 < size) {
	
	# Calculate x-coordinate = x+i
	add	a0, s0, s4				# 	a0 = x + s4;
	# Calculate y-coordinate is fixed
	move	a1, s1					# 	a1 = y;
	# Colour set by user
	move	a2, s3					# 	a2 = color;
	
	jal	displaySetLED				# 	displaySetLED(a0: x + s4, a1: y, a2: color);
	
	#Increment i
	add	s4, s4, 1				# 	s4++;
	j	_drawHorizontalLineLoop			# }
_drawHorizontalLineLoopExit:
	# Function Epilogue
	pop	s4
	pop	s3
	pop	s2
	pop	s1
	pop	s0
	pop	ra
	jr	ra					# return;

# Display interaction functions
# ---------------------------------------------------

# Board addresses
.eqv    BOARD_CTRL      0xFFFF0000
.eqv    DISPLAY_KEYS    0xFFFF0004
.eqv    BOARD_ADDRESS   0xFFFF0008

.text
# void displayRedraw()
#   Tells the LED screen to refresh.
#
# arguments: $a0: when non-zero, clear the screen
# trashes:   $t0-$t1
# returns:   none
displayRedraw:
	sw	a0, BOARD_CTRL				# *BOARD_CTRL = a0;
	jr	ra					# return;

# void _setLED(int x, int y, int color)
#   sets the LED at (x,y) to color
#   color: 0=off, 1=red, 2=yellow, 3=green
#
# arguments: $a0 is x, $a1 is y, $a2 is color
# returns:   none
#
displaySetLED:
	# Function Prologue
	push	ra
	push	s0
	push	s1
	push	s2
	
	# I am trying not to use t registers to avoid
	#   the common mistakes students make by mistaking them
	#   as saved.

	#   :)

	# Byte offset into display: y * 16 bytes + (x / 4)
	# y * 64 bytes
	sll	s0, a1, 6				# s0 = y << 6;

	# Take LED size into account
	mul	s0, s0, LED_SIZE			# s0 *= LED_SIZE;
	mul	s1, a0, LED_SIZE			# s1 *= x;

	# Add the requested X to the position
	add	s0, s0, s1				# s0 += s1;

	# base address of LED display
	li	s1, BOARD_ADDRESS			# s1 = BOARD_ADDRESS;
	
	# address of byte with the LED
	add	s0, s1, s0				# s0 = BOARD_ADDRESS + s0;

	# s0 is the memory address of the first pixel
	# s1 is the memory address of the last pixel in a row
	# s2 is the current Y position

	li	s2, 0					# s2 = 0;
_displaySetLEDYLoop:					# do {
	# Get last address
	add	s1, s0, LED_SIZE			# 	s1 = s0 + LED_SIZE;

_displaySetLEDXLoop:					# 	do {
	# Set the pixel at this position
	sb	a2, (s0)				# 		a2 = *s0;

	# Go to next pixel
	add	s0, s0, 1				# 		s0++;

	beq	s0, s1, _displaySetLEDXLoopExit		# 	} while(s0 != s1);
	j	_displaySetLEDXLoop

_displaySetLEDXLoopExit:				#
	# Reset to the beginning of this block
	sub	s0, s0, LED_SIZE			# 	s0 = s0 - LED_SIZE;

	# Move to next row
	add	s0, s0, 64				# 	s0 += 64;

	add	s2, s2, 1				# 	s2++;
	beq	s2, LED_SIZE, _displaySetLEDYLoopExit	# } while (s2 != LED_SIZE);

	j	_displaySetLEDYLoop

_displaySetLEDYLoopExit:
	# Function Epilogue
	pop	s2
	pop	s1
	pop	s0
	pop	ra
	jr	ra					# return;

# int displayGetLED(int x, int y)
#   returns the color value of the LED at position (x,y)
#
#  arguments: $a0 holds x, $a1 holds y
#  returns:   $v0 holds the color value of the LED (0 through 7)
#
displayGetLED:
	# Function Prologue
	push	ra
	push	s0
	push	s1

	# Byte offset into display = y * 16 bytes + (x / 4)
	# y * 64 bytes
	sll	s0, a1, 6				# s0 = y << 6;

	# Take LED size into account
	mul	s0, s0, LED_SIZE			# s0 = s0 * LED_SIZE;
	mul	s1, a0, LED_SIZE			# s1 = x  * LED_SIZE;

	# Add the requested X to the position
	add	s0, s0, s1				# s0 += s1;

	# base address of LED display
	li	s1, BOARD_ADDRESS
	
	# address of byte with the LED
	add	s0, s1, s0				# s0 = BOARD_ADDRESS + s0;
	lbu	v0, (s0)				# v0 = *(unsigned char&)s0;

	# Function Epilogue
	pop	s1
	pop	s2
	pop	ra
	jr	ra					# return v0;