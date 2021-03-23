# ns16550a

RISC-V NS16550A UART driver

## Example

Example usage:

```c
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
    char c = uart_getc();
    uart_putc(c);
  }

  return 0;
}
```
