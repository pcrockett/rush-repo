# docker/asdf

example Dockerfile snippet that uses this package:

```dockerfile
ENV ASDF_DIR="${HOME}/.asdf"
ENV PATH="${ASDF_DIR}/bin:${ASDF_DIR}/shims:${PATH}"

RUN curl -SsfL https://raw.githubusercontent.com/pcrockett/rush-repo/main/yolo.sh \
    | bash -s -- docker/asdf && \
asdf plugin add age && \
asdf plugin add shellcheck && \
asdf plugin add bashly https://github.com/pcrockett/asdf-bashly.git && \
asdf plugin add bats https://github.com/pcrockett/asdf-bats.git
```
