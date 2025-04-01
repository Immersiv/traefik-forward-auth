FROM golang:1.24-alpine AS builder

# Setup
WORKDIR /work

# Copy & build
ADD . /work
# RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 GO111MODULE=on go build -a -installsuffix nocgo -o /traefik-forward-auth github.com/thomseddon/traefik-forward-auth/cmd
RUN cd /work/cmd/ && CGO_ENABLED=0 go build

# Copy into scratch container
FROM scratch
COPY --from=builder /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/
COPY --from=builder /work ./

ENTRYPOINT ["./cmd/cmd"]
