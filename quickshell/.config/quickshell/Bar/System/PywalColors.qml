pragma Singleton

import Quickshell
import Quickshell.Io
import QtQuick

Singleton {
    id: root

    property string color0: "#1a1b26"
    property string color1: "#f7768e"
    property string color2: "#9ece6a"
    property string color3: "#e0af68"
    property string color4: "#7aa2f7"
    property string color5: "#bb9af7"
    property string color6: "#7dcfff"
    property string color7: "#c0caf5"
    property string color8: "#414868"
    property string color9: "#f7768e"
    property string color10: "#9ece6a"
    property string color11: "#e0af68"
    property string color12: "#7aa2f7"
    property string color13: "#bb9af7"
    property string color14: "#7dcfff"
    property string color15: "#c0caf5"
    property string background: "#1a1b26"
    property string foreground: "#c0caf5"
    property string cursor: "#c0caf5"

    property bool loaded: false

    readonly property string homePath: Quickshell.env("HOME")
    readonly property string colorsPath: homePath + "/.cache/wal/colors.json"
    readonly property string walCacheDir: homePath + "/.cache/wal"

    Component.onCompleted: {
        loadColors.running = true
    }

    Process {
        id: loadColors
        running: true
        command: ["cat", root.colorsPath]
        stdout: StdioCollector {
            onStreamFinished: {
                if (text.trim().length === 0) {
                    return
                }
                try {
                    const data = JSON.parse(text)

                    if (data.special) {
                        root.background = data.special.background || root.background
                        root.foreground = data.special.foreground || root.foreground
                        root.cursor = data.special.cursor || root.cursor
                    }

                    if (data.colors) {
                        root.color0 = data.colors.color0 || root.color0
                        root.color1 = data.colors.color1 || root.color1
                        root.color2 = data.colors.color2 || root.color2
                        root.color3 = data.colors.color3 || root.color3
                        root.color4 = data.colors.color4 || root.color4
                        root.color5 = data.colors.color5 || root.color5
                        root.color6 = data.colors.color6 || root.color6
                        root.color7 = data.colors.color7 || root.color7
                        root.color8 = data.colors.color8 || root.color8
                        root.color9 = data.colors.color9 || root.color9
                        root.color10 = data.colors.color10 || root.color10
                        root.color11 = data.colors.color11 || root.color11
                        root.color12 = data.colors.color12 || root.color12
                        root.color13 = data.colors.color13 || root.color13
                        root.color14 = data.colors.color14 || root.color14
                        root.color15 = data.colors.color15 || root.color15
                    }

                    root.loaded = true
                } catch (e) {
                }
            }
        }
    }

    Process {
        id: fileWatcher
        running: true
        command: [
            "inotifywait",
            "-m",
            "-e", "modify",
            "-e", "create",
            "-e", "close_write",
            "--format", "%e",
            root.walCacheDir
        ]
        stdout: SplitParser {
            onRead: function(data) {
                reloadTimer.restart()
            }
        }
        onExited: function(exitCode, exitStatus) {
            restartWatcher.restart()
        }
    }

    Timer {
        id: reloadTimer
        interval: 500
        repeat: false
        onTriggered: {
            loadColors.running = true
        }
    }

    Timer {
        id: restartWatcher
        interval: 1000
        repeat: false
        onTriggered: {
            fileWatcher.running = true
        }
    }

    function bgWithAlpha(alpha) {
        var bg = background
        var r = parseInt(bg.slice(1, 3), 16) / 255
        var g = parseInt(bg.slice(3, 5), 16) / 255
        var b = parseInt(bg.slice(5, 7), 16) / 255
        return Qt.rgba(r, g, b, alpha)
    }
}
