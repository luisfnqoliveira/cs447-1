.data
  x: .word 4

.text
.globl main
main:
  lw t0, x
  add t0, t0, 1
  sw t0, x

  li v0, 1
  move a0, t0
  syscall

  li v0, 10
  syscall
