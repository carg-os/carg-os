# CargOS
[![License: GPL v3](https://img.shields.io/badge/License-GPLv3-blue.svg)](https://www.gnu.org/licenses/gpl-3.0)

<img src="dark_logo.svg" width="128" height="128"> <img src="logo.svg" width="128" height="128"> <img src="bright_logo.svg" width="128" height="128">

CargOS is an educational Unix-like operating system specifically designed for developers. The system is meticulously crafted to balance comprehensive functionality with simplicity. Targeting the expansive community of developers, CargOS aims to establish a development environment from scratch, supporting its own evolution while maintaining efficiency for deployment on low-cost embedded systems. Engaging with and contributing to the development of CargOS offers substantial benefits for those looking to enrich their development experience!

## Build and Emulate
CargOS utilizes C23, the latest revision of C. Though it's not currently compatible with the RISC-V GNU toolchains provided by most major Linux distributions. Consequently, users have the option to either compile it from the source or use our pre-compiled binaries. Additional details can be found at [carg-os/riscv-gnu-toolchain](https://github.com/carg-os/riscv-gnu-toolchain).

To build CargOS, execute the following commands. Keep in mind that you can specify the path of your compiler by adjusting `cmake/toolchain.cmake` if CargOS wasn't compiled successfully.
```shell
git clone https://github.com/carg-os/carg-os.git
cd carg-os
make
```

You can emulate CargOS using [QEMU](https://www.qemu.org/) (only the subset targeting RV64 is required), which can be done using the following instruction.
```shell
make run
```

## Components
[CargOS](https://github.com/carg-os/carg-os) is a repository containing only a single Makefile that automatically finishes the process of cloning, building, and linking all the system components. It resembles the commonly-applied [monorepo](https://en.wikipedia.org/wiki/Monorepo) paradigm, though it differs in that all components are only stored together when being used locally.

[Karg](https://github.com/carg-os/karg) is the kernel of CargOS. It abstracts the low-level interfaces of devices and implements the core functionalities of the system. Essential features such as process management, I/O management and file system are all provided by it.

[Init](https://github.com/carg-os/init) is the first process that starts running after the initialization of the kernel. It initializes portions of the system that was not set up by the kernel. After the system initialization, a shell providing interactive and intuitive access to the system is started, with several commands available.

[Libc](https://github.com/carg-os/libc) is the C standard library implementation for CargOS. It is designed to adhere rigorously to standard specifications, this ensures the ease of porting applications relying solely on the standard library to CargOS.
