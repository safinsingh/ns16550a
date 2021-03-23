extern void uart_init(void);
extern void uart_putc(unsigned char);
extern unsigned char uart_getc(void);

void uart_puts(char* str) {
  while (*str) uart_putc(*str++);
  uart_putc('\n');
}

int main() {
  uart_init();
  uart_puts("Hello from bare-metal RISC-V!");
  uart_puts("Type something and it'll show up!");

  for (;;) {
    // ideally, this should be handled by an interrupt.
    // this library configures the UART so that it emits
    // one when it's ready to read from.
    char c = uart_getc();
    if (c == 10 || c == 13) uart_putc('\n');
    else
      uart_putc(c);
  }
}
