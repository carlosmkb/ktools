FROM alpine:3.11

ENV KUBECTL_VERSION="v1.17.0"

RUN apk add --update \
      jq \
      curl \
      bash \
      python \
      py-pip \
      gettext \
      openssl \
      openssl-dev && \
    pip install --upgrade awscli && \
    pip install --upgrade yq && \
    apk -v --purge del py-pip && \
    rm -rf /var/cache/apk/*

RUN [ "$KUBECTL_VERSION" == "latest" ] && \
    export KUBECTL_VERSION="$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)"; \
    curl -LO https://storage.googleapis.com/kubernetes-release/release/$KUBECTL_VERSION/bin/linux/amd64/kubectl && \
    chmod +x ./kubectl && \
    mv ./kubectl /usr/local/bin/kubectl

COPY bin/ /tmp/bin/

RUN chmod +x /tmp/bin/* && \
    mv /tmp/bin/* /usr/bin

