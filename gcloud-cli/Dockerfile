FROM eu.gcr.io/google.com/cloudsdktool/google-cloud-cli:slim

ARG UID
ARG GID

USER cloudsdk
WORKDIR /home/cloudsdk
RUN mkdir --parent .config && chown -R "${UID}:${GID}" .config
