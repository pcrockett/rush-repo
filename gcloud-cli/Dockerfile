FROM eu.gcr.io/google.com/cloudsdktool/google-cloud-cli:slim

ARG UID
ARG GID

# we don't anticipate running inside kubernetes
# hadolint ignore=DL3066
USER cloudsdk

WORKDIR /home/cloudsdk
RUN mkdir --parent .config && chown -R "${UID}:${GID}" .config
