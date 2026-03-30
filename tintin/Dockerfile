FROM docker.io/library/debian:trixie-slim AS builder
ARG DEBIAN_FRONTEND=noninteractive

# <https://tintin.mudhalla.net/install.php#Debian>

WORKDIR /tmp/tintin

# don't need to pin apt package versions
# hadolint ignore=DL3008
RUN \
apt-get update && \
apt-get install --yes --no-install-recommends \
  ca-certificates build-essential zlib1g-dev libpcre2-dev wget

ARG TINTIN_VERSION=2.02.61

RUN \
wget "https://github.com/scandum/tintin/releases/download/${TINTIN_VERSION}/tintin-${TINTIN_VERSION}.tar.gz" && \
tar -zxvf "tintin-${TINTIN_VERSION}.tar.gz" && \
cd tt/src && \
./configure && \
make install

FROM docker.io/library/debian:trixie-slim
COPY --from=builder /usr/local/bin/tt++ /usr/local/bin/
RUN useradd --create-home user
USER user
WORKDIR /home/user
CMD [ "tt++" ]
