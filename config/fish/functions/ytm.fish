function ytm --description "Baixa música com metadados e capa"
    if test (count $argv) -eq 0
        echo "uso: ytm <url> [url...]"
        return 1
    end

    yt-dlp \
        -x --audio-format mp3 --audio-quality 0 \
        --embed-metadata --embed-thumbnail --convert-thumbnails jpg \
        -o "$HOME/Music/%(title)s.%(ext)s" \
        $argv
end
