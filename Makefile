BINARY = salah-tui
PKG=./cmd/salah-tui
VERSION ?= $(shell git describe --tags --always --dirty 2>/dev/null || echo "v0.0.0-dev")
LDFLAGS = -X main.version=$(VERSION)

.PHONY: build version run lint fmt release clean

build:
	go build -ldflags "$(LDFLAGS)" -o bin/$(BINARY) $(PKG)

version:
	@echo $(VERSION)

run:
	go run -ldflags "$(LDFLAGS)" $(PKG)

fmt:
	gofmt -s -w .
	go mod tidy

lint:
	golangci-lint run

release:
	GOOS=linux  GOARCH=amd64 go build -ldflags "$(LDFLAGS)" -o bin/$(BINARY)-linux-amd64 ./cmd/$(BINARY)
	GOOS=darwin GOARCH=arm64 go build -ldflags "$(LDFLAGS)" -o bin/$(BINARY)-darwin-arm64 ./cmd/$(BINARY)
	@echo "Built release binaries with version $(VERSION)"

clean:
	rm -rf bin

