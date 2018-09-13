---
layout: lab
solution: true
title: Lab 1
---

## Part A: Numbers: There and back again

{:.question}
|**A.1**: **Fill in the missing values (indicated by `?` symbols) in the following table:**

| Hex | Binary | Decimal |
|0x7B| ? | ? |
|0x10| ? | ? |
| ? | 11010011 | ? |
| ? | 0110110100010010100 | 223380 |
| ? | ? | 423 |
| ? | ? | 256 |

### Answer

| Hex | Binary | Decimal |
|    0x7B | 01111011            | 123    |
|    0x10 | 00010000            | 16     |
|    0xD3 | 11010011            | 211    |
| 0x36894 | 0110110100010010100 | 223380 |
|   0x1A7 | 110100111           | 423    |
|   0x100 | 100000000           | 256    |

## Part B: MIPS: A Journey to Mars

### Syscalls

{:.question}
| **B.1: Which syscall is being used when `v0` is 1?**

### Answer

The Print Integer system call.

{:.question}
| **B.2: Update your program to output the hexadecimal number 0x4321 in base-10 in place of the "1234"**

### Answer

Here is an example of a correct program:

```python
.globl main
main:
  li      a0, 0x4321
  li      v0, 1
  syscall
```

**Note**: The takeaway here is that hexadecimal can be used as a literal in your programs. The system call prints a number out in base-10, and it doesn't matter what base the number you give it is in. `0x4321` is simply equivalent to its base-10 and base-2 versions.
