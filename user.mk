USER_C   := $(wildcard user/*.c)
USER_AS  := $(wildcard user/*.S)
USER_ELF := build/user.elf
USER_BIN := build/user.bin
USER_HEX := build/user.inc

USER_CFLAGS := -Wall -Wextra -std=c11 -ffreestanding -nostdlib -O0 -ggdb -mcmodel=medany
USER_LDFLAGS := -T user/linker.ld -nostdlib --gc-sections

USER_OBJ_C := $(USER_C:user/%.c=build/user/%.o)
USER_OBJ_AS := $(USER_AS:user/%.S=build/user/%.o)
USER_OBJS := $(USER_OBJ_C) $(USER_OBJ_AS)

USER_DEPS := $(USER_OBJS:.o=.d)

.PHONY: user

user: $(USER_HEX)

$(USER_HEX): $(USER_BIN)
	xxd -i $< > $@
	@echo " HEX	$@"

$(USER_BIN): $(USER_ELF)
	riscv64-unknown-elf-objcopy -O binary $< $@
	@echo " BIN	$@"

$(USER_ELF): $(USER_OBJS) | build/user
	riscv64-unknown-elf-ld $(USER_LDFLAGS) -o $@ $^
	@echo " ELF	$@"

build/user/%.o: user/%.c | build/user
	riscv64-unknown-elf-gcc $(USER_CFLAGS) -c -MMD -MP $< -o $@
	@echo " CC	$<"

build/user/%.o: user/%.S | build/user
	riscv64-unknown-elf-as -o $@ $<
	@echo " AS	$<"

build/user:
	mkdir -p build/user

