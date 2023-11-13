BITS 16
ORG 0x7C00

start:
    mov [BOOT_DRIVE], dl    ; Save the boot drive number

    ; Set up the stack
    cli                     ; Disable interrupts
    mov ax, 0x9000          ; Set up Stack Segment to 0x9000
    mov ss, ax
    mov sp, 0xFFFF
    sti                     ; Enable interrupts

    ; Set up the data segment
    mov ax, 0x0000
    mov ds, ax

    ; Load the kernel from disk
    call load_kernel

    ; Jump to the kernel
    jmp 0x1000:0x0000

load_kernel:
    mov bx, 0x1000          ; Load kernel to address 0x1000:0x0000
    mov ah, 0x02            ; BIOS read sector function
    mov al, 1               ; Read 1 sector
    mov ch, 0               ; Cylinder number
    mov cl, 2               ; Start reading from the second sector
    mov dh, 0               ; Head number
    mov dl, [BOOT_DRIVE]    ; Boot drive number
    int 0x13                ; BIOS disk interrupt
    ret

BOOT_DRIVE db 0

times 510-($-$$) db 0      ; Pad the bootloader to 510 bytes
dw 0xAA55                  ; Boot sector magic number
