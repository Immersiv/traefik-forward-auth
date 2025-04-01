FROM --platform=$BUILDPLATFORM golang:1.24-alpine AS builder

# Setup
WORKDIR /work

ARG TARGETOS
ARG TARGETARCH

# Copy & build
ADD . /work
RUN cd /work/cmd/ && CGO_ENABLED=0 GOOS=${TARGETOS} GOARCH=${TARGETARCH} go build

# Copy into scratch container
FROM scratch
COPY --from=builder /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/
COPY --from=builder /work ./

ENTRYPOINT ["./cmd/cmd"]
