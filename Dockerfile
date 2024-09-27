ARG NVIDIA_DRIVER_VERSION
ARG OS_RELEASE
FROM nvcr.io/nvidia/driver:${NVIDIA_DRIVER_VERSION}-rhel${OS_RELEASE}

ARG KERNEL_VERSION
ARG RPM_BASE_URL
RUN dnf install -y perl-interpreter \
        systemd-udev.x86_64 \
        dracut

RUN dnf install -y --best zlib zlib-devel

#RUN rpm -e --nodeps $( rpm -qa | grep zlib-1.2.11)

#RUN rpm -i ${RPM_BASE_URL}/z/zlib-1.2.11-25.el8.x86_64.rpm  && \
#    rpm -i ${RPM_BASE_URL}/z/zlib-devel-1.2.11-25.el8.x86_64.rpm  && \
RUN    rpm -i --nodeps ${RPM_BASE_URL}/e/elfutils-libelf-devel-0.189-3.el8.x86_64.rpm && \
    rpm -i --nodeps ${RPM_BASE_URL}/k/kernel-devel-${KERNEL_VERSION}.rpm && \
    rpm -i --nodeps ${RPM_BASE_URL}/l/linux-firmware-20230824-119.git0e048b06.el8_9.noarch.rpm && \
    rpm -i --nodeps ${RPM_BASE_URL}/k/kernel-core-${KERNEL_VERSION}.rpm

COPY nvidia-driver /usr/local/bin

ENTRYPOINT ["nvidia-driver", "init"]

