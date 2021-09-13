FROM alpine:3.14.0
# Install packages from package repository
RUN apk add --no-cache \
    bash \
    gettext \
    curl \
    jq \
    ansible \
    python3 \
    git \
    openssh \
    docker

COPY versions .

# Install doctl
RUN . versions \
    && echo "installing doctl ${DOCTL_VERSION}" \
    && wget -q -O doctl.tar.gz "https://github.com/digitalocean/doctl/releases/download/v${DOCTL_VERSION}/doctl-${DOCTL_VERSION}-linux-amd64.tar.gz" \
    && tar -xf doctl.tar.gz --directory /bin \
    && rm -f doctl.tar.gz

# Install kubectl
RUN  . versions \
    && echo "installing kubectl ${KUBE_VERSION}" \
    && wget -q -O /usr/local/bin/kubectl "https://storage.googleapis.com/kubernetes-release/release/v${KUBE_VERSION}/bin/linux/amd64/kubectl" \
    && chmod +x /usr/local/bin/kubectl

# Install terraform
RUN ( . versions && \ 
      curl -sLo terraform.zip "https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip" && \
      unzip terraform.zip && \
      rm terraform.zip && \
      mv ./terraform /usr/local/bin/terraform \
    ) && terraform --version

COPY src/bin/gitlab-terraform.sh /usr/bin/gitlab-terraform
RUN chmod +x /usr/bin/gitlab-terraform

# Override ENTRYPOINT since hashicorp/terraform uses `terraform`
#ENTRYPOINT []
