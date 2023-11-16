[ORG 0x7C00]  ; Origin, BIOS loads the bootloader to this address

; Entry point of the bootloader
section .text
start:
    cli             ; Disable interrupts
    mov ax, 0x9000  ; Initialize the stack
    mov ss, ax
    mov sp, 0xFFFF
    sti             ; Enable interrupts

    ; Print initial message
    mov si, msg_start
    call print_string

    ; Initialize GDT
    lgdt [gdt_descriptor]

    ; Enable A20 line
    call enable_a20

    ; Switch to Protected Mode
    mov eax, cr0
    or eax, 1
    mov cr0, eax
    jmp CODE_SEG:init_pm  ; Far jump to flush CPU pipeline

; Functions to print messages to screen
print_char:  ; Expects character in 'al'
    mov ah, 0x0E  ; Teletype output function
    int 0x10      ; BIOS interrupt for video services
    ret

print_string:  ; Expects address of string in 'si'
    .next_char:
        lodsb         ; Load next byte from SI into AL
        test al, al   ; Check if it's null terminator
        jz .done      ; If zero, we're done
        call print_char
        jmp .next_char
    .done:
        ret

section .bss
align 4
gdt_start:
    dd 0x0             ; Null descriptor
    dd 0x0

    ; Code segment descriptor
    dw 0xFFFF
    dw 0x0
    db 0x0
    db 10011010b       ; 4K block, 32-bit, Code segment
    db 11001111b
    db 0x0

    ; Data segment descriptor
    dw 0xFFFF
    dw 0x0
    db 0x0
    db 10010010b       ; 4K block, 32-bit, Data segment
    db 11001111b
    db 0x0

gdt_end:

gdt_descriptor:
    dw gdt_end - gdt_start - 1
    dd gdt_start

section .text
enable_a20:
    ; Code to enable A20 line
    ; Add more code into it to specify hardware
    ret

; Data Section for storing strings and data
section .data
msg_start db 'Booting Yrul OS...', 0

[bits 32]
init_pm:
    ; Update segment registers
    mov ax, DATA_SEG
    mov ds, ax
    mov ss, ax
    mov es, ax
    mov fs, ax
    mov gs, ax

    ; Load the kernel from disk
    call load_kernel

    ; Jump to kernel entry point (assuming 0x1000:0x0000)
    jmp 0x1000:0x0000

load_kernel:
    ; Code to load the kernel from disk
    mov bx, 0x1000  ; Load kernel to address 0x1000:0x0000
    mov ah, 0x02    ; BIOS read sector function
    mov al, 1       ; Read 1 sector
    mov ch, 0       ; Cylinder number
    mov cl, 2       ; Start reading from the second sector
    mov dh, 0       ; Head number
    mov dl, [BOOT_DRIVE] ; Boot drive number
    int 0x13        ; BIOS disk interrupt
    ret

BOOT_DRIVE db 0

CODE_SEG equ gdt_start + 8
DATA_SEG equ gdt_start + 16

times 510-($-$$) db 0   ; Fill the rest of sector with 0
dw 0xAA55               ; Boot signature at the end of bootloader
