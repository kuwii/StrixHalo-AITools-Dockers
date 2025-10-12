# Strix Halo AI Tools Dockers

This is a collection of some Dockerfiles which can build AI tools images for Strix Halo (AI Max 300 series) computers.

## Notice

This is just a personal work for daily use, so it is not optimized enough for heavy works.

## Why

The official ROCm related Docker images seem to have less support for Strix Halo APU (gfx1151). The current supported one in [ROCm/TheRock](https://github.com/ROCm/TheRock/pkgs/container/therock_pytorch_dev_ubuntu_24_04_gfx1151) seems to be based on ROCm 6, although ROCm 7 has been released, which has better performance.

## Runtime environment

Here are the versions of tools used by the images.

- ROCm 7.0.1
- Python 3.12
- PyTorch 2.9.0-rc9

## How to build images

You can run scripts in `build` to build the image needed:

- `./build/rocm7.sh`: Build an image named `kuwii/strixhalo-rocm` that has ROCm installed.
- `./build/pytorch.sh`: Build an image named `kuwii/strixhalo-pytorch` that has ROCm and PyTorch installed.

## How to run images

To use GPU, some extra parameters should be added to the `docker run` command, like this:

```
docker run -it \
  --device=/dev/kfd \
  --device=/dev/dri \
  --group-add video \
  --shm-size 16G \
  --security-opt seccomp=unconfined \
  --security-opt apparmor=unconfined \
  --cap-add=SYS_PTRACE \
  <image name>
```

For basic usage, you can run scripts in `bin`. The name are the same as those in `build`.

## How to validate PyTorch

Within the container, run `python` to open an interactive Python shell, and then test with the following code:

```
import torch

# The output should be 'AMD Radeon Graphics'.
torch.cuda.get_device_name(0)

# No error should be thrown
a = torch.randn(1000, 1000, device=device)
b = torch.randn(1000, 1000, device=device)
c = torch.mm(a, b)
```

## Development environment

Although having "Docker" in the project name, this project is actually developed and tested using Podman. But since Podman is compatible with docker, so this should also work for Docker.
