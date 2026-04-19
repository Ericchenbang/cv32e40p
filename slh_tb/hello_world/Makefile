
RISCV            ?= /opt/riscv
RISCV_EXE_PREFIX = $(RISCV)/bin/riscv32-unknown-elf-

TARGET  = prog
TB_CORE = ../../example_tb/core
SRCDIR  = $(TB_CORE)/custom
HEX     = $(TARGET).hex

all: $(HEX)

$(HEX): $(TARGET).elf
	$(RISCV_EXE_PREFIX)objcopy -O verilog $< $@

$(TARGET).elf: $(SRCDIR)/hello_world.c
	$(RISCV_EXE_PREFIX)gcc -march=rv32imc -o $@ -w -Os -g -nostdlib \
		-T $(SRCDIR)/link.ld \
		-static \
		$(SRCDIR)/crt0.S \
		$^ $(TB_CORE)/mem_stall/mem_stall.c $(SRCDIR)/syscalls.c $(SRCDIR)/vectors.S \
		-I $(TB_CORE)/mem_stall \
		-I $(RISCV)/riscv32-unknown-elf/include \
		-L $(RISCV)/riscv32-unknown-elf/lib \
		-lc -lm -lgcc

clean:
	rm -f *.elf *.hex
