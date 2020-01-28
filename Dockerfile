# golang builder
FROM golang:1.13-alpine as builder

LABEL maintainer="Galih Rivanto <galih.rivanto@gmail.com>"

# working directory inside container
WORKDIR /app

# copy source to working dir
COPY . .

# download dependencies
RUN go mod download

# build
RUN CGO_ENABLED=0 GOOS=linux go build -a -installsuffix cgo -o main .

# start target
FROM alpine:3.11

# setup ssl client
RUN apk --no-cache add ca-certificates

# change workdir to /root
WORKDIR /root/

# copy prebuild binary from prev stage
COPY --from=builder /app/main .

# expose port 8080
EXPOSE 8080

# run app
ENTRYPOINT ["./main"]