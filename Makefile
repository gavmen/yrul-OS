# Define Tools
AS := nasm
CC := i686-elf-gcc  
LD := i686-elf-ld   
QEMU := qemu-system-i386

# Directories
BOOT_DIR := arch/x86/boot
KERNEL_DIR := arch/x86/kernel
BUILD_DIR := build

# Files
KERNEL_SRC := $(wildcard $(KERNEL_DIR)/*.c)
KERNEL_OBJ := $(patsubst $(KERNEL_DIR)/%.c, $(BUILD_DIR)/%.o, $(KERNEL_SRC))
KERNEL_BIN := $(BUILD_DIR)/kernel.bin
OS_IMAGE := $(BUILD_DIR)/os-image.img

# Flags
ASFLAGS := -f bin
CFLAGS := -ffreestanding -O2 -Wall -Wextra
LDFLAGS := -T $(KERNEL_DIR)/linker.ld -nostdlib -L/usr/local/i686elfgcc/lib/gcc/i686-elf/11.2.0 -lgcc

# Default build target
all: bootloader $(OS_IMAGE)

bootloader:
	$(MAKE) -C $(BOOT_DIR)
	mv $(BOOT_DIR)/stage1.bin $(BUILD_DIR)/
	mv $(BOOT_DIR)/stage2.bin $(BUILD_DIR)/

# Rule to ensure the build directory exists
$(BUILD_DIR):
	mkdir -p $(BUILD_DIR)

# Compile the kernel
$(BUILD_DIR)/%.o: $(KERNEL_DIR)/%.c
	$(CC) $(CFLAGS) -c $< -o $@

# Link the kernel
$(KERNEL_BIN): $(KERNEL_OBJ)
	$(LD) $(LDFLAGS) $^ -o $@

# Create the OS image
$(OS_IMAGE): bootloader
	dd if=/dev/zero of=$(OS_IMAGE) bs=512 count=2880
	dd if=$(BUILD_DIR)/stage1.bin of=$(OS_IMAGE) conv=notrunc
	dd if=$(BUILD_DIR)/stage2.bin of=$(OS_IMAGE) seek=1 conv=notrunc
	dd if=$(KERNEL_BIN) of=$(OS_IMAGE) seek=2 conv=notrunc

# Run the OS in QEMU
run: $(OS_IMAGE)
	$(QEMU) -drive format=raw,file=$<

# Clean build files
clean:
	rm -rf $(BUILD_DIR)/*
	$(MAKE) -C $(BOOT_DIR) clean

.PHONY: all run clean bootloader
