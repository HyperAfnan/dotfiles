import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Io
import Quickshell.Hyprland

Text {
    Layout.alignment: Qt.AlignVCenter
    color: Config.colors.fg
    font {
        family: Config.font.family
        pixelSize: Config.font.size
        bold: Config.font.nobold
    }

    property string activeWindowTitle: ""
    property bool connected: false

    Process {
        id: titleProc
        command: [
            "sh", "-c",
            "hyprctl activewindow | grep 'initialTitle:' | sed 's/^\\s*initialTitle: //'"
        ]

        stdout: SplitParser {
            onRead: data => activeWindowTitle = data.trim()
        }
    }

    function updateTitle() {
        titleProc.running = false
        titleProc.running = true
    }

    Component.onCompleted: {
        updateTitle()

        if (!connected) {
            Hyprland.rawEvent.connect(hyprEvent)
            connected = true
        }
    }

    function hyprEvent(e) {
            updateTitle()
    }

    text: activeWindowTitle
}
