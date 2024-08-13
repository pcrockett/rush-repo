FROM docker.io/library/debian:12-slim
ARG DEBIAN_FRONTEND=noninteractive

# don't need to pin apt package versions
# hadolint ignore=DL3008
RUN useradd --create-home user && \
mkdir /app && \
chown -R user:user /app && \
apt-get update && \
apt-get install --yes --no-install-recommends curl ca-certificates && \
apt-get clean && rm -rf /var/lib/apt/lists/*

USER user
WORKDIR /app

# RUN STUFF HERE
