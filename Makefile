# Paths
BOOT_DIR := boot
KERNEL_DIR := kernel
BUILD_DIR := build
ARCH_DIR := arch/x86

# Compiler and Assembler Configuration
AS := nasm
CC := gcc  # Replace
LD := ld   # Replace
QEMU := qemu-system-i386

# Flags
ASFLAGS := -f bin
CFLAGS := -ffreestanding -O2 -Wall -Wextra
LDFLAGS := -T linker.ld -nostdlib

# Bootloader and Kernel files
BOOT_SRC := $(ARCH_DIR)/$(BOOT_DIR)/bootloader.asm
KERNEL_SRC := $(wildcard $(ARCH_DIR)/$(KERNEL_DIR)/*.c)
KERNEL_OBJ := $(patsubst $(ARCH_DIR)/$(KERNEL_DIR)/%.c, $(BUILD_DIR)/%.o, $(KERNEL_SRC))

# Default rule
all: os-image

$(BUILD_DIR)/bootloader.bin: $(BOOT_SRC)
    $(AS) $(ASFLAGS) $< -o $@

$(BUILD_DIR)/%.o: $(ARCH_DIR)/$(KERNEL_DIR)/%.c
    $(CC) $(CFLAGS) -c $< -o $@

$(BUILD_DIR)/kernel.bin: $(KERNEL_OBJ)
    $(LD) $(LDFLAGS) $^ -o $@

os-image: $(BUILD_DIR)/bootloader.bin $(BUILD_DIR)/kernel.bin
    cat $^ > $(BUILD_DIR)/os-image.img

run: os-image
    $(QEMU) -fda $(BUILD_DIR)/os-image.img

clean:
    rm -rf $(BUILD_DIR)/*

.PHONY: all run clean
