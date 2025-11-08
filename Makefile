# Binary name
BINARY = salah-tui

# Version: use Git tag if available, otherwise default
VERSION ?= $(shell git describe --tags --always --dirty 2>/dev/null || echo "v0.0.0-dev")

# Build flags to embed version
LDFLAGS = -X main.version=$(VERSION)

# Default build target
build:
	go build -ldflags "$(LDFLAGS)" -o bin/$(BINARY) ./cmd/$(BINARY)

# Show embedded version
version:
	@echo $(VERSION)

# Run with version info
run:
	go run -ldflags "$(LDFLAGS)" ./cmd/$(BINARY)

# Create a tagged release build (Linux, macOS, etc.)
release:
	GOOS=linux  GOARCH=amd64 go build -ldflags "$(LDFLAGS)" -o bin/$(BINARY)-linux-amd64 ./cmd/$(BINARY)
	GOOS=darwin GOARCH=arm64 go build -ldflags "$(LDFLAGS)" -o bin/$(BINARY)-darwin-arm64 ./cmd/$(BINARY)
	@echo "Built release binaries with version $(VERSION)"

# Clean build artifacts
clean:
	rm -rf bin

