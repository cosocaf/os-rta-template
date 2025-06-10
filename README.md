# OS Writing RTA 🏁

Welcome to the OS Writing RTA! This is a time attack challenge to implement a tiny RISC-V OS from scratch in 90 minutes.

This repository provides a starter kit to serve as a **launchpad** for your own OS development.

Now, go ahead and build a kernel with your own hands, and enjoy the thrill of creating the magic that makes computers work!

## ⚖️ Regulations

### Timing

- Starts: The moment you write the first character of code into this template.
- Ends: The moment you confirm the successful behavior of your implementation in QEMU, meeting the clear conditions for each category.

### Categories (Clear Conditions)

**Your goal** is to clear one of the following categories.
Each level has a difficulty rating to help you set a realistic goal.

- **LEVEL 1**: "Hello, World!" - ★ (Beginner)
    - The kernel boots and outputs an arbitrary string to the serial console via an SBI call.
- **LEVEL 2**: "First Interrupt" - ★★ (Easy)
    - Meets the conditions for LEVEL 1.
    - A trap handler is set up by configuring the `stvec` register.
    - The kernel enables and correctly handles timer interrupts, for example, by printing a "tick" to the console periodically.
- **LEVEL 3**: "Direct UART Control" - ★★★ (Normal)
    - Meets the conditions for LEVEL 2.
    - The kernel directly controls the UART hardware to output a string to the console without relying on SBI calls.
    - The kernel can handle UART interrupts, such as receiving characters from the console.
- **LEVEL 4**: "Paging Enabled" - ★★★★ (Hard)
    - Meets the conditions for LEVEL 3.
    - An Sv39 page table is set up, and the MMU is enabled by configuring the `satp` register.
- **LEVEL 5**: "First User Process" - ★★★★★ (Very Hard)
    - Meets the conditions for LEVEL 4.
    - The first process runs in User mode.
    - The user process can output to the console by invoking an implemented system call.
- **LEVEL 6**: "Context Switching" - ★★★★★★ (Expert)
    - Meets the conditions for LEVEL 5.
    - A mechanism to save and restore the process context (registers) is implemented.
    - A system call (e.g., `yield`) is implemented for a process to voluntarily give up the CPU to another process.
    - Multiple processes run cooperatively (non-preemptive multitasking).
- **BONUS LEVEL**: "Interactive Monitor" - ★★★★★★+ (**Nightmare!**)
    - Meets the conditions for LEVEL 6.
    - System calls are extended to accept keyboard input from the user.
    - A simple interactive monitor (shell) is implemented that can parse commands (e.g., `echo hello`) and respond.

#### A Note on the 90-Minute Challenge

Clearing all levels within 90 minutes is an extremely high goal.
The primary purpose of this RTA is not to finish everything, but to enjoy the process of seeing how far you can get in a limited time and to learn deeply along the way.

For many participants, reaching LEVEL 2 or 3 will be a fantastic achievement.
Please don't worry too much about the timer; instead, enjoy the thrill of touching the core concepts of OS development at your own pace.

### Rules

1. External Resources are Allowed
    - You are allowed to reference any materials, including websites, books, `man` pages, and your past projects. Use all the knowledge you can gather to learn and implement faster.
2. Use of Debuggers is Allowed
    - The use of debuggers like GDB is allowed and encouraged.
3. Use of AI Assistants is Allowed
    - The use of AI coding assistants like GitHub Copilot is permitted. Make the most of modern development tools.
4. Prohibited Actions
    - The goal of this challenge is to learn by writing code yourself. Referencing other projects and using small snippets is perfectly fine. However, to maximize your learning, please avoid copying and pasting entire functions or major components (e.g., a complete interrupt handler or the entire page table setup) without typing them out yourself.

## 🚀 Getting Started

### Prerequisites

You will need QEMU and the RISC-V GNU Toolchain.
Here is how to install them on various systems.

**Debian/Ubuntu**

```bash
# Update the package database
sudo apt update
# Install QEMU
sudo apt install qemu-system-riscv
# Install RISC-V Toolchain
sudo apt install gcc-riscv64-unknown-elf binutils-riscv64-unknown-elf gdb-multiarch
```

**Arch Linux**

```bash
# Update the package database
sudo pacman -Syu
# Install QEMU
sudo pacman -S qemu-system-riscv # or qemu-arch-extra
# Install RISC-V Toolchain
sudo pacman -S riscv64-elf-toolchain
```

**Fedora**

```bash
# Update the package database
sudo dnf update
# Install QEMU
sudo dnf install qemu-system-riscv
```

For Fedora, pre-built packages for the required cross-compiler are not officially available. Please refer to the "Alternative: Building from Source" section below.

**macOS (using Homebrew)**

```bash
# Update Homebrew
brew update
# Install QEMU
brew install qemu
# Install RISC-V Toolchain
brew tap riscv/riscv
brew install riscv-gnu-toolchain
```

The `riscv-gnu-toolchain` formula may take a significant amount of time to build from source (it can take over an hour depending on your machine).
We strongly recommend installing it well in advance of the RTA.

**Windows (using WSL)**

1. Install [WSL](https://docs.microsoft.com/en-us/windows/wsl/install).
2. Install a Linux distribution (e.g., Ubuntu) from the Microsoft Store.
3. Open the WSL terminal and follow the Linux instructions above.

**Alternative: Building from Source**

If pre-built packages are not available for your operating system, you can build the toolchain from source.

1. Install Dependencies
    You will need to install the necessary build tools and libraries. The required packages vary by distribution.
    - **Debian/Ubuntu**:
        ```bash
        sudo apt install autoconf automake autotools-dev curl python3 python3-pip python3-tomli libmpc-dev libmpfr-dev libgmp-dev gawk build-essential bison flex texinfo gperf libtool patchutils bc zlib1g-dev libexpat-dev ninja-build git cmake libglib2.0-dev libslirp-dev
        ```
    - **Arch Linux**:
        ```bash
        sudo pacman -Syu curl python3 libmpc mpfr gmp base-devel texinfo gperf patchutils bc zlib expat libslirp
        ```
    - **Fedora**:
        ```bash
        sudo yum install autoconf automake python3 libmpc-devel mpfr-devel gmp-devel gawk  bison flex texinfo patchutils gcc gcc-c++ zlib-devel expat-devel libslirp-devel
        ```
2. Clone and Build the RISC-V Toolchain
    ```bash
    git clone --recursive https://github.com/riscv/riscv-gnu-toolchain
    cd riscv-gnu-toolchain
    ./configure --prefix=/opt/riscv --enable-multilib
    sudo make -j$(nproc)
    ```
3. Update your PATH
    Add the following line to your `~/.bashrc` or `~/.zshrc` file:
    ```bash
    export PATH=/opt/riscv/bin:$PATH
    ```
    Then, run `source ~/.bashrc` or `source ~/.zshrc` to apply the changes.

### Verify your installation

After installation, run the following commands to ensure everything is set up correctly:

```bash
qemu-system-riscv64 --version
riscv64-unknown-elf-gcc --version
riscv64-unknown-elf-gdb --version # or gdb-multiarch --version
```

### Setup

#### Clone and run the initial template

```bash
git clone https://github.com/cosocaf/os-rta-template.git os-rta
cd os-rta
make
make run
```

If your environment is set up correctly, you will see a welcome message from OpenSBI.

```text
OpenSBI v1.6
   ____                    _____ ____ _____
  / __ \                  / ____|  _ \_   _|
 | |  | |_ __   ___ _ __ | (___ | |_) || |
 | |  | | '_ \ / _ \ '_ \ \___ \|  _ < | |
 | |__| | |_) |  __/ | | |____) | |_) || |_
  \____/| .__/ \___|_| |_|_____/|____/_____|
        | |
        |_|
...
```

This confirms that the initial empty kernel has booted successfully and then halted.
You will need to manually close QEMU (the standard shortcut is `Ctrl-A` followed by `X`).

## 📦 Provided Environment

This RTA provides the following template environment.

### Basic Commands

- `make`: Builds the kernel.
- `make run`: Runs the kernel in QEMU.
- `make debug`: Starts QEMU and waits for a GDB connection.
- `make clean`: Cleans up the build artifacts.

### Project Structure

- `Makefile`: Defines the build rules for the kernel.
- `linker.ld`: The linker script, which defines the kernel's memory layout.
- `firmware/fw_jump.bin`: Pre-built OpenSBI firmware binary.
- `src/`, `include/`: You will primarily implement your code in these directories.

### To debug your kernel

1. Run `make debug` in one terminal to start QEMU in debug mode.
2. In another terminal, run `riscv64-unknown-elf-gdb build/kernel.elf` to start GDB.
3. In GDB, connect to QEMU with the command:
   ```gdb
   target remote localhost:1234
   ```

## 📚 Resources

- [Xv6, a simple Unix-like teaching operating system](https://pdos.csail.mit.edu/6.828/2022/xv6.html) - A great reference for a complete, well-documented teaching OS.
- [RISC-V Technical Specifications](https://lf-riscv.atlassian.net/wiki/spaces/HOME/pages/16154769/RISC-V+Technical+Specifications) - The official source for privileged instructions, CSRs, and paging.
- [RISC-V Supervisor Binary Interface Specification](https://github.com/riscv-non-isa/riscv-sbi-doc/blob/master/riscv-sbi.adoc) - Essential for making SBI calls for console I/O and other services in the early stages.

## 📄 License

This template is available under the MIT License so that you can freely learn from, modify, and reuse the code.

You are welcome to use this template as a launchpad for your own OS development.
The full legal details are in the LICENSE file, but in short: go ahead, fork it, and start building your own unique OS!

