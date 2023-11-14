# YrulOS

## Overview
YrulOS is a custom, minimal operating system developed for educational purposes. It is designed to demonstrate the fundamental aspects of OS development, including bootloader creation, kernel development, memory management, and basic input/output handling.

## Directory Structure
```
YrulOS/
├── arch/          # Architecture-specific code
│   ├── x86/       # x86 architecture code
│   └── arm/       # ARM architecture code (future development)
├── boot/          # Bootloader source code
├── drivers/       # Device driver code
├── include/       # Header files
├── kernel/        # Kernel source code
├── lib/           # Utility and library code
├── build/         # Build artifacts and compiled binaries
├── test/          # Test scripts and unit tests
└── scripts/       # Utility scripts for building and running
```

## Getting Started
### Prerequisites
- NASM (for assembling the bootloader)
- GCC (cross-compiler for compiling the kernel)
- QEMU (for running and testing the OS)

### Building the Project
Run the following command from the root of the project to build YrulOS:
```bash
make
```

### Running the OS
After building, you can run YrulOS using QEMU:
```bash
make run
```

## Contributing
Contributions to YrulOS are welcome. Please read the `CONTRIBUTING.md` file for guidelines on how to contribute.

## License
This project is licensed under the [MIT License](LICENSE.md).

## Acknowledgments
- Special thanks to the OSDev community and other open-source projects that have inspired and provided valuable resources for YrulOS development.