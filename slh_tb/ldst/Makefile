
RISCV            ?= /opt/riscv
RISCV_EXE_PREFIX = $(RISCV)/bin/riscv32-unknown-elf-

TARGET  = prog
HEX     = $(TARGET).hex

all: $(HEX)

$(HEX): $(TARGET).elf
	$(RISCV_EXE_PREFIX)objcopy -O verilog $< $@

$(TARGET).elf: ldst.S
	$(RISCV_EXE_PREFIX)gcc -march=rv32imc -o $@ -w -g -nostdlib \
		-T ../../example_tb/core/custom/link.ld \
		-static \
		$^

clean:
	rm -f *.elf *.hex
