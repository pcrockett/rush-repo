VERSION 0.8
FROM docker.io/library/debian:12-slim

RUN useradd --create-home ci_user && \
mkdir /repo && \
chown -R ci_user:ci_user /repo && \
apt-get update && \
apt-get install --yes --no-install-recommends \
    curl ca-certificates git make xz-utils && \
apt-get clean && rm -rf /var/lib/apt/lists/*

USER ci_user
ENV ASDF_DIR="${HOME}/.asdf"
ENV PATH="${ASDF_DIR}/bin:${ASDF_DIR}/shims:${PATH}"

RUN curl -SsfL https://philcrockett.com/yolo/v1.sh \
    | bash -s -- docker/asdf && \
asdf plugin add shellcheck && \
asdf plugin add bashly https://github.com/pcrockett/asdf-bashly.git && \
asdf plugin add bats https://github.com/pcrockett/asdf-bats.git

WORKDIR /repo

COPY .tool-versions .
RUN asdf install

COPY . .

all:
    BUILD +lint
    BUILD +test

build:
    RUN make build
    SAVE ARTIFACT TODO AS LOCAL TODO

lint:
    FROM +build
    RUN make lint

test:
    FROM +build
    RUN make test
