---
layout: lab
solution: true
title: Lab 3
---

## Part A: Negative Complements (3 pts)

{:.question}
| **A.1**: **Complete the following table** |

| **binary** | **sign-magnitude** | **1's complement** | **2's complement** |
| 01010101 | ? | ? | ? |
| 11011011 | ? | ? | ? |
| 10000000 | ? | ? | ? |
| 11111111 | ? | ? | ? |

### Answer

{:.answer}
| **binary** | **sign-magnitude** | **1's complement** | **2's complement** |
| 01010101 | 85 | 85 | 85 |
| 11011011 | -91 | -36 | -37 |
| 10000000 | -0 | -127 | -128 |
| 11111111 | -127 | -0 | -1 |

## Part B: Endianness

Endianness describes how a computer expects a word in memory to be arranged. (See the lecture
notes for a more thorough explanation.) You can order 4 bytes in two different ways... most
significant byte first (where that byte contains the more significant bits 25 through 32) and
least significant byte first (where that byte contains the first 8 bits of the overall 32-bit
number.)

My goodness is endianness silly, but it is a trash fire that is important to understand. Many
bugs occur when two different endiannesses collide. This particularly happens when you are
trying to read a file written with a particular endian in mind and, yet, opened on a machine
with a different opinion about the endian. Sometimes, this means when you port such a program,
it may read files correctly on one machine, but not on another. Very annoying!

Let's explore how endian issues are handled and discovered. We will explore what endian our
MARS simulator uses (MIPS is bi-endian, in general, which means it could be either! Yikes!)

We will do this by defining a 4-byte variable without the `.word` directive. That is, as an
array of 4 bytes (which is technically what a word is!) We will initialize these 4 bytes to
these values: (We also need an empty main function, so it will assemble)

```python
.data
  a: .byte 0x3a, 0x3b, 0x3c, 0x3d

.text
.globl main
main:
```

Copy the code above to the simulator and assemble it. Then, look at the Data Segment (in the
execute tab) for the four bytes. You should see them in the top-left. Now, answer the following
questions:

{:.question}
| **B.1**: **What is the word value of `a` exactly as it is listed in the Data Segment?**

{:.answer}
> 0x3d3c3b3a

{:.question}
| **B.2**: **What is the address of the byte with the value `0x3b`?**

{:.answer}
> 0x10010001

**Hint**:
Hmm, what *is* that address? To help, write a program to load the byte into `t1` at the address
of `a`, which you might put into `t0` (using `la` and `lbu` instructions). If you increment the
address by 1, you will get the next byte. You can then look at the value of `t0` and `t1` for
the answer to question **B.2**. You will not submit the program.

Alright, now let's replace the `.byte` with our conventional `.word` and see what changes. So,
replace the definition of `a` to:

```python
  a: .word 0x3a3b3c3d
```

Now, look at the Data Segment once more and answer the following questions:

{:.question}
| **B.3**: **What is the word value of `a` exactly as it is listed in the Data Segment, now?**

{:.answer}
> 0x3a3b3c3d

{:.note}
> Which is exactly what you wrote!

{:.question}
| **B.4**: **In the hexadecimal number `0x3a3b3c3d`, which byte (report its value) is the most significant?**

{:.answer}
> 0x3a

That is, which byte carries the most weight. That is, contains the most significant bit?

```python
.data
  a: .word 0x3a3b3c3d
```

{:.question}
| **B.5**: **In our updated program, seen above, which byte (report its value) of `a` has the greatest address?**

{:.answer}
> 0x3a

Therefore, consider your answers for questions 4 and 5, and answer:

{:.question}
| **B.6**: **Is the simulator little endian or big endian? How can you tell?**

{:.answer}
> little, since the least significant byte is stored first in memory (has the smaller address)

{:.note}
> If it were big endian, you would expect that the `0x3a` value would be seen as the first byte at the address of `a`. Your small program to simply load a byte at `a` should let you see that (it pulls `0x3d`)

## Part C: Hail, Caesar! (4 pts)

We will create a simple, static caesar cipher. That's a very optimistic description since it is
really just a naive rotation cipher, but let's dream big.

We will take a string (which is given by the human running our program) and then process it, in
place would be easiest, and then output the so-called encrypted string. Our rotation cipher, and
thus our program, works this way:

We take the address of a string and obscure the message by rotating the letters by 13. That is,
we will add 13 to the encoded value of each character. We will loop around the alphabet such that
the letter following `z` is `a`. This will also be true for the upper case letters `A` through `Z`
where the letter following `Z` is then `A`.

Letters are encoded using ASCII, which is a 7-bit encoding which maps numbers from 0 to 127 to
particular characters. Luckily, the alphanumeric (a-z, 0-9) characters are in this table in the
order of the alphabet. We are only dealing with letters, here, and all other characters will not
be affected. Refer to an [ASCII table](http://www.asciitable.com/) for some assistance. The
letter `A` is `0x41` or `65` in decimal while `a` is `0x61` or `97` in decimal.

Here is the boiler-plate to get you started which will read in an input string:

```python
.data
	# Allocate 64 bytes of space for a 63 character string (with a 1 byte null terminator)
	str:	.space 64
	
	# Helpful strings
	prompt:	.asciiz "Enter a string:\n"

.text
.globl main
main:

	# Prompt
	li	v0, 4
	la	a0, prompt
	syscall				# syscall(PRINT_STRING, prompt)

	# Read input string of maximum 63 characters
	li	v0, 8
	la	a0, str
	li	a1, 63
	syscall				# syscall(READ_STRING, str, 63)
	
	# Your code here <---
	
	# End program
	li	v0, 10
	syscall				# syscall(EXIT)
```

**Hint**: In ASCII, the relevant characters are grouped together and in alphabetic order, so to
identify a letter that needs to be shifted, it is just a conditional to check that the current
character falls within that range (see the ASCII table). It may help to write out pseudo-code
first.

**Hint**: Once you identify a character that should be changed, you would simply add 13, as the
cipher suggests. Yet, to ensure that this loops around, the easiest thing to do would be to
*subtract* a certain amount instead in those particular situations (What is the condition that
needs to be checked, here?). Think through this and write out your pseudo-code. Don't be afraid
to use a pencil and paper!

Submit your program as `dww9_lab3c.asm` (with **your own username**). Your program will do the
following:

{:.question}
| **C.1**: **Rotate the A-Z and a-z characters by 13.**

{:.question}
| **C.2**: **Loop around such the z becomes m, and so on.**

{:.question}
| **C.3**: **Do not shift any non-alphabetic characters, such as spaces and punctuation.**

Here is some example output:

```python
Type in a string:
hello world

Encrypted:
uryyb jbeyq
```

**Test it yourself**: Here's a string. Copy and paste it in to see what it says. Remember, it should
decrypt the string via the same process as encrypt it. (It's Symmetric! Boogie woogie woogie)

**If you wish**: Share your string with a neighbor to validate your program. They should be
able to tell what it says, if everything is correct. Your neighbor *could* be [rot13.com](https://rot13.com),
but remember that the boiler-plate program only accepts up to 63 characters.

### Answer

```python
.data
	# Allocate 64 bytes of space for a 63 character string (with a 1 byte null terminator)
	str:	.space 64
	
	# Helpful strings
	prompt:	.asciiz "Enter a string:\n"
	response: .asciiz "Encrypted:\n"

.text
.globl main
main:

	# Prompt
	li	v0, 4
	la	a0, prompt
	syscall					# syscall(PRINT_STRING, prompt)

	# Read input string of maximum 63 characters
	li	v0, 8
	la	a0, str
	li	a1, 63
	syscall					# syscall(READ_STRING, str, 63)
	
	# Student code here ################
	
	la	t0, str				# t0 = &str
main_loop:					# loop {
	lbu	t1, (t0)			# 	t1 = *t0
	beq	t1, '\0', main_loopExit		# 	if (t1 == '\0') { break; }
	
	# Check for values obviously not A-z
	blt	t1, 'A', main_loopContinue	#	if (t1 < 'A') { continue; }
	bgt	t1, 'z', main_loopContinue	#	if (t1 > 'z') { continue; }

	# Check for values A-Z
	bgt	t1, 'Z', main_loopNotUpper	#	if (t1 <= 'Z') {
	
	# We have a character within A-Z
	bgt	t1, 'M', main_loopUpperSubtract	#		if (t1 < 'M') {
	add	t1, t1, 13			#			t1 = t1 + 13;
	b	main_loopContinue		#		}
main_loopUpperSubtract:				#		else {
	sub	t1, t1, 13			#			t1 = t1 - 13;
	b	main_loopContinue		#		}
	
main_loopNotUpper:				#	
	# Check for values a-z
	blt	t1, 'a', main_loopContinue	#	else if (t1 >= 'a') {
	
	# We have a character with a-z
	bgt	t1, 'm', main_loopLowerSubtract	#		if (t1 < 'm') {
	add	t1, t1, 13			#			t1 = t1 + 13;
	b	main_loopContinue		#		}
main_loopLowerSubtract:				#		else {
	sub	t1, t1, 13			#			t1 = t1 - 13;
	b	main_loopContinue		#		}
						#	}
main_loopContinue:
	# Write back byte
	sb	t1, (t0)			#	*t0 = t1;
	
	# Go to next byte
	add	t0, t0, 1			# 	t0 = t0 + 1;
	b	main_loop			# }

main_loopExit:

	# Print resulting string
	
	# Print a blank line
	li	v0, 11
	li	a0, '\n'
	syscall					# syscall(PRINT_CHARACTER, '\n')

	# Print a nice response string
	li	v0, 4
	la	a0, response
	syscall					# syscall(PRINT_STRING, response)
	
	# Print our ~~transformed~~ string :)
	la	a0, str
	syscall					# syscall(PRINT_STRING, str)
	
	# End student code #################
	
	# End program
	li	v0, 10
	syscall					# syscall(EXIT)
```
