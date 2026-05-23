
RISCV            ?= /opt/riscv
RISCV_EXE_PREFIX = $(RISCV)/bin/riscv32-unknown-elf-

TARGET  = prog
SRCDIR  = ../../example_tb/core/custom
HEX     = $(TARGET).hex

SYS_LIB_SRC = $(SRCDIR)/syscalls.c $(SRCDIR)/vectors.S $(SRCDIR)/crt0.S
SRC         = ../keccakf.c ../fips202.c ../rvslh_shake256.c main.c

all: $(HEX)

$(HEX): $(TARGET).elf
	@$(RISCV_EXE_PREFIX)objcopy -O verilog $< $@

$(TARGET).elf: $(SRC)
	@echo CC $^ $(SYS_LIB_SRC)
	@$(RISCV_EXE_PREFIX)gcc -march=rv32imc -o $@ -O2 -w -g -nostdlib \
		-T ../../example_tb/core/custom/link.ld -static \
		$^ $(SYS_LIB_SRC) \
		-I $(RISCV)/riscv32-unknown-elf/include \
		-L $(RISCV)/riscv32-unknown-elf/lib \
		-lc -lm -lgcc

clean:
	rm -f *.elf *.hex
