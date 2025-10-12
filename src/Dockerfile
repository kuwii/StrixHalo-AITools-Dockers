# =====================
#  ROCm 7 Docker Image
# =====================
FROM ubuntu:noble as rocm
# Initialize base environment.
RUN apt-get update && apt-get upgrade -y && apt-get autoremove
# Download and convert the package signing key.
RUN apt-get install -y wget gpg
RUN wget https://repo.radeon.com/rocm/rocm.gpg.key -O - | gpg --dearmor | tee /etc/apt/keyrings/rocm.gpg > /dev/null
# Register packages
RUN printf "deb [arch=amd64 signed-by=/etc/apt/keyrings/rocm.gpg] https://repo.radeon.com/rocm/apt/7.0.1 noble main\ndeb [arch=amd64 signed-by=/etc/apt/keyrings/rocm.gpg] https://repo.radeon.com/graphics/7.0.1/ubuntu noble main\n" \
    > /etc/apt/sources.list.d/rocm.list
RUN printf "Package: *\nPin: release o=repo.radeon.com\nPin-Priority: 600" \
    > /etc/apt/preferences.d/rocm-pin-600
RUN apt-get update
# Install ROCm
RUN apt-get install -y rocm
# Set environment variables
ENV PATH="/opt/rocm/bin:$PATH" LD_LIBRARY_PATH="/opt/rocm/lib"


# ========================
#  PyTorch 7 Docker Image
# ========================
FROM rocm as pytorch
# Install dependencies.
RUN apt-get install -y python-is-python3 python3 python3-venv git
# fetch source code
RUN git clone --branch v2.9.0-rc9 --single-branch --depth 1 https://github.com/pytorch/pytorch.git /usr/local/src/pytorch
WORKDIR /usr/local/src/pytorch
# fetch submodules
RUN git submodule sync
# because there are so many submodules, try to init them with small batches, so that if some failed, most initialized modules can still be reused.
# this is because this process may not be very stable, randomly failing on any submodule.
# source: https://github.com/pytorch/pytorch/blob/v2.9.0-rc9/.gitmodules
RUN git submodule update --init --recursive --depth=1 third_party/pybind11
RUN git submodule update --init --recursive --depth=1 third_party/googletest
RUN git submodule update --init --recursive --depth=1 third_party/benchmark
RUN git submodule update --init --recursive --depth=1 third_party/protobuf
RUN git submodule update --init --recursive --depth=1 third_party/NNPACK
RUN git submodule update --init --recursive --depth=1 third_party/gloo
RUN git submodule update --init --recursive --depth=1 third_party/pthreadpool
RUN git submodule update --init --recursive --depth=1 third_party/FXdiv
RUN git submodule update --init --recursive --depth=1 third_party/FP16
RUN git submodule update --init --recursive --depth=1 third_party/psimd
RUN git submodule update --init --recursive --depth=1 third_party/cpuinfo
RUN git submodule update --init --recursive --depth=1 third_party/python-peachpy
RUN git submodule update --init --recursive --depth=1 third_party/onnx
RUN git submodule update --init --recursive --depth=1 third_party/sleef
RUN git submodule update --init --recursive --depth=1 third_party/ideep
RUN git submodule update --init --recursive --depth=1 third_party/gemmlowp/gemmlowp
RUN git submodule update --init --recursive --depth=1 third_party/fbgemm
RUN git submodule update --init --recursive --depth=1 android/libs/fbjni
RUN git submodule update --init --recursive --depth=1 third_party/XNNPACK
RUN git submodule update --init --recursive --depth=1 third_party/fmt
RUN git submodule update --init --recursive --depth=1 third_party/tensorpipe
RUN git submodule update --init --recursive --depth=1 third_party/cudnn_frontend
RUN git submodule update --init --recursive --depth=1 third_party/kineto
RUN git submodule update --init --recursive --depth=1 third_party/pocketfft
RUN git submodule update --init --recursive --depth=1 third_party/ittapi
RUN git submodule update --init --recursive --depth=1 third_party/flatbuffers
RUN git submodule update --init --recursive --depth=1 third_party/nlohmann
RUN git submodule update --init --recursive --depth=1 third_party/VulkanMemoryAllocator
RUN git submodule update --init --recursive --depth=1 third_party/cutlass
RUN git submodule update --init --recursive --depth=1 third_party/mimalloc
RUN git submodule update --init --recursive --depth=1 third_party/opentelemetry-cpp
RUN git submodule update --init --recursive --depth=1 third_party/cpp-httplib
RUN git submodule update --init --recursive --depth=1 third_party/NVTX
RUN git submodule update --init --recursive --depth=1 third_party/composable_kernel
RUN git submodule update --init --recursive --depth=1 third_party/kleidiai
RUN git submodule update --init --recursive --depth=1 third_party/flash-attention
RUN git submodule update --init --recursive --depth=1 third_party/aiter
# update is there's any other submodule missing.
RUN git submodule update --init --recursive --depth=1 
# Create and use virtual environment
RUN python -m venv /usr/local/lib/pytorch-venv && chmod +x /usr/local/lib/pytorch-venv/bin/activate
ENV PATH="/usr/local/lib/pytorch-venv/bin:$PATH"
RUN python -m pip install --upgrade pip
# Set ROCm architecture
ENV PYTORCH_ROCM_ARCH=gfx1151
# Install dependencies
RUN pip install --group dev
RUN pip install mkl-static mkl-include
RUN make triton
# Setup AMD environment
RUN python tools/amd_build/build_amd.py
# Build PyTorch
RUN python -m pip install --no-build-isolation -v -e .
# Setup workdir
WORKDIR /root
