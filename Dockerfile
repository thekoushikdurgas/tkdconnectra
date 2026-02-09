FROM golang:1.24-alpine AS builder

WORKDIR /app

# Install dependencies first for caching
COPY go.mod go.sum ./
RUN go mod download

# Copy source code and build
COPY . .
RUN go build -o connectra main.go

# Final stage: minimal runtime image
FROM alpine:latest

WORKDIR /app

# Copy binary from builder
COPY --from=builder /app/connectra .

# Copy .env file (Required by conf/viper.go)
COPY .env .

# Expose the internal port
EXPOSE 8000

# Default entrypoint
ENTRYPOINT ["./connectra"]
