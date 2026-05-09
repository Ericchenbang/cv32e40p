
RISCV            ?= /opt/riscv
RISCV_EXE_PREFIX = $(RISCV)/bin/riscv32-unknown-elf-

TARGET  = prog
SRCDIR  = ../../example_tb/core/custom
HEX     = $(TARGET).hex

all: $(HEX)

$(HEX): $(TARGET).elf
	$(RISCV_EXE_PREFIX)objcopy -O verilog $< $@

$(TARGET).elf: main.c
	$(RISCV_EXE_PREFIX)gcc -march=rv32imc -o $@ -w -g -nostdlib \
		-T ../../example_tb/core/custom/link.ld \
		-static \
		$(SRCDIR)/crt0.S \
		$^ $(SRCDIR)/syscalls.c $(SRCDIR)/vectors.S \
		-I $(RISCV)/riscv32-unknown-elf/include \
		-L $(RISCV)/riscv32-unknown-elf/lib \
		-lc -lm -lgcc

clean:
	rm -f *.elf *.hex
