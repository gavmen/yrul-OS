// A simple kernel to test the boot process

// Function to write a character to screen at a given position
void write_char(char c, unsigned char color, int x, int y) {
    volatile char* video_memory = (volatile char*) 0xB8000;
    int offset = (y * 80 + x) * 2; // 80 characters per line, 2 bytes per character
    video_memory[offset] = c;
    video_memory[offset + 1] = color;
}

// Kernel's main function
void kernel_main() {
    // Clear the screen by setting it all to spaces
    for (int y = 0; y < 25; y++) {
        for (int x = 0; x < 80; x++) {
            write_char(' ', 0x07, x, y);
        }
    }

    // Write a simple message to the top-left of the screen
    const char* message = "YrulOS v0.0.1";
    int x = 0, y = 0;
    while (message[x] != '\0') {
        write_char(message[x], 0x07, x, y);
        x++;
    }

    // Hang the kernel to prevent it from doing anything else
    while (1) { }
}
