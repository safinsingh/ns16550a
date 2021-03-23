.global uart_init
.global uart_putc
.global uart_getc

.equ UART_ADDRESS,              0x10000000
.equ LINE_STATUS_REGISTER,      0x5
.equ LINE_CONTROL_REGISTER,     0x3
.equ FIFO_CONTROL_REGISTER,     0x2
.equ INTERRUPT_ENABLE_REGISTER, 0x1
.equ LINE_STATUS_DATA_READY,    0x1

uart_init:
.cfi_startproc
    li  a0, UART_ADDRESS

    # 0x3 -> 8 bit word length
    li  a1, 0x3
    sb  a1, LINE_CONTROL_REGISTER(a0)

    # 0x1 -> enable FIFOs
    li  a1, 0x1
    sb  a1, LINE_CONTROL_REGISTER(a0)

    # 0x1 -> enable reciever interrupts
    sb  a1, INTERRUPT_ENABLE_REGISTER(a0)

    ret
.cfi_endproc

uart_getc:
.cfi_startproc
    li      a0, UART_ADDRESS

    lbu     a1, LINE_STATUS_REGISTER(a1)
    andi    a1, a1, LINE_STATUS_DATA_READY

    # jump to _uart_read if UART is ready to read from
    bnez    a1, _uart_read

    # otherwise, return 0
    mv      a0, zero
    j       _uart_get_end

_uart_read:
    # load character at UART address into a0
    lbu     a0, (a0)
    j       _uart_get_end

_uart_get_end:
    ret
.cfi_endproc

uart_putc:
.cfi_startproc
    li  a0, UART_ADDRESS

    # store character at UART address in return register
    sb  a0, (a1)
    ret
.cfi_endproc

.end
