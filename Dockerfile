ARG NVIDIA_DRIVER_VERSION
FROM nvcr.io/nvidia/driver:${NVIDIA_DRIVER_VERSION}-rhel8.8

ARG ROCKY_KERNEL_VERSION="4.18.0-477.27.1.el8_8.x86_64"
RUN dnf install -y  perl-interpreter \
        systemd-udev.x86_64 \
        dracut

RUN rpm -i https://dl.rockylinux.org/pub/rocky/8/BaseOS/x86_64/os/Packages/z/zlib-devel-1.2.11-21.el8_7.x86_64.rpm && \
    rpm -i https://dl.rockylinux.org/pub/rocky/8/BaseOS/x86_64/os/Packages/e/elfutils-libelf-devel-0.188-3.el8.x86_64.rpm && \
    rpm -i https://dl.rockylinux.org/pub/rocky/8/BaseOS/x86_64/os/Packages/k/kernel-devel-${ROCKY_KERNEL_VERSION}.rpm && \
    rpm -i https://dl.rockylinux.org/pub/rocky/8/BaseOS/x86_64/os/Packages/l/linux-firmware-20230404-117.git2e92a49f.el8_8.noarch.rpm && \
    rpm -i https://dl.rockylinux.org/pub/rocky/8/BaseOS/x86_64/os/Packages/k/kernel-core-${ROCKY_KERNEL_VERSION}.rpm

COPY nvidia-driver /usr/local/bin

ENTRYPOINT ["nvidia-driver", "init"]

