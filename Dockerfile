FROM ubuntu:20.04
ENV DEBIAN_FRONTEND=noninteractive

# Install basic tools to setup our environment
RUN apt update &&\
    apt install -y file git binutils python3 python3-pip vim gcc gdb curl wget tmux elfutils autoconf locales zstd &&\
    sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen && \
    dpkg-reconfigure --frontend=noninteractive locales && \
    update-locale LANG=en_US.UTF-8

# Install some necessary Python libraries
RUN pip3 install requests chardet pwntools

# Install latest version of gef
RUN wget -O /root/.gdbinit-gef.py -q https://gef.blah.cat/py

# Install static version of pwnint
RUN wget -O /tmp/pwninit https://github.com/io12/pwninit/releases/download/3.2.0/pwninit &&\
    install -Dm 755 /tmp/pwninit /usr/bin/pwninit

WORKDIR /root

# Install glibc-all-in-one
RUN git clone https://github.com/matrix1001/glibc-all-in-one.git
# Configure it, and download all versions of libc
WORKDIR /root/glibc-all-in-one
RUN python3 ./update_list &&\
    sed -i 's|https://mirror.tuna.tsinghua.edu.cn/ubuntu/pool/main/g/glibc|http://archive.ubuntu.com/ubuntu/pool/main/g/glibc/|' download &&\
    while read -r version; do ./download $version ; done < "list"

# Install patchelf
WORKDIR /root
RUN git clone https://github.com/NixOS/patchelf.git
WORKDIR /root/patchelf
RUN ./bootstrap.sh &&\
    ./configure &&\
    make &&\
    make install

ENV LC_ALL=en_US.UTF-8

# Copy in configuration files
COPY configs /root

WORKDIR /root
