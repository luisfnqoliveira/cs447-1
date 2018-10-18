.data

# LED colors (don't change)
.eqv	LED_OFF		0
.eqv	LED_RED		1
.eqv	LED_ORANGE	2
.eqv	LED_YELLOW	3
.eqv	LED_GREEN	4
.eqv	LED_BLUE	5
.eqv	LED_MAGENTA	6
.eqv	LED_WHITE	7

# Board size (don't change)
.eqv	LED_SIZE	2
.eqv	LED_WIDTH	32
.eqv	LED_HEIGHT	32

# System Calls
.eqv	SYS_PRINT_INTEGER	1
.eqv	SYS_PRINT_STRING	4
.eqv	SYS_PRINT_CHARACTER	11
.eqv	SYS_SYSTEM_TIME		30

# Key states
leftPressed:		.word	0
rightPressed:		.word	0
upPressed:		.word	0
downPressed:		.word	0
actionPressed:		.word	0

# Frame counting
lastTime:		.word	0
frameCounter:		.word	0

.text
.globl main
main:	
	# Initialize the game state
	jal	initialize				# initialize()
	
	# Run our game!
	jal	gameLoop				# gameLoop()
	
	# The game is over.

	# Exit
	li	v0, 10
	syscall						# syscall(EXIT)

# void initialize()
#   Initializes the game state.
initialize:
	push	ra

	# Set lastTime to a reasonable number
	jal	getSystemTime				#
	sw	v0, lastTime
	
	# Clear the screen
	li	a0, 1
	jal	displayRedraw				# displayRedraw(1);
	
	# Initialize anything else
	
	pop	ra
	jr	ra
				
# void gameLoop()
#   Infinite loop for the game logic
gameLoop:
	push	ra

gameLoopStart:						# loop {
	jal	getSystemTime				#
	move	s0, v0					# 	s0 = getSystemTime();
	
	move	a0, s0
	jal	handleInput				# 	v0 = handleInput(elapsed: a0);
	
	# Determine if a frame passed
	lw	t0, lastTime
	sub	t0, s0, t0
	blt	t0, 50, gameLoopStart			# 	if (s0 - lastTime >= 50) {
	
	# Update last time
	sw	s0, lastTime				# 		lastTime = s0;
	
	# Update our game state (if a frame elapsed)
	move	a0, s0
	jal	update					# 		v0 = update();
	
	# Exit the game when it tells us to
	beq	v0, 1, gameLoopExit			# 		if (v0 == 1) { break; }
	
	# Redraw (a0 = 0; do not clear the screen!)
	li	a0, 0
	jal	displayRedraw				# 		displayRedraw(0);
							#	}
	j	gameLoopStart				# }

gameLoopExit:
	pop	ra
	jr	ra					# return;
			
# int getSystemTime()
#   Returns the number of milliseconds since system booted.
getSystemTime:
	# Now, get the current time
	li	v0, SYS_SYSTEM_TIME
	syscall						# a0 = syscall(GET_SYSTEM_TIME);
	
	move	v0, a0
	
	jr	ra					# return v0;
	
# bool update(elapsed)
#   Updates the game for this frame.
# returns: v0: 1 when the game should end.
update:
	push	ra
	push	s0
	
	# Increment the frame counter
	lw	t0, frameCounter
	add	t0, t0, 1
	sw	t0, frameCounter			# frameCounter++;
	
	li	s0, 0					# s0 = 0;
	
	# Update all of the game state
	jal	updateStuff
	or	s0, s0, v0				# s0 = s0 | updateStuff();
	
_updateExit:
	move	v0, s0
	
	pop	s0
	pop	ra
	jr	ra					# return s0;
	
# void updateStuff()
updateStuff:
	push	ra
	
	li	a0, 8
	li	a1, 16
	li	a2, LED_OFF
	jal	displaySetLED
	
	li	a0, 16
	li	a1, 24
	li	a2, LED_OFF
	jal	displaySetLED
	
	li	a0, 16
	li	a1, 8
	li	a2, LED_OFF
	jal	displaySetLED
	
	li	a0, 24
	li	a1, 16
	li	a2, LED_OFF
	jal	displaySetLED
	
	li	a0, 16
	li	a1, 16
	li	a2, LED_OFF
	jal	displaySetLED
	
_updateStuffLeft:
	lw	t0, leftPressed
	beq	t0, 0, _updateStuffRight
	
	li	a0, 8
	li	a1, 16
	li	a2, LED_RED
	jal	displaySetLED

_updateStuffRight:
	lw	t0, rightPressed
	beq	t0, 0, _updateStuffUp
	
	li	a0, 24
	li	a1, 16
	li	a2, LED_GREEN
	jal	displaySetLED

_updateStuffUp:
	lw	t0, upPressed
	beq	t0, 0, _updateStuffDown
	
	li	a0, 16
	li	a1, 8
	li	a2, LED_YELLOW
	jal	displaySetLED

_updateStuffDown:
	lw	t0, downPressed
	beq	t0, 0, _updateStuffAction
	
	li	a0, 16
	li	a1, 24
	li	a2, LED_MAGENTA
	jal	displaySetLED

_updateStuffAction:
	lw	t0, actionPressed
	beq	t0, 0, _updateStuffExit
	
	li	a0, 16
	li	a1, 16
	li	a2, LED_BLUE
	jal	displaySetLED

_updateStuffExit:

	# Return 0 so the game loop doesn't exit
	li	v0, 0
	
	pop	ra
	jr	ra					# return 0;
	
# LED Input Handling Function
# -----------------------------------------------------
	
# bool handleInput(elapsed)
#   Handles any button input.
# returns: v0: 1 when the game should end.
handleInput:
	push	ra
	
	# Get the key state memory
	li	t0, 0xffff0004
	lw	t1, (t0)
	
	# Check for key states
	and	t2, t1, 0x1
	sw	t2, upPressed
	
	srl	t1, t1, 1
	and	t2, t1, 0x1
	sw	t2, downPressed
	
	srl	t1, t1, 1
	and	t2, t1, 0x1
	sw	t2, leftPressed
	
	srl	t1, t1, 1
	and	t2, t1, 0x1
	sw	t2, rightPressed
	
	srl	t1, t1, 1
	and	t2, t1, 0x1
	sw	t2, actionPressed
	
	move	v0, t2
	
	pop	ra
	jr	ra
	
# LED Display Functions
# -----------------------------------------------------
	
# void displayRedraw()
#   Tells the LED screen to refresh.
#
# arguments: $a0: when non-zero, clear the screen
# trashes:   $t0-$t1
# returns:   none
displayRedraw:
	li	t0, 0xffff0000
	sw	a0, (t0)
	jr	ra

# void displaySetLED(int x, int y, int color)
#   sets the LED at (x,y) to color
#   color: 0=off, 1=red, 2=yellow, 3=green
#
# arguments: $a0 is x, $a1 is y, $a2 is color
# returns:   none
#
displaySetLED:
	push	s0
	push	s1
	push	s2
	
	# I am trying not to use t registers to avoid
	#   the common mistakes students make by mistaking them
	#   as saved.
	
	#   :)

	# Byte offset into display = y * 16 bytes + (x / 4)
	sll	s0, a1, 6      # y * 64 bytes
	
	# Take LED size into account
	mul	s0, s0, LED_SIZE
	mul	s1, a0, LED_SIZE
		
	# Add the requested X to the position
	add	s0, s0, s1
	
	li	s1, 0xffff0008 # base address of LED display
	add	s0, s1, s0    # address of byte with the LED
	
	# s0 is the memory address of the first pixel
	# s1 is the memory address of the last pixel in a row
	# s2 is the current Y position	
	
	li	s2, 0	
_displaySetLEDYLoop:
	# Get last address
	add	s1, s0, LED_SIZE
	
_displaySetLEDXLoop:
	# Set the pixel at this position
	sb	a2, (s0)
	
	# Go to next pixel
	add	s0, s0, 1
	
	beq	s0, s1, _displaySetLEDXLoopExit
	j	_displaySetLEDXLoop
	
_displaySetLEDXLoopExit:
	# Reset to the beginning of this block
	sub	s0, s0, LED_SIZE
	
	# Move to next row
	add	s0, s0, 64
	
	add	s2, s2, 1
	beq	s2, LED_SIZE, _displaySetLEDYLoopExit
	
	j _displaySetLEDYLoop
	
_displaySetLEDYLoopExit:
	
	pop	s2
	pop	s1
	pop	s0
	jr	ra
	
# int displayGetLED(int x, int y)
#   returns the color value of the LED at position (x,y)
#
#  arguments: $a0 holds x, $a1 holds y
#  returns:   $v0 holds the color value of the LED (0 through 7)
#
displayGetLED:
	push	s0
	push	s1

	# Byte offset into display = y * 16 bytes + (x / 4)
	sll	s0, a1, 6      # y * 64 bytes
	
	# Take LED size into account
	mul	s0, s0, LED_SIZE
	mul	s1, a0, LED_SIZE
		
	# Add the requested X to the position
	add	s0, s0, s1
	
	li	s1, 0xffff0008 # base address of LED display
	add	s0, s1, s0    # address of byte with the LED
	lbu	v0, (s0)
	
	pop	s1
	pop	s0
	jr	ra
