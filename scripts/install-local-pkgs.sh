#!/usr/bin/env bash
# Instala/compila pacotes locais customizados (ex: keepassxc com patch)
set -euo pipefail

REPO="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
PACKAGES_DIR="$REPO/src/packages"

log() { printf '\033[1;34m==yn==\033[0m %s\n' "$*"; }
warn() { printf '\033[1;33m!!\033[0m %s\n' "$*"; }

install_keepassxc_dark() {
    local target_dir="$PACKAGES_DIR/keepassxc-dark-box"
    
    if [[ ! -d "$target_dir" ]]; then
        warn "Diretório do keepassxc-dark-box não encontrado em $target_dir"
        return
    }

    log "Compilando e instalando KeePassXC customizado (dark-box)..."
    cd "$target_dir"
    
    # Roda o makepkg ignorando verificação de chave (caso necessário) e instalando automaticamente
    makepkg -si --skippgpcheck --noconfirm
    
    log "KeePassXC customizado instalado com sucesso!"
}

# Aqui você pode chamar a função do KeePassXC e futuras outras customizações
install_keepassxc_dark
