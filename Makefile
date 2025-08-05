.PHONY: help install generate clean open

# Variáveis
PROJECT_NAME = SmartShop
TUIST_VERSION = 4.0.0

# Comandos principais
help: ## Mostra esta ajuda
	@echo "Comandos disponíveis:"
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-20s\033[0m %s\n", $$1, $$2}'

install: ## Instala o Tuist
	@echo "🚀 Instalando Tuist..."
	@if ! command -v tuist &> /dev/null; then \
		curl -Ls https://install.tuist.io | bash; \
		source ~/.zshrc; \
	else \
		echo "✅ Tuist já está instalado"; \
	fi

clean: ## Limpa o cache do Tuist
	@echo "🧹 Limpando cache do Tuist..."
	@tuist clean

generate: install clean ## Gera o projeto Xcode
	@echo "📦 Gerando módulos TMA..."
	@cd Modules/uCore && tuist generate && cd ../..
	@cd Modules/uNetwork && tuist generate && cd ../..
	@cd Modules/uHome && tuist generate && cd ../..
	@echo "📱 Gerando projeto principal..."
	@tuist generate
	@echo "✅ Projeto gerado com sucesso!"

open: ## Abre o projeto no Xcode
	@echo "📂 Abrindo projeto no Xcode..."
	@open $(PROJECT_NAME).xcodeproj

dev: generate open ## Gera e abre o projeto (comando completo)

# Comandos para módulos individuais
generate-core: ## Gera apenas o módulo Core
	@echo "📦 Gerando módulo Core..."
	@cd Modules/uCore && tuist generate && cd ../..

generate-network: ## Gera apenas o módulo Network
	@echo "📦 Gerando módulo Network..."
	@cd Modules/uNetwork && tuist generate && cd ../..

generate-home: ## Gera apenas o módulo Home
	@echo "📦 Gerando módulo Home..."
	@cd Modules/uHome && tuist generate && cd ../..

# Comandos de desenvolvimento
build: generate ## Gera e compila o projeto
	@echo "🔨 Compilando projeto..."
	@xcodebuild -project $(PROJECT_NAME).xcodeproj -scheme $(PROJECT_NAME) -configuration Debug build

test: generate ## Gera e executa os testes
	@echo "🧪 Executando testes..."
	@xcodebuild -project $(PROJECT_NAME).xcodeproj -scheme $(PROJECT_NAME) -configuration Debug test

# Comandos de limpeza
clean-all: clean ## Limpa tudo (cache + arquivos gerados)
	@echo "🗑️ Removendo arquivos gerados..."
	@rm -rf *.xcodeproj
	@rm -rf *.xcworkspace
	@find . -name "*.xcodeproj" -type d -exec rm -rf {} + 2>/dev/null || true
	@find . -name "*.xcworkspace" -type d -exec rm -rf {} + 2>/dev/null || true

# Comandos de informação
status: ## Mostra o status do projeto
	@echo "📊 Status do projeto:"
	@echo "  - Tuist instalado: $$(command -v tuist >/dev/null && echo '✅' || echo '❌')"
	@echo "  - Projeto gerado: $$(ls *.xcodeproj >/dev/null 2>&1 && echo '✅' || echo '❌')"
	@echo "  - Módulos TMA:"
	@echo "    - uCore: $$(ls Modules/uCore/*.xcodeproj >/dev/null 2>&1 && echo '✅' || echo '❌')"
	@echo "    - uNetwork: $$(ls Modules/uNetwork/*.xcodeproj >/dev/null 2>&1 && echo '✅' || echo '❌')"
	@echo "    - uHome: $$(ls Modules/uHome/*.xcodeproj >/dev/null 2>&1 && echo '✅' || echo '❌')" 