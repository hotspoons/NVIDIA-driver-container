#!/bin/bash
KERNEL_VERSION="${KERNEL_VERSION:-$(uname -r)}"
NVIDIA_DRIVER_VERSION="${NVIDIA_DRIVER_VERSION:-535.104.12}"
CONTAINER_REGISTRY="${CONTAINER_REGISTRY:-container-registry.siomporas.com}"
OS_NAME="${OS_NAME:-$(cat /etc/os-release | grep ^ID= | awk -F= '{print $2}' | sed -e 's/^"//' -e 's/"$//')}"
OS_RELEASE="${OS_RELEASE:-$(cat /etc/os-release | grep VERSION_ID | awk -F= '{print $2}' | sed -e 's/^"//' -e 's/"$//')}"
RPM_BASE_URL="${RPM_BASE_URL:-https://dl.rockylinux.org/vault/rocky/${OS_RELEASE}/BaseOS/x86_64/os/Packages}"

echo "Building NVIDIA Driver image version $NVIDIA_DRIVER_VERSION for ${OS_NAME}${OS_RELEASE} (kernel version $KERNEL_VERSION)\
 and deploying to registry $CONTAINER_REGISTRY, pulling kernel RPMs from base URL $RPM_BASE_URL"

docker build -t "$CONTAINER_REGISTRY/nvidia/driver:$NVIDIA_DRIVER_VERSION-${OS_NAME}${OS_RELEASE}" \
     --build-arg "NVIDIA_DRIVER_VERSION=$NVIDIA_DRIVER_VERSION" \
     --build-arg "KERNEL_VERSION=$KERNEL_VERSION" \
     --build-arg "RPM_BASE_URL=$RPM_BASE_URL" \
     --build-arg "OS_RELEASE=$OS_RELEASE" \
     -f Dockerfile .
docker push $CONTAINER_REGISTRY/nvidia/driver:$NVIDIA_DRIVER_VERSION-${OS_NAME}${OS_RELEASE}
