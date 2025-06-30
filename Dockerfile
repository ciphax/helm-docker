FROM alpine@sha256:8a1f59ffb675680d47db6337b49d22281a139e9d709335b492be023728e11715 AS extractor

ARG TARGETOS
ARG TARGETARCH

# renovate: datasource=github-releases depName=helm/helm extractVersion=v(?<version>.*)$
ARG HELM_VERSION=3.18.3
ADD https://get.helm.sh/helm-v${HELM_VERSION}-${TARGETOS}-${TARGETARCH}.tar.gz /tmp/helm.tar.gz

WORKDIR /out
RUN tar -xf /tmp/helm.tar.gz && mv ./**/helm helm && chmod +x helm

# renovate: datasource=endoflife-date depName=kubernetes
ARG KUBECTL_VERSION=1.33.2
ADD https://dl.k8s.io/release/v${KUBECTL_VERSION}/bin/${TARGETOS}/${TARGETARCH}/kubectl kubectl
RUN chmod +x kubectl


FROM alpine@sha256:8a1f59ffb675680d47db6337b49d22281a139e9d709335b492be023728e11715

COPY --from=extractor /out/helm /usr/bin/
COPY --from=extractor /out/kubectl /usr/bin/

RUN adduser -D -u 1000 helm
USER 1000
