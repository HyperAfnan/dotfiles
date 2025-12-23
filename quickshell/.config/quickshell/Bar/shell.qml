import Quickshell
import Quickshell.Wayland
import QtQuick
import QtQuick.Layouts

PanelWindow {
    anchors.top: true
    anchors.left: true
    anchors.right: true

    implicitHeight: 30
    color: Config.colors.bg

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

        Wifi {}
        Bluetooth {}
        Battery {}
        Clock {}
    }
}
