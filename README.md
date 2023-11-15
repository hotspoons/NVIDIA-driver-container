# NVIDIA GPU Operator driver container for Rocky Linux (and maybe AlmaLinux and Oracle Linux) 8

NVIDIA currently does not support Rocky Linux (or AlmaLinux, or other modern Enterprise Linux clones) in the
[GPU operator for Kubernetes](https://github.com/NVIDIA/gpu-operator), making it a challenge to get the NVIDIA operator stood
up on a cluster that is running on one of these EL clones. This container image aims to helm with that (though this is only 
tested with Rocky). 

A few changes are necessary to make the RHEL 8 container image build on non-RHEL systems:
 - The OS-sniffing logic [here](https://gitlab.com/nvidia/container-images/driver/-/blob/d4c27d475fa698faa444b083ced63562d6b65a55/rhel8/nvidia-driver#L53-55) 
   needs to be updated to include identifiers for `rocky`, `almalinux`, and `ol`
 - The target kernel and supporting dependencies necessary to build the NVIDIA kernel modules must be installed into the container
 and the bootstrapping logic for dependencies [here](https://gitlab.com/nvidia/container-images/driver/-/blob/d4c27d475fa698faa444b083ced63562d6b65a55/rhel8/nvidia-driver#L93-149) 
 needs to be modified
 - The container image must be installed in a container registry with a tag specific to the target OS + release version for the cluster

## Prerequisites

 - A container registry you are already authenticated with that you can publish to
 - A host running the same OS and kernel version as your GPU Kubernetes hosts, to run this build on

## Building

To build on Rocky 8, you will just need to override the `CONTAINER_REGISTRY` env var to point to the registry of
your choice.

On AlmaLinux or Oracle Linux, you will also need to update the `RPM_BASE_URL` env var to point to the BaseOS RPM repo for 
your OS + architecture.

If you wish to build a different driver version than `535.104.12`, override the `NVIDIA_DRIVER_VERSION` env var
as well.

Running `./build.sh` after exporting any env vars should build and publish the container to 
`$CONTAINER_REGISTRY/nvidia/driver:$NVIDIA_DRIVER_VERSION-${OS_NAME}${OS_RELEASE}`

## Deploying

Deploy the operator helm chart with the values for `CONTAINER_REGISTRY` and `NVIDIA_DRIVER_VERSION` - as an example:

```shell
export CONTAINER_REGISTRY=container-registry.siomporas.com
export NVIDIA_DRIVER_VERSION=535.104.12
helm install --generate-name \
     -n gpu-operator --create-namespace \
     nvidia/gpu-operator \
     --set driver.repository=$CONTAINER_REGISTRY/nvidia \
     --set driver.version=$NVIDIA_DRIVER_VERSION
```

NOTE - you will need to rebuild this image; clear container image cache for this image on GPU nodes; and redeploy the GPU 
operator any time you upgrade the kernel on your GPU hosts. This is a solvable problem with additional hacks to `_install_prerequisites`
to basically replicate the Dockerfile initial build step using RPMs from EL clone repositories instead of DNF to install
the kernel.

Inspired by [this](https://github.com/awslife/nvidia-driver) (which no longer works).
