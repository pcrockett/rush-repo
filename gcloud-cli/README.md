# gcloud cli

_Google Cloud CLI from the latest published Docker container_

## motivation

gcloud cli [install instructions](https://cloud.google.com/sdk/docs/install) aren't very optimal for
me. either you have to configure a custom repository for your package manager (which then sometimes
breaks for unknown reasons), or you have to manually download a specifically versioned archive and
extract it.

i would like to do the "versioned archive" approach here, however there's no good way to find out
what the latest version is. so updates would still need to be manual.

so what i've done instead is create a docker image based on Google's official "slim" image, and a
wrapper script that executes the gcloud CLI within a docker container. i also deviated from
Google's [docker instructions](https://cloud.google.com/sdk/docs/downloads-docker) a bit by
mounting the host config directory inside the container, so you won't lose your configuration if
you decide you want to switch to the more traditional installation method.
