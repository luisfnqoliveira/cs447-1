The not-necessarily-inclusive list of topics for the first midterm:

You can look [here](https://luisfnqoliveira.github.io/CS447/exercises-exam-1/) for a set of exercises (from a different 447 section that has stolen my class website :) that will very much help you prepare for the exam.

## MIPS and Computer Architecture

The definition of ISA, what it doesn't describe in terms of CPU design, and what can be made using it.

CISC vs. RISC architecture.

The basic syntax of MIPS instructions and a reasonable knowledge of how to trace, by hand, small (10-15 lines) of code.

## Number Systems

Converting numbers from binary to hexadecimal, binary to decimal, decimal to binary, etc.

I would never have you convert hexadecimal to decimal for an exam, unless it is a fairly small number. :)

Signed and unsigned numbers including sign-magnitude, 1's complement, and 2's complement.

The size of an immediate as the processor sees it (16 bits), the li pseudo-instruction and how it handles 32-bit immediates.

## Memory Access

The different types of load/store instructions: lb, lbu, lh, lhu, lw, etc, and their behavior.

Loads do what? Stores do what?

What is memory alignment and when does it fail?

Tracing code that accesses memory. (Review examples)

Endianness: Big, little. Looking at code and determining load/store behavior based on endianness. (See Lab 3)

Array manipulation and addressing. (Review examples)

## Functions and the Stack

Tracing code that pushes/pops to the stack. (Review examples)

What is an activation frame? Prologue? Epilogue?

What are possible pitfalls?

The behavior of the jal, jr instructions and our push, pop pseudo-instructions (and what they truly do).

Function calling conventions for MIPS.

## Tracing

The following code has addresses for each instruction to the left of them. The `bgez` instruction is "branch if greater than or equal to zero." Be sure you could read through this code and thoroughly understand what that code is 
going to do, how many times certain instructions will execute, etc.

```python
				.data
				array:	.word	1, -2, 1, 12, -3, 7, 8, 0, -2, 1

				.text
0040 0000			la	$t0, array
0040 0008			li	$t1, 0
0040 000c		loop:	lw	$t2, ($t0)
0040 0010			addi	$t0, $t0, 4
0040 0014			bgez	$t2, cont
0040 0018			j	loop
0040 001c		cont:	addi	$t1, $t1, 1
0040 0020			bne	$t2, 0, loop
0040 0024			li	$v0, 1
0040 0028			move	$a0, $t1
0040 002c			syscall
```
