# syntax=docker/dockerfile:1

FROM debian:bookworm-slim

ARG DEBIAN_FRONTEND=noninteractive
ARG TARGETARCH
ARG DOCKER_UID=1000
ARG DOCKER_GID=1000
ARG DOCKER_USER=devcontainer
ARG DOCKER_GROUP=devcontainer
ARG TERRAFORM_VERSION=1.11.2
ARG TFLINT_VERSION=0.53.0
ARG TERRAFORM_DOCS_VERSION=0.19.0
ARG NODE_MAJOR=22

ENV TF_IN_AUTOMATION=1 \
    TF_PLUGIN_CACHE_DIR=/home/${DOCKER_USER}/.terraform.d/plugin-cache \
    HOME=/home/${DOCKER_USER} \
    SHELL=/bin/bash

SHELL ["/bin/bash", "-eu", "-o", "pipefail", "-c"]

RUN apt-get update && apt-get install -y --no-install-recommends \
    ca-certificates \
    curl \
    git \
    gnupg \
    jq \
    less \
    make \
    openssh-client \
    python3 \
    python3-pip \
    sudo \
    unzip \
    vim \
    && rm -rf /var/lib/apt/lists/*

RUN if ! getent group "${DOCKER_GROUP}" >/dev/null; then \
      groupadd --gid "${DOCKER_GID}" "${DOCKER_GROUP}"; \
    fi \
    && if ! id -u "${DOCKER_USER}" >/dev/null 2>&1; then \
      useradd --uid "${DOCKER_UID}" --gid "${DOCKER_GID}" --create-home --shell /bin/bash "${DOCKER_USER}"; \
    fi \
    && install -d -o "${DOCKER_UID}" -g "${DOCKER_GID}" /workspace "${HOME}" "${TF_PLUGIN_CACHE_DIR}" \
    && printf '%s ALL=(ALL) NOPASSWD:ALL\n' "${DOCKER_USER}" > "/etc/sudoers.d/${DOCKER_USER}" \
    && chmod 0440 "/etc/sudoers.d/${DOCKER_USER}"

RUN set -eux; \
    case "${TARGETARCH:-amd64}" in \
      amd64) arch="x86_64"; docs_arch="amd64"; tflint_arch="amd64"; aws_arch="x86_64" ;; \
      arm64) arch="arm64"; docs_arch="arm64"; tflint_arch="arm64"; aws_arch="aarch64" ;; \
      *) echo "unsupported architecture: ${TARGETARCH:-unknown}" >&2; exit 1 ;; \
    esac; \
    curl -fsSLo /tmp/terraform.zip "https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_${arch}.zip"; \
    unzip /tmp/terraform.zip -d /usr/local/bin; \
    rm /tmp/terraform.zip; \
    curl -fsSLo /tmp/tflint.zip "https://github.com/terraform-linters/tflint/releases/download/v${TFLINT_VERSION}/tflint_linux_${tflint_arch}.zip"; \
    unzip /tmp/tflint.zip -d /usr/local/bin; \
    rm /tmp/tflint.zip; \
    curl -fsSLo /tmp/terraform-docs.tar.gz "https://github.com/terraform-docs/terraform-docs/releases/download/v${TERRAFORM_DOCS_VERSION}/terraform-docs-v${TERRAFORM_DOCS_VERSION}-linux-${docs_arch}.tar.gz"; \
    tar -xzf /tmp/terraform-docs.tar.gz -C /tmp; \
    install -m 0755 /tmp/terraform-docs /usr/local/bin/terraform-docs; \
    rm -f /tmp/terraform-docs /tmp/terraform-docs.tar.gz; \
    curl -fsSLo /tmp/awscliv2.zip "https://awscli.amazonaws.com/awscli-exe-linux-${aws_arch}.zip"; \
    unzip /tmp/awscliv2.zip -d /tmp; \
    /tmp/aws/install; \
    rm -rf /tmp/aws /tmp/awscliv2.zip

RUN curl -fsSL "https://deb.nodesource.com/setup_${NODE_MAJOR}.x" | bash - \
    && apt-get update && apt-get install -y --no-install-recommends nodejs \
    && npm install -g vercel \
    && rm -rf /var/lib/apt/lists/*

RUN curl -fsSL "https://packages.cloud.google.com/apt/doc/apt-key.gpg" \
      | gpg --dearmor -o /usr/share/keyrings/cloud.google.gpg \
    && echo "deb [signed-by=/usr/share/keyrings/cloud.google.gpg] https://packages.cloud.google.com/apt cloud-sdk main" \
      > /etc/apt/sources.list.d/google-cloud-sdk.list \
    && apt-get update && apt-get install -y --no-install-recommends google-cloud-sdk \
    && rm -rf /var/lib/apt/lists/*

RUN pip3 install --no-cache-dir --break-system-packages pre-commit \
    && curl -1sLf 'https://dl.cloudsmith.io/public/evilmartians/lefthook/setup.deb.sh' | bash \
    && apt-get update && apt-get install -y --no-install-recommends lefthook \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /workspace

USER ${DOCKER_USER}

CMD ["/bin/bash"]
