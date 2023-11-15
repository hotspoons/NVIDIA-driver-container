ARG NVIDIA_DRIVER_VERSION
ARG OS_RELEASE
FROM nvcr.io/nvidia/driver:${NVIDIA_DRIVER_VERSION}-rhel${OS_RELEASE}

ARG KERNEL_VERSION
ARG RPM_BASE_URL
RUN dnf install -y perl-interpreter \
        systemd-udev.x86_64 \
        dracut

RUN rpm -i ${RPM_BASE_URL}/z/zlib-devel-1.2.11-21.el8_7.x86_64.rpm && \
    rpm -i ${RPM_BASE_URL}/e/elfutils-libelf-devel-0.188-3.el8.x86_64.rpm && \
    rpm -i ${RPM_BASE_URL}/k/kernel-devel-${KERNEL_VERSION}.rpm && \
    rpm -i ${RPM_BASE_URL}/l/linux-firmware-20230404-117.git2e92a49f.el8_8.noarch.rpm && \
    rpm -i ${RPM_BASE_URL}/k/kernel-core-${KERNEL_VERSION}.rpm

COPY nvidia-driver /usr/local/bin

ENTRYPOINT ["nvidia-driver", "init"]

