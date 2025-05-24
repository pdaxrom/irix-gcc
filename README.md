Support for Irix with ABI O32 (Irix 5.3 - 6.22) and N32 (Irix 6.2 and Irix 6.5) was removed from gcc, this project brings it back.

### Getting the sources

Use git-lfs to clone the repository:

```git-lfs clone git@github.com:pdaxrom/irix-gcc.git```

### Docker

For simple build use docker:

```bash build-docker.sh```

This will create a docker image with cross-compilers and archives with native ones for deployment on SGI machines for Irix 5.3 - 6.33 ABI O32 and Irix 6.5 ABI N32.

Copy the required archive to the machine and unpack it in the root directory. The path to the o32 compiler is - /opt/irix-gcc-o32/bin, to the n32 - /opt/irix-gcc-n32/bin.

### Ubuntu

To build on Ubuntu install the following dependencies:

```apt install -y build-essential texinfo autoconf2.69 wget mc libtool autopoint```

Run cross compiler build:

```bash build-cross-irix-gcc.sh```

By default, it installing to /opt/irix-gcc-o32-cross. The path can be changed in config.inc (TARGET_INST).

Once the cross compiler is built, you can build the native version:

```bash build-irix-gcc.sh```

It installing to /opt/irix-gcc-o32. Once built, you can transfer it to SGI machine.

To build for ABI N32, use config-n32.inc for Irix 6.2 or config-irix65.inc for Irix 6.5:

```bash build-cross-irix-gcc.sh config-irix65.inc```

and

```bash build-irix-gcc.sh config-irix65.inc```
