---
layout: lab
solution: true
title: Lab 5
---

## Part A: Functions using the Stack (2 pts)

As we have seen, sharing of registers between functions can be a difficult problem. Thankfully, the stack provides us with a good way to temporarily save registers within a function. The stack is a region in memory where we can push values to in order to save them. Values pushed onto the stack can later be popped off the stack to restore some value to a register. The contents of a register are always pushed to the top (bottom!) of the stack, and popped values are also always taken from the top (bottom!) of the stack.

To keep track of the location of the stack, we use the `sp` register. The `sp` register holds the address in memory corresponding to the top of the stack. The stack grows downward when values are pushed onto it. Thus when we push values onto the stack, the address in the `sp` register is decreased so that it points to the new top of the stack as follows:

```mips
addi sp, sp, -4
sw ra, 0(sp)
```

The above code makes room for 4 bytes on the stack and stores the word contained in s0 on the stack. However, we must also make sure to clean up the stack once we are done with it, such as at the end of a function:

```mips
function:
addi sp, sp -4
sw ra, 0(sp)

# other code here...

lw ra, 0(sp)
addi sp, sp, 4
```

Since this is a common operation, MARS makes pushing the contents of register onto the stack easier with the `push` and `pop` pseudo instructions (not actually part of the MIPS ISA). `push s0` makes room for 4 bytes to be stored on the stack and then stores the value of the given register, `s0`, onto the stack. To retrieve this value, we simply use the `pop s0` instruction, which will load the value at the top of the stack back into `s0`. The following is an example program that uses `push` and `pop`:

```mips
.text
.globl main
main:
	li s0, 0xDEADCAFE
	li s1, 0xBE57C0DE

	jal function

	li v0, 10
	syscall		# terminate program

function:
	push ra
	push s0
	push s1

	li s0, 54
	addi s1, s0, 100

	pop s1
	pop s0
	pop ra

	jr ra
```

When you run the above program, note that the contents of registers `s0` and `s1` are both 0, despite the fact that `function:` modifies both of these registers.

Recall that when writing functions, it is important to follow calling conventions. Make sure that callee functions save the `s0` - `s7` registers as well as the `ra` register. Saving the `ra` register becomes important when functions call other functions so that each functions stores the correct return address to jump back to with `jr ra`.

{:.question}
| **A.1: Fill the entries in the following table. Run the program until it reaches the instruction on the first column, but *before* it is executed! (set a break point in that line). Then fill-in the register s0, s1, and sp values in the remaining columns. The last column (mem[sp]) should be filled in with the value in the memory address stored in register sp. (What is on the top of the stack)**

| Instruction  | s0 | s1 | sp | mem[sp] |
|--------------|----|----|----|---------|
| push ra      | 0xdeadcafe | 0xbe47code | 0x7fffeffc | (undefined) |
| push s0      | 0xdeadcafe | 0xbe47code | 0x7fffeff8 | 0x00400014  |
| push s1      | 0xdeadcafe | 0xbe47code | 0x7fffeff4 | 0xdeadcafe  |
| pop s1       | 0x00000036 | 0x0000009a | 0x7fffeff0 | 0xbe47code  |
| pop s0       | 0x00000036 | 0xbe47code | 0x7fffeff4 | 0xdeadcafe  |
| pop ra       | 0xdeadcafe | 0xbe47code | 0x7fffeff8 | 0x00400014  |
| jr ra        | 0xdeadcafe | 0xbe47code | 0x7fffeffc | (undefined) |

**Consider**: Hmm. Why is the first entry undefined? There may other times when the stack has an unknown value. You should express those as "undefined" as well.

{:.question}
| **A.2: Modify the above program so that it does not use `push` or `pop`, but still saves `ra`, `s0`, and `s1` on the stack by subtracting/adding from `sp` and storing/loading these registers using `sw` and `lw`.**

```python
.text
.globl main
main:
	li s0, 0xDEADCAFE
	li s1, 0xBE57C0DE

	jal function

	li v0, 10
	syscall		# terminate program

function:
	sub sp, sp, 12
	sw ra, 0(sp)
	 sw s0, 4(sp)
	sw s1, 8(sp)

	li s0, 54
	addi s1, s0, 100

	lw s1, 8(sp)
	lw s0, 4(sp)
	lw ra, 0(sp)
	add sp, sp, 12

	jr ra
```

## Part B: Writing a Recursive Function (4 pts)

In this part, you will write a function to compute the sum of the first N natural numbers. For example, `sumToN(5) = 5 + 4 + 3 + 2 + 1 = 15`. To do this, you will use recursion. Note that sumToN(x) can be written in terms of itself: `sumToN(x) = x + sumToN(x - 1)`, with the base case that `sumToN(1) = 1`. Thus the pseudocode for our recursive method is:

```
public int sumToN(int x) {
	if(x == 1) {
		return 1;
	}

	return x + sumToN(x - 1);
}
```

To help you implement this function, use the following code to get started:
```mips
.data
	prompt: .asciiz "Enter an integer: "

.text
.globl main
main:
	li v0, 4
	la a0, prompt
	syscall

  # Get an integer (into v0)
	li v0, 5
	syscall

  # call sumToN(n: v0)
	move a0, v0
	jal sumToN

  # Now print the returned value
	move a0, v0
	li v0, 1
	syscall

  # And exit
	li v0, 10
	syscall

# int sumToN(a0: n)
# returns v0 = 1 + 2 + ... + N
sumToN:
	# Your code goes here
```

**Note:** For this function, do not forget to save `ra` on the stack!!! Otherwise, each recursive call to `sumToN` will overwrite the caller's `ra`, and the caller will not be able to jump back to the correct location.

{:.question}
| **B.1: Complete the sumToN function so that the above program correctly computes the sum of the first N natural numbers.**

```python
.data
	prompt: .asciiz "Enter an integer: "

.text
.globl main
main:
	li v0, 4
	la a0, prompt
	syscall

	# Get an integer (into v0)
	li v0, 5
	syscall

	# call sumToN(n: v0)
	move a0, v0
	jal sumToN

	# Now print the returned value
	move a0, v0
	li v0, 1
	syscall

	# And exit
	li v0, 10
	syscall

# int sumToN(a0: n)
# returns v0 = 1 + 2 + ... + N
sumToN:
	push	ra
	push	s0
  
	# Preserve a0 in s0 (a0 isn't saved, but s0 is)
	move	s0, a0
  
	# Default return value is 0
	li	v0, 0
  
	# Exit if input is less than or equal to 0 (base case)
	ble	s0, 0, _sumToNExit
  
	# Call sumToN(n - 1)
	sub	a0, a0, 1
	jal	sumToN
  
_sumToNExit:
	# Perform the next step to do: n + subToN(n - 1)
	# (or n + 0 in the base case)
	add	v0, s0, v0
  
  	# Return (result is in v0)
	pop	s0
	pop	ra
	jr	ra
```

## Part C: Using the MIPS LED display (4 pts)

Now, we are going to use the LED display that you will use for your first class project. Your objective is to draw a spiral on the display by manipulating the memory of the LED display, to turn on and off some LEDs. But we'll split that into three steps!

The version of Mars in the course website contains the LED keypad support. You can show the display by going to **Tools>Keypad and LED Display Simulator**.

![Menu option to display the Keypad and Display Simulator]({{site.baseurl}}/labs/05/menu_display_simulator.png)

Once the display opens, don't forget to click the **Connect to MIPS** button! Otherwise the display will not work.

![Connect to MIPS!]({{site.baseurl}}/labs/05/connect_to_mips.jpg)

Download [here]({{site.baseurl}}/labs/05/jumpstart.asm) and use the provided functions.

### About the code above

The display simulator is mapped in memory. This simply means that there are some "special" addresses that, when written to and read from, actually access the device.
Access to the display has been done for you, but let's see what that code is doing.

The addresses mapped to the display are shown below:
1. BOARD_CTRL is used to trigger the refresh of the display. Write 0 in this address to refresh the display, or something other than zero to clear the display. Use the `displayRedraw(int clear)` function.
2. DISPLAY_KEYS contain the address that allows us to access the keyboard inputs we saw at class this week. We will not use those in this lab.
3. BOARD_ADDRESS contain the address of LED array. By writing/reading the correct positions of that array, we can turn on/off or check the status of each LED in the display. Use the `displaySetLED(int x, int y, int color)` to set the LED in coordinates (x, y) to the given color. Use the `int displayGetLED(int x, int y)` to get the color the LED in coordinates (x, y) is set to.

**You need to call displayRedraw(0) after calling displaySetLED. Otherwise the display will not update!**

```mips
.eqv    BOARD_CTRL      0xFFFF0000
.eqv    DISPLAY_KEYS    0xFFFF0004
.eqv    BOARD_ADDRESS   0xFFFF0008
```

Possible colors are documented in the top of the file:

```mips
.eqv    LED_OFF         0
.eqv    LED_RED         1
.eqv    LED_ORANGE      2
.eqv    LED_YELLOW      3
.eqv    LED_GREEN       4
.eqv    LED_BLUE        5
.eqv    LED_MAGENTA     6
.eqv    LED_WHITE       7
```

**Note**: As common in many graphical interfaces, (0, 0) is located in the top-left corner.

### Let's go!!

{:.question}
| **C.1: Write a MIPS program that prompts the user for 3 numbers (x, y, and size) and a character representing the color (e.g. ‘w’ for white, ‘g’ for green, ‘y’ for yellow and ‘r’ for red) and draws a line using the ‘drawHorizontalLine’ function. The function ‘drawHorizontalLine(int x, int y, int size, int color)’ draws an horizontal line between the LED at position (x, y) and the LED at position (x + size - 1, y).**

**Remember**: You need to call displayRedraw(0) after calling displaySetLED. Otherwise the display will not update!.

**Try**: See what happens if you draw a line starting in (0, 10) with size larger than LED_WIDTH. E.g. drawHorizontalLine(0, 10, 40, 'r'). Remember that it's really easy to go out of bounds.


{:.question}
| **C.2: Write a function ‘drawVerticalLine(int x, int y, int size, int color)’ that draws a vertical line between the LED at position (x, y) and the LED at position (x,  y + size - 1). Use function 'displaySetLED' to turn on each LED that is part of the line. Your function must save the $ra register and any $s0 register that it uses!**

**Try**: Test by modifying your main program to call ‘drawHorizontalLine’.

{:.question}
| **C.3: Now, write a function ‘drawSpiral(int x, int y, int size, int color)’ that draws a spiral starting at (x, y) where the first branch of the spiral has length 'size'. Use functions ‘drawHorizontalLine’ and ‘drawVerticalLine’ to draw the spiral. Modify your main program to call ‘drawSpiral’.**

**Note**: Feel free to come up with your own implementation of drawing a spiral. But here is a possible implementation for reference:

```c
drawSpiral(int x, int y, int size, int color) {
	while(size > 1) {
		drawHorizontalLine(x, y, size, color);
		x = x + size - 1;
		size--;

		drawVerticalLine(x, y, size, color);
		y = y + size - 1;
		size--;

		x = x - size + 1;
		drawHorizontalLine(x, y, size, color);
		size--;

		y = y - size + 1;
		drawVerticalLine(x, y, size, color);
		size--;
	}
}
```

**Hint**: Print different colors for vertical and horizontal lines while debugging.

**Example**: For the user input:

```
Please enter the x coordinate of the position:
1 <--- this is the input
Please enter the y coordinate of the position:
1 <--- this is the input
Please enter the size:
29 <--- this is the input
Please enter the color (‘w’ -white, ‘g’ -green, ‘y’ -yellow and ‘r’ -red):
w <--- this is the input
```

The result of ‘drawSpiral(1,1,29,'w')’ should be:

![Example of spiral]({{site.baseurl}}/labs/05/example_spiral.jpg)

**Note**: Code is art!

Solution: [lab5c.asm]({{site.baseurl}}/labs/05/lab5c.asm)
