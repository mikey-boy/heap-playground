# Heap playground

A docker image setup for heap exploitation. Allows you to test against different versions of glibc. It includes the following tools

- [gef](https://github.com/hugsy/gef) 
- [pwninit](https://github.com/io12/pwninit)
- [glibc-all-in-one](https://github.com/matrix1001/glibc-all-in-one)

## Targetting libc

You can target a specific version of libc for your binary using glibc-all-in-one and pwninit.

```bash
# All run within a container 

# Compile the binary using gcc
~/src: gcc main.c -o main -ggdb

# Use pwninit and glibc-all-in-one to target a different version of glibc
~/src: pwninit --bin main --ld ../glibc-all-in-one/libs/2.27-3ubuntu1_amd64/ld-2.27.so --libc ../glibc-all-in-one/libs/2.27-3ubuntu1_amd64/libc.so.6

# Use GDB (and GEF) to debug the patched binary
~/src: gdb main_patched
```

## Config files

If you want config files (i.e .vimrc) present in the container, be sure to place them in the config directory prior to building the image. You can build the image on your own machine with the following command:

    docker build . -t heap-playground:latest 

## Volume mounting

I find it useful to mount a volume from my host machine inside the Docker container. This way I can work on writing an exploit from my host machine in VSCode, then immediately run that exploit in the container without needing to rebuild the image. This is done using the `-v` flag and in the below example I mount the `src` folder into my container:

    docker run -v `pwd`/src:/root/src --rm -it heap-playground bash
