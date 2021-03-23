DEFAULT_GOAL: build
.PHONY: test

build:
	# -ffreestanding: stdlib does not exist
	# --gc-sections: remove garbage sections after linking
	# -nostartfiles/-nostdlib: do not link std or crt0.s
	# -T: specify linkerscript
	riscv64-unknown-elf-gcc -g -ffreestanding -O0 \
		-Wl,--gc-sections -nostartfiles -nostdlib \
		-nodefaultlibs -Wl,-T,test/riscv64-virt.ld \
		-mcmodel=medany test/crt0.s src/ns16550a.s \
		test/main.c

test:
	qemu-system-riscv64 -nographic -machine virt -m 128M \
		-serial mon:stdio -bios none -gdb tcp::1234 -S -kernel a.out

run:
	qemu-system-riscv64 -nographic -machine virt -m 128M \
		-serial mon:stdio -bios none -kernel a.out

dbg:
	riscv64-unknown-elf-gdb a.out
