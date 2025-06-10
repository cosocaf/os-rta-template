# OS Writing RTA

## Setup

1. Install [QEMU](https://www.qemu.org/download/).
  - For Linux:
    - Arch:
      ```bash
        pacman -S qemu
      ```
    - Debian/Ubuntu:
      ```bash
      apt-get install qemu-system
      ```
    - Fedora:
      ```bash
      dnf install @virtualization
      ```
    - RHEL/CentOS:
      ```bash
      yum install qemu-kvm
      ```
  - For MacOS:
    1. Install [Homebrew](https://brew.sh/).
    2. Run:
      ```bash
      brew install qemu
      ```
  - For Windows (WSL):
    1. Install [WSL](https://docs.microsoft.com/en-us/windows/wsl/install).
    2. Install a Linux distribution (e.g., Ubuntu) from the Microsoft Store.
    3. Open the WSL terminal and follow the Linux instructions above.
2. Install [RISC-V GNU Compiler Toolchain](https://github.com/riscv-collab/riscv-gnu-toolchain).
  - Install dependencies:
    - For Linux:
      - Arch:
        ```bash
        pacman -Syu curl python3 libmpc mpfr gmp base-devel texinfo gperf patchutils bc zlib expat libslirp
        ```
      - Debian/Ubuntu:
        ```bash
        apt-get install autoconf automake autotools-dev curl python3 python3-pip python3-tomli libmpc-dev libmpfr-dev libgmp-dev gawk build-essential bison flex texinfo gperf libtool patchutils bc zlib1g-dev libexpat-dev ninja-build git cmake libglib2.0-dev libslirp-dev
        ```
      - Fedora/RHEL/CentOS:
        ```bash
        yum install autoconf automake python3 libmpc-devel mpfr-devel gmp-devel gawk  bison flex texinfo patchutils gcc gcc-c++ zlib-devel expat-devel libslirp-devel
        ```
    - For MacOS:
      ```bash
      brew install python3 gawk gnu-sed make gmp mpfr libmpc isl zlib expat texinfo flock libslirp
      ```
  - Clone the repository:
    ```bash
    git clone https://github.com/riscv/riscv-gnu-toolchain
    ```
  - Build and Install the Toolchain
    ```bash
    cd riscv-gnu-toolchain
    ./configure --prefix=/opt/riscv --enable-qemu-system
    make
    ```

