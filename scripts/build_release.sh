#!/bin/bash

# Script de build para release do Zet Gestor de Orçamento
# Este script automatiza o processo de build para Android, iOS e Web

set -e

echo "🚀 Iniciando processo de build para release..."

# Cores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Funções auxiliares
log_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

log_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

log_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Verificar dependências
check_dependencies() {
    log_info "Verificando dependências..."
    
    if ! command -v flutter &> /dev/null; then
        log_error "Flutter não está instalado ou não está no PATH"
        exit 1
    fi
    
    if ! command -v git &> /dev/null; then
        log_error "Git não está instalado ou não está no PATH"
        exit 1
    fi
    
    log_success "Dependências verificadas"
}

# Limpar builds anteriores
clean_builds() {
    log_info "Limpando builds anteriores..."
    flutter clean
    flutter pub get
    log_success "Builds limpos"
}

# Executar testes
run_tests() {
    log_info "Executando testes..."
    flutter test
    if [ $? -eq 0 ]; then
        log_success "Todos os testes passaram"
    else
        log_error "Alguns testes falharam"
        exit 1
    fi
}

# Build Android APK
build_android_apk() {
    log_info "Build Android APK..."
    flutter build apk --release
    if [ $? -eq 0 ]; then
        log_success "APK Android buildado com sucesso"
    else
        log_error "Falha ao buildar APK Android"
        exit 1
    fi
}

# Build Android App Bundle
build_android_aab() {
    log_info "Build Android App Bundle..."
    flutter build appbundle --release
    if [ $? -eq 0 ]; then
        log_success "App Bundle Android buildado com sucesso"
    else
        log_error "Falha ao buildar App Bundle Android"
        exit 1
    fi
}

# Build iOS (se estiver em macOS)
build_ios() {
    if [[ "$OSTYPE" == "darwin"* ]]; then
        log_info "Build iOS..."
        flutter build ios --release --no-codesign
        if [ $? -eq 0 ]; then
            log_success "iOS buildado com sucesso"
        else
            log_error "Falha ao buildar iOS"
            exit 1
        fi
    else
        log_warning "Build iOS ignorado (necessário macOS)"
    fi
}

# Build Web
build_web() {
    log_info "Build Web..."
    flutter build web --release
    if [ $? -eq 0 ]; then
        log_success "Web buildado com sucesso"
    else
        log_error "Falha ao buildar Web"
        exit 1
    fi
}

# Gerar changelog
generate_changelog() {
    log_info "Gerando changelog..."
    
    # Obter última tag
    LAST_TAG=$(git describe --tags --abbrev=0 2>/dev/null || echo "v1.0.0")
    
    # Gerar changelog
    cat > CHANGELOG.md << EOF
# Changelog

## $(date '+%Y-%m-%d')

### Features
- Build automático via CI/CD
- Otimizações de performance
- Melhorias de acessibilidade

### Correções
- Correções diversas

### Commits desde $LAST_TAG
$(git log --oneline $LAST_TAG..HEAD)

### Arquivos de Build
- Android APK: build/app/outputs/flutter-apk/app-release.apk
- Android AAB: build/app/outputs/bundle/release/app-release.aab
- Web: build/web/
EOF
    
    log_success "Changelog gerado"
}

# Criar pacote de release
create_release_package() {
    log_info "Criando pacote de release..."
    
    # Criar diretório de release
    RELEASE_DIR="release_$(date '+%Y%m%d_%H%M%S')"
    mkdir -p "$RELEASE_DIR"
    
    # Copiar arquivos de build
    if [ -f "build/app/outputs/flutter-apk/app-release.apk" ]; then
        cp build/app/outputs/flutter-apk/app-release.apk "$RELEASE_DIR/"
    fi
    
    if [ -f "build/app/outputs/bundle/release/app-release.aab" ]; then
        cp build/app/outputs/bundle/release/app-release.aab "$RELEASE_DIR/"
    fi
    
    if [ -d "build/web" ]; then
        cp -r build/web "$RELEASE_DIR/"
    fi
    
    # Copiar changelog
    cp CHANGELOG.md "$RELEASE_DIR/"
    
    # Criar arquivo de versão
    echo "$(date '+%Y-%m-%d %H:%M:%S')" > "$RELEASE_DIR/VERSION.txt"
    
    log_success "Pacote de release criado: $RELEASE_DIR"
}

# Verificar assinatura
check_signing() {
    log_info "Verificando configuração de assinatura..."
    
    if [ ! -f "android/app/key.properties" ]; then
        log_warning "Arquivo key.properties não encontrado. Usando configuração de debug."
    else
        log_success "Configuração de assinatura encontrada"
    fi
}

# Main function
main() {
    log_info "🎯 Iniciando build de release para Zet Gestor de Orçamento"
    
    # Verificar se estamos no diretório correto
    if [ ! -f "pubspec.yaml" ]; then
        log_error "Este script deve ser executado no diretório raiz do projeto"
        exit 1
    fi
    
    # Executar etapas
    check_dependencies
    check_signing
    clean_builds
    run_tests
    build_android_apk
    build_android_aab
    build_ios
    build_web
    generate_changelog
    create_release_package
    
    log_success "🎉 Build de release concluído com sucesso!"
    log_info "📦 Arquivos de release disponíveis no diretório release_*"