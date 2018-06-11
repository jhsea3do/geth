# Build Geth in a stock Go builder container
FROM golang:1.10-alpine as builder

WORKDIR /
RUN apk add --no-cache make gcc musl-dev linux-headers git
  && git clone https://github.com/ethereum/go-ethereum \
  && cd /go-ethereum && make geth

# Pull Geth into a second stage deploy alpine container
FROM alpine:latest

RUN apk add --no-cache ca-certificates
COPY --from=builder /go-ethereum/build/bin/geth /usr/local/bin/

EXPOSE 8545 8546 30303 30303/udp
ENTRYPOINT ["geth"]
