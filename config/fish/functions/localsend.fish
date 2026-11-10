function localsend --description "Liga ou desliga as portas do LocalSend no UFW"
    if test (count $argv) -eq 0
        echo "Uso: localsend [on|off]"
        return 1
    end

    switch $argv[1]
        case on
            echo "Permitindo tráfego do LocalSend (porta 53317)..."
            sudo ufw allow 53317/tcp comment 'LocalSend'
            sudo ufw allow 53317/udp comment 'LocalSend'
            sudo ufw reload
            echo "LocalSend ativado!"
        case off
            echo "Bloqueando tráfego do LocalSend (porta 53317)..."
            sudo ufw delete allow 53317/tcp
            sudo ufw delete allow 53317/udp
            sudo ufw reload
            echo "LocalSend desativado!"
        case '*'
            echo "Opção inválida. Use: localsend on OU localsend off"
            return 1
    end
end
