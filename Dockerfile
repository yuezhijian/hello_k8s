# Use the official Golang image to create a build artifact.
# https://hub.docker.com/_/golang
FROM golang:1.12.5 as builder

# Copy local code to the container image.
WORKDIR /go/src/app

COPY . .

RUN GOOS=linux GOARCH=amd64 CGO_ENABLED=0 go build -o start main.go

# Use a Docker multi-stage build to create a lean production image.
# https://docs.docker.com/develop/develop-images/multistage-build/#use-multi-stage-builds
FROM alpine:3.9.4

RUN apk update && apk add curl

COPY --from=builder /go/src/app/start /start

RUN chmod 775 /start

# Run the web service on container startup.
CMD ["/start"]
