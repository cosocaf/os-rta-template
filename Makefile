TARGET = kernel.elf
CC     = riscv64-unknown-elf-gcc
AS     = riscv64-unknown-elf-as
LD     = riscv64-unknown-elf-ld

CFLAGS  = -Wall -Wextra -std=c11 -ffreestanding -nostdlib -O2 -mcmodel=medany -Iinclude
LDFLAGS = -T linker.ld -nostdlib --gc-sections

C_SRC  := $(wildcard src/*.c)
AS_SRC := $(wildcard src/*.S)

OBJ_C  := $(C_SRC:src/%.c=build/%.o)
OBJ_AS := $(AS_SRC:src/%.S=build/%.o)
OBJS   := $(OBJ_C) $(OBJ_AS)
DEPS   := $(OBJS:.o=.d)

QEMU       ?= qemu-system-riscv64
QEMU_FLAGS ?= -machine virt -nographic -bios build/opensbi/platform/generic/firmware/fw_jump.bin -smp 1 -m 128M -serial mon:stdio

.PHONY: all clean run

all: opensbi build/$(TARGET)

-include $(DEPS)

opensbi: build
	@echo "Building OpenSBI..."
	cd opensbi && make PLATFORM=generic ARCH=riscv64 CROSS_COMPILE=riscv64-unknown-linux-gnu- O=../build/opensbi $(MAKECMDGOALS)
	@echo "OpenSBI built successfully."

build/$(TARGET): $(OBJS) | build
	$(LD) $(LDFLAGS) -o $@ $^
	@echo " LD	$@"

build/%.o: src/%.c | build
	$(CC) $(CFLAGS) -c -MMD -MP $< -o $@
	@echo " CC	$<"

build/%.o: src/%.S | build
	$(AS) -o $@ $<
	@echo " AS	$<"

build:
	mkdir -p build

clean:
	rm -rf build

run: build/$(TARGET)
	$(QEMU) $(QEMU_FLAGS) -kernel build/$(TARGET)

debug: build/$(TARGET)
	@echo "Debugging session started. Connect with GDB using:"
	@echo "riscv64-unknown-elf-gdb build/$(TARGET)"
	@echo "Then use 'target remote :1234' to connect to QEMU."
	$(QEMU) $(QEMU_FLAGS) -kernel build/$(TARGET) -s -S

