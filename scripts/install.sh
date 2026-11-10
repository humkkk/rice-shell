#!/usr/bin/env bash
# Instalador dos dotfiles (Arch/CachyOS).
#   1. Cria symlinks RELATIVOS de config/* para ~/.config
#   2. Pergunta se instala os pacotes do pacman
#   3. Pergunta se instala os pacotes do AUR (instala o paru se faltar)
#   4. Pergunta se recompila o KeePassXC customizado
# Uso: ./scripts/install.sh
set -euo pipefail

REPO="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
CONFIG_SRC="$REPO/config"
PACKAGES_DIR="$REPO/packages"
CONFIG_DST="${XDG_CONFIG_HOME:-$HOME/.config}"
BACKUP="$HOME/.dotfiles-backup/$(date +%Y%m%d-%H%M%S)"

log()  { printf '\033[1;34m==>\033[0m %s\n' "$*"; }
warn() { printf '\033[1;33m!!\033[0m %s\n' "$*"; }
die()  { printf '\033[1;31mxx\033[0m %s\n' "$*" >&2; exit 1; }

# Lista sem comentários e linhas vazias
read_list() { grep -vE '^\s*(#|$)' "$1"; }

# Pergunta s/N (padrão: não)
ask() {
  local reply
  read -r -p "$1 [s/N] " reply
  [[ "$reply" =~ ^([sS]|[sS][iI][mM]|[yY]|[yY][eE][sS])$ ]]
}

# ─── Checagens iniciais ────────────────────────────────
[[ -t 0 ]] || die "Rode este script em um terminal interativo."
[[ $EUID -ne 0 ]] || die "Não rode como root (makepkg/paru não funcionam assim)."
[[ -d "$CONFIG_SRC" ]] || die "Pasta não encontrada: $CONFIG_SRC"

# ─── 1. Symlinks relativos ─────────────────────────────
link() {
  local from="$1" to="$2"

  mkdir -p "$(dirname "$to")"
  if [[ -L "$to" ]]; then
    rm "$to"
  elif [[ -e "$to" ]]; then
    mkdir -p "$BACKUP"
    mv "$to" "$BACKUP/"
    warn "Backup de $to em $BACKUP"
  fi
  ln -sr "$from" "$to"   # -r = symlink relativo
  log "$to -> $(readlink "$to")"
}

link_dotfiles() {
  log "Linkando config/ em $CONFIG_DST ..."
  local item
  for item in "$CONFIG_SRC"/*; do
    [[ -e "$item" ]] || continue
    link "$item" "$CONFIG_DST/$(basename "$item")"
  done
}

# ─── 2. Pacotes do pacman ──────────────────────────────
install_pacman() {
  command -v pacman >/dev/null || { warn "pacman não encontrado (script feito para Arch)."; return; }
  local list="$PACKAGES_DIR/pacman.txt"
  [[ -f "$list" ]] || { warn "Não existe: $list"; return; }

  local pkgs
  mapfile -t pkgs < <(read_list "$list")
  log "Instalando ${#pkgs[@]} pacotes do pacman..."
  sudo pacman -S --needed --noconfirm "${pkgs[@]}"
}

# ─── 3. Pacotes do AUR ─────────────────────────────────
ensure_paru() {
  command -v paru >/dev/null && return 0

  log "paru não encontrado, instalando..."
  # No CachyOS o paru já está nos repositórios
  if sudo pacman -S --needed --noconfirm paru; then
    return 0
  fi

  warn "Não está nos repositórios, compilando paru-bin do AUR..."
  sudo pacman -S --needed --noconfirm base-devel git
  local tmp
  tmp="$(mktemp -d)"
  git clone https://aur.archlinux.org/paru-bin.git "$tmp/paru-bin"
  (cd "$tmp/paru-bin" && makepkg -si --noconfirm)
  rm -rf "$tmp"
}

install_aur() {
  command -v pacman >/dev/null || { warn "pacman não encontrado (script feito para Arch)."; return; }
  local list="$PACKAGES_DIR/aur.txt"
  [[ -f "$list" ]] || { warn "Não existe: $list"; return; }

  ensure_paru

  log "Instalando pacotes do AUR (um por vez, se um falhar o resto continua)..."
  local failed=() pkg
  while read -r pkg; do
    paru -S --needed --noconfirm "$pkg" || failed+=("$pkg")
  done < <(read_list "$list")

  if (( ${#failed[@]} )); then
    warn "Pacotes que falharam (instale manualmente): ${failed[*]}"
  fi
}

# ─── 4. KeePassXC customizado ──────────────────────────
rebuild_keepassxc() {
  local dir="$PACKAGES_DIR/keepassxc-dark-box"
  [[ -d "$dir" ]] || { warn "Diretório não encontrado: $dir"; return; }

  log "Compilando e instalando KeePassXC customizado (dark-box)..."
  (cd "$dir" && makepkg -si --skippgpcheck --noconfirm)
  log "KeePassXC customizado instalado!"
}

# ─── Execução ──────────────────────────────────────────
link_dotfiles

if ask "Instalar todos os pacotes do pacman?"; then
  install_pacman
fi

if ask "Instalar todos os pacotes do AUR?"; then
  install_aur
fi

if ask "Recompilar o KeePassXC com a mudança (keepassxc-dark-box)?"; then
  rebuild_keepassxc
fi

log "Pronto! Faça logout/login para aplicar tudo."
