FROM golang:1.14-alpine AS build_base

# Set the Current Working Directory inside the container
WORKDIR /tmp/kubepug

# We want to populate the module cache based on the go.{mod,sum} files.
COPY go.mod .
COPY go.sum .

RUN go mod download

COPY . .

# Build the Go app
RUN go build -o ./out/kubepug ./cmd/kubepug.go

# Slim runtime image
FROM alpine:3.10

COPY --from=build_base /tmp/kubepug/out/kubepug /usr/bin/kubepug

CMD ["/usr/bin/kubepug", "--monitor"]