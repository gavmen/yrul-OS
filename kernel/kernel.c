void print_string(const char* string) {
    volatile char* video_memory = (volatile char*)0xB8000;
    while (*string != 0) {
        *video_memory++ = *string++;
        *video_memory++ = 0x07;
    }
}

void main() {
    print_string("Hello, World!");
    while (1) {

    }
}
