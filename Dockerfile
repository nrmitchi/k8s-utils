#
# With inspiration from: 
#  - https://github.com/dtzar/helm-kubectl
#  - https://github.com/Financial-Times/k8s-cli-utils
#

FROM alpine:3.8

LABEL com.circleci.preserve-entrypoint=true

RUN apk update \
  && apk add --no-cache \
    ca-certificates \
    curl \
    wget \
    bind-tools \
    postgresql-client \
    busybox-extras \
    vim \
    bash \
    git \
    openssh-client \
    jq \
    make \
  && wget https://github.com/mikefarah/yq/releases/download/2.1.1/yq_linux_amd64 -O /usr/local/bin/yq \
  && chmod +x usr/local/bin/yq

# Borrowed from: https://github.com/dtzar/helm-kubectl/blob/master/Dockerfile
# Note: Latest version of kubectl may be found at:
# https://aur.archlinux.org/packages/kubectl-bin/
ENV KUBE_LATEST_VERSION="v1.10.2"
# Note: Latest version of helm may be found at:
# https://github.com/kubernetes/helm/releases
ENV HELM_VERSION="v2.9.1"

RUN wget -q https://storage.googleapis.com/kubernetes-release/release/${KUBE_LATEST_VERSION}/bin/linux/amd64/kubectl -O /usr/local/bin/kubectl \
    && chmod +x /usr/local/bin/kubectl \
    && wget -q http://storage.googleapis.com/kubernetes-helm/helm-${HELM_VERSION}-linux-amd64.tar.gz -O - | tar -xzO linux-amd64/helm > /usr/local/bin/helm \
    && chmod +x /usr/local/bin/helm \
    && helm init -c \
    && helm plugin install https://github.com/hypnoglow/helm-s3.git \
    && helm plugin install https://github.com/chartmuseum/helm-push

COPY ./kubeconfig-template ./awscredentials-template ./awsconfig-template ./entrypoint.sh /
COPY ./bashrc /root/.bashrc

RUN chmod +x /entrypoint.sh

# ENTRYPOINT ["./entrypoint.sh"]
