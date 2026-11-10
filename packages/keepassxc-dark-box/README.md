# keepassxc-dark-box

Patch visual para o KeePassXC 2.7.12: a caixa de desbloqueio usa a cor
de fundo da janela (palette(window)) e perde a borda branca.

## Arch/CachyOS
makepkg -si --nocheck

## Outras distros
Baixe o código-fonte do KeePassXC 2.7.12, aplique o patch e compile:

    patch -Np1 -i dark-box.patch
