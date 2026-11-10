function lutnet --description "Liga/desliga a rede do Lutris Flatpak"
    flatpak kill net.lutris.Lutris 2>/dev/null
    switch $argv[1]
        case on
            flatpak override --user --share=network net.lutris.Lutris
            echo "rede ligada"
        case off
            flatpak override --user --unshare=network net.lutris.Lutris
            echo "rede desligada"
        case '*'
            echo "uso: lutnet on|off"
    end
end
