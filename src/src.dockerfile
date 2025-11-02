# ============
#  Base Image
# ============
FROM ubuntu:noble as ubuntu-base
RUN apt-get update \
 && apt-get upgrade -y \
 && apt-get install -y git


# ==========================
#  Triton Source Code Image
# ==========================
FROM ubuntu-base as src-triton

ARG TRITON_REPO="https://github.com/triton-lang/triton.git"
ARG TRITON_VERSION="v3.5.0"

ENV TRITON_HOME="/usr/local/src/triton"
RUN git clone --branch ${TRITON_VERSION} --single-branch --depth 1 ${TRITON_REPO} "${TRITON_HOME}" \
  && cd "${TRITON_HOME}" \
  && git submodule update --init --recursive --depth=1 \
  && rm -rf ./.git


# ===========================
#  PyTorch Source Code Image
# ===========================
FROM ubuntu-base as src-pytorch

ARG PYTORCH_REPO="https://github.com/pytorch/pytorch.git"
ARG PYTORCH_VERSION="v2.9.0"

ENV PYTORCH_HOME="/usr/local/src/pytorch"
RUN git clone --branch ${PYTORCH_VERSION} --single-branch --depth 1 ${PYTORCH_REPO} "${PYTORCH_HOME}" \
 && cd "${PYTORCH_HOME}" \
 && git submodule update --init --recursive --depth=1 \
 && rm -rf ./.git


# ===============================
#  torchvision Source Code Image
# ===============================
FROM ubuntu-base as src-torchvision

ARG TORCHVISION_REPO="https://github.com/pytorch/vision.git"
ARG TORCHVISION_VERSION="v0.24.0"

ENV TORCHVISION_HOME="/usr/local/src/torchvision"
RUN git clone --branch ${TORCHVISION_VERSION} --single-branch --depth 1 ${TORCHVISION_REPO} "${TORCHVISION_HOME}" \
 && rm -rf ./.git


# ===================================
#  Flash Attention Source Code Image
# ===================================
FROM ubuntu-base as src-flash-attention

ARG FLASH_ATTENTION_REPO="https://github.com/Dao-AILab/flash-attention.git"
ARG FLASH_ATTENTION_BRANCH="main"
ARG FLASH_ATTENTION_VERSION="0256114fe2381ab293503219bdd9078de3cd26b3"

ENV FLASH_ATTENTION_HOME="/usr/local/src/flash-attention"
RUN git clone --branch ${FLASH_ATTENTION_BRANCH} --single-branch ${FLASH_ATTENTION_REPO} "${FLASH_ATTENTION_HOME}" \
 && cd "${FLASH_ATTENTION_HOME}" \
 && git checkout ${FLASH_ATTENTION_BRANCH} \
 && git submodule update --init --recursive --depth=1 \
 && rm -rf ./.git


# =========================
#  AITER Source Code Image
# =========================
FROM ubuntu-base as src-aiter

ARG AITER_REPO="https://github.com/ROCm/aiter.git"
ARG AITER_BRANCH="main"
ARG AITER_VERSION="294b779c6cc9790dbfd1815ddcf0026c62008456"

ENV AITER_HOME="/usr/local/src/aiter"
RUN git clone --branch ${AITER_BRANCH} --single-branch ${AITER_REPO} "${AITER_HOME}" \
 && cd "${AITER_HOME}" \
 && git checkout ${AITER_VERSION} \
 && git submodule update --init --recursive --depth=1 \
 && rm -rf ./.git


# ========================
#  vLLM Source Code Image
# ========================
FROM ubuntu-base as src-vllm

ARG VLLM_REPO="https://github.com/vllm-project/vllm.git"
ARG VLLM_VERSION="v0.11.1rc5"

ENV VLLM_HOME="/usr/local/src/vllm"
RUN git clone --branch ${VLLM_VERSION} --single-branch --depth 1 ${VLLM_REPO} "${VLLM_HOME}" \
 && cd "${VLLM_HOME}" \
 && rm -rf ./.git


# ========================
#  vLLM Source Code Image
# ========================
FROM ubuntu-base as src-vllm

COPY --from=src-triton /usr/local/src/triton /usr/local/src/triton
COPY --from=src-pytorch /usr/local/src/pytorch /usr/local/src/pytorch
COPY --from=src-torchvision /usr/local/src/torchvision /usr/local/src/torchvision
COPY --from=src-flash-attention /usr/local/src/flash-attention /usr/local/src/flash-attention
COPY --from=src-aiter /usr/local/src/aiter /usr/local/src/aiter
COPY --from=src-vllm /usr/local/src/vllm /usr/local/src/vllm
