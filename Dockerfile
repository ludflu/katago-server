FROM ubuntu:latest

ARG KATAGO_VERSION=v1.14.1

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

RUN cmake ..  -DUSE_BACKEND=EIGEN
RUN make -j$(nproc)

RUN apt update -y && apt install --no-install-recommends -y \
  zlib1g-dev \
  libzip-dev \
  && rm -rf /var/lib/apt/lists/*

WORKDIR /app

RUN cp /KataGo/cpp/build/katago /app

WORKDIR /api
COPY . /api
RUN poetry --no-root install

EXPOSE 2178
CMD ["poetry","run","python","katago_server.py"]
