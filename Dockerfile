FROM alpine@sha256:3f4d6b32e26703c6082839234f43769d5046b3ac7c910033911d1e71d8cd630a AS extractor

ARG TARGETOS
ARG TARGETARCH

# renovate: datasource=github-releases depName=helm/helm extractVersion=v(?<version>.*)$
ARG HELM_VERSION=4.3.1
ADD https://get.helm.sh/helm-v${HELM_VERSION}-${TARGETOS}-${TARGETARCH}.tar.gz /tmp/helm.tar.gz

WORKDIR /out
RUN tar -xf /tmp/helm.tar.gz && mv ./**/helm helm && chmod +x helm

# renovate: datasource=endoflife-date depName=kubernetes
ARG KUBECTL_VERSION=1.37.2
ADD https://dl.k8s.io/release/v${KUBECTL_VERSION}/bin/${TARGETOS}/${TARGETARCH}/kubectl kubectl
RUN chmod +x kubectl


FROM alpine@sha256:3f4d6b32e26703c6082839234f43769d5046b3ac7c910033911d1e71d8cd630a

COPY --from=extractor /out/helm /usr/bin/
COPY --from=extractor /out/kubectl /usr/bin/

RUN adduser -D -u 1000 helm
USER 1000
