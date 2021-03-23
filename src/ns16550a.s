.global uart_init
.global uart_putc
.global uart_getc

uart_init:
.cfi_startproc
    addi    sp, sp, -16
    sd      ra, 8(sp)
    sd      fp, 0(sp)
    addi    fp, sp, 16
    lui     a0, 0x10000
    addi    a1, a0, 3
    addi    a2, zero, 3
    sb      a2, 0(a1)  # set LCR (addr + 3) to 8 bits
    addi    a1, a1, -1
    addi    a2, a2, -2
    sb      a2, (a1)   # enable FIFO (addr + 2)
    addi    a1, a1, -1
    sb      a2, (a1)   # enable recieve interrupts (addr + 1)
    ld      fp, 0(sp)
    ld      ra, 8(sp)
    addi    sp, sp, 16
    ret
.cfi_endproc

uart_getc:
.cfi_startproc
    addi    sp, sp, -16
    sd      ra, 8(sp)
    sd      fp, 0(sp)
    lui     a0, 0x10000
    addi    a1, a0, 5
    lbu     a1, (a1)
    bnez    a1, _uart_read
    mv      a0, zero
    j       _uart_get_end

_uart_read:
    lbu     a0, (a0)
    j       _uart_get_end

_uart_get_end:
    addi    fp, sp, 16
    ld      fp, 0(sp)
    ld      ra, 8(sp)
    addi    sp, sp, 16
    ret
.cfi_endproc

uart_putc:
.cfi_startproc
    addi    sp, sp, -16
    sd      ra, 8(sp)
    sd      fp, 0(sp)
    addi    fp, sp, 16
    lui     a1, 0x10000
    sb      a0, (a1)
    ld      fp, 0(sp)
    ld      ra, 8(sp)
    addi    sp, sp, 16
    ret
.cfi_endproc

.end
