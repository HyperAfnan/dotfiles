import Quickshell
import Quickshell.Wayland
import QtQuick
import QtQuick.Layouts

PanelWindow {
    anchors.top: true
    anchors.left: true
    anchors.right: true

    margins.top: Config.ui.showNotch ? 0 : 8
    margins.left: Config.ui.showNotch ? 0 : 8
    margins.right: Config.ui.showNotch ? 0 : 8

    implicitHeight: 30
    color: Config.ui.showNotch ? Config.colors.bg : "transparent"

    Rectangle {
        visible: !Config.ui.showNotch
        id: barBackground
        anchors.fill: parent
        color: Config.colors.bg
        radius: 10
    }

    Notch {}
    RowLayout {
        anchors.fill: parent
        anchors.leftMargin: 8
        anchors.rightMargin: 8
        spacing: Config.spacing.normal

        Text {
            text: "  󰣇 "
            color: Config.colors.fg
            Layout.alignment: Qt.AlignVCenter

            font.family: Config.font.family
            font.pixelSize: Config.font.size
            font.bold: Config.font.nobold

            MouseArea {
                anchors.fill: parent
                onClicked: Wayland.launchApp("wlogout", [])
                onDoubleClicked: Wayland.launchApp("kitty", ["-e", "htop"])
                hoverEnabled: true
            }
        }

        WindowTitle {}
        Workspaces {}

        Item {
            Layout.fillWidth: true
        }

        SystemStats {}
        Screenshot {}
        Wifi {}
        Speaker {}
        Microphone {}
        Bluetooth {}
        Battery {}
        Clock {}
    }
}
