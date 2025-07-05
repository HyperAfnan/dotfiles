nvim() {
    if ! pidof socat > /dev/null 2>&1; then
        [ -e /tmp/discord-ipc-0 ] && rm -f /tmp/discord-ipc-0
        socat UNIX-LISTEN:/tmp/discord-ipc-0,fork \
            EXEC:"npiperelay.exe //./pipe/discord-ipc-0" 2>/dev/null &
    fi

    if [ $# -eq 0 ]; then
        command nvim
    else
        command nvim "$@"
    fi
}

