.global uart_init
.global uart_putc
.global uart_getc

uart_init:
.cfi_startproc
    # load top 20 bits of UART address into a0
    # bottom 12 bits are implicitly 0
    lui     a0, 0x10000
    # set a0 to the UART address + 3
    addi    a0, a0, 3
    # set a2 to the value we want to write
    addi    a1, zero, 3
    # set line control register to 3 in order to
    # set word length to 8 bits
    sb      a1, (a0)
    # set a0 to the UART address + 2
    addi    a0, a0, -1
    # set a1 to the value we want to write (1)
    addi    a1, a1, -2
    # enable FIFO
    sb      a1, (a0)
    # set a0 to the UART address + 1
    addi    a0, a0, -1
    # enable recieve interrupts by setting it to 1
    sb      a1, (a0)
    ret
.cfi_endproc

uart_getc:
.cfi_startproc
    # load UART address into a0
    lui     a0, 0x10000
    # add 5 to represent UART address + 5
    addi    a1, a0, 5
    # read the line status register into a1
    lbu     a1, (a1)
    # AND the value of a1 with one to check the DR bit
    andi    a1, a1, 1
    # jump to _uart_read if a1 is not 0
    bnez    a1, _uart_read
    # assuming a0 is 0, zero out the return register
    mv      a0, zero
    # jump to our return
    j       _uart_get_end

_uart_read:
    # load the character pointer to by the UART address into a0
    lbu     a0, (a0)
    # jump to return
    j       _uart_get_end

_uart_get_end:
    ret
.cfi_endproc

uart_putc:
.cfi_startproc
    # load UART address into a1
    lui     a1, 0x10000
    # store byte in first argument at UART address
    sb      a0, (a1)
    ret
.cfi_endproc

.end
