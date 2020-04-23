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
    tar \
  && wget https://github.com/mikefarah/yq/releases/download/2.1.1/yq_linux_amd64 -O /usr/local/bin/yq \
  && chmod +x usr/local/bin/yq

ADD ./terraform /usr/local/bin/
# Borrowed from: https://github.com/dtzar/helm-kubectl/blob/master/Dockerfile
# Note: Latest version of kubectl may be found at:
# https://aur.archlinux.org/packages/kubectl-bin/
ENV KUBE_LATEST_VERSION="v1.16.2"
# Note: Latest version of helm may be found at:
# https://github.com/kubernetes/helm/releases
ENV HELM_VERSION="v3.1.2"

RUN wget -q https://storage.googleapis.com/kubernetes-release/release/${KUBE_LATEST_VERSION}/bin/linux/amd64/kubectl -O /usr/local/bin/kubectl \
    && chmod +x /usr/local/bin/kubectl \
    && wget -q https://get.helm.sh/helm-${HELM_VERSION}-linux-amd64.tar.gz -O - | tar -xzO linux-amd64/helm > /usr/local/bin/helm \
    && chmod +x /usr/local/bin/helm

COPY ./kubeconfig-template ./awscredentials-template ./awsconfig-template ./entrypoint.sh /
COPY ./bashrc /root/.bashrc

RUN chmod +x /entrypoint.sh

# ENTRYPOINT ["./entrypoint.sh"]
