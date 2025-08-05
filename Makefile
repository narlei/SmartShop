.PHONY: help install generate clean open

# Variables
PROJECT_NAME = SmartShop
TUIST_VERSION = 4.55.6

# Main commands
help: ## Show this help
	@echo "Available commands:"
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-20s\033[0m %s\n", $$1, $$2}'

install: ## Install Tuist
	@echo "🚀 Installing Tuist..."
	@if ! command -v tuist &>/dev/null; then \
		echo "⏳ Installing Tuist via Homebrew..."; \
		brew tap tuist/tuist && brew install tuist; \
	else \
		echo "✅ Tuist is already installed"; \
	fi

clean: ## Clean Tuist cache
	@echo "🧹 Cleaning Tuist cache..."
	@tuist clean

generate: install ## Generate Xcode project
	@echo "📦 Generating modules..."
	@tuist generate --no-open
	@echo "✅ Project generated successfully!"

open: ## Open project in Xcode
	@echo "📂 Opening project in Xcode..."
	@open $(PROJECT_NAME).xcworkspace

dev: generate open ## Generate and open project (complete command)

# Development commands
build: generate ## Generate and build project
	@echo "🔨 Building project..."
	@xcodebuild -workspace $(PROJECT_NAME).xcworkspace -scheme $(PROJECT_NAME) -configuration Debug build

test: generate ## Generate and run tests
	@echo "🧪 Running tests with Tuist..."
	@tuist test --device "iPhone 16 Pro" --os 18.2

# Cleanup commands
clean-all: clean ## Clean everything (cache + generated files)
	@echo "🗑️ Removing generated files..."
	@rm -rf *.xcodeproj
	@rm -rf *.xcworkspace
	@find . -name "*.xcodeproj" -type d -exec rm -rf {} + 2>/dev/null || true
	@find . -name "*.xcworkspace" -type d -exec rm -rf {} + 2>/dev/null || true
