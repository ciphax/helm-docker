FROM alpine@sha256:71e9b7bae160ba167fa17414401b94cbcdaf3c32feeab9298bd794a2a0614c35 AS extractor

ARG TARGETOS
ARG TARGETARCH

# renovate: datasource=github-releases depName=helm/helm extractVersion=v(?<version>.*)$
ARG HELM_VERSION=4.3.1
ADD https://get.helm.sh/helm-v${HELM_VERSION}-${TARGETOS}-${TARGETARCH}.tar.gz /tmp/helm.tar.gz

WORKDIR /out
RUN tar -xf /tmp/helm.tar.gz && mv ./**/helm helm && chmod +x helm

# renovate: datasource=endoflife-date depName=kubernetes
ARG KUBECTL_VERSION=1.37.1
ADD https://dl.k8s.io/release/v${KUBECTL_VERSION}/bin/${TARGETOS}/${TARGETARCH}/kubectl kubectl
RUN chmod +x kubectl


FROM alpine@sha256:71e9b7bae160ba167fa17414401b94cbcdaf3c32feeab9298bd794a2a0614c35

COPY --from=extractor /out/helm /usr/bin/
COPY --from=extractor /out/kubectl /usr/bin/

RUN adduser -D -u 1000 helm
USER 1000
