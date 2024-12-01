FROM docker.io/library/katago-gpu

ARG KATAGO_VERSION=v1.15.3

RUN apt update -y && apt install -y \
  && rm -rf /var/lib/apt/lists/*

RUN apt update -y && apt install -y \
  build-essential \
  wget \
  git \
  vim \
  zlib1g-dev \
  libzip-dev \
  libeigen3-dev \
  python3 \
  python3-poetry \
  cuda-toolkit \ 
  cudnn9-cuda-12 \
  && rm -rf /var/lib/apt/lists/*

RUN wget https://github.com/Kitware/CMake/releases/download/v3.29.2/cmake-3.29.2-linux-x86_64.sh \
  -q -O /tmp/cmake-install.sh \
  && chmod u+x /tmp/cmake-install.sh \
  && /tmp/cmake-install.sh --skip-license --prefix=/usr/local \
  && rm /tmp/cmake-install.sh

WORKDIR /

ARG KATAGO_VERSION
RUN git clone -b ${KATAGO_VERSION} https://github.com/lightvector/KataGo.git && mkdir -p /KataGo/cpp/build

WORKDIR /KataGo/cpp/build

RUN cmake ..  -DCUDAToolkit_ROOT=/usr/local/cuda-12.1 -DUSE_BACKEND=CUDA
RUN make -j$(nproc)

WORKDIR /app

RUN cp /KataGo/cpp/build/katago /app

WORKDIR /api
COPY . /api
RUN poetry install

EXPOSE 2178
CMD ["poetry","run","python","katago_server.py"]
