import Quickshell
import Quickshell.Wayland
import Quickshell.Io
import Quickshell.Hyprland
import QtQuick
import QtQuick.Layouts

PanelWindow {
    property int cpuUsage: 0
    property int memUsage: 0
    property var lastCpuIdle: 0
    property var lastCpuTotal: 0

    anchors.top: true
    anchors.left: true
    anchors.right: true

    implicitHeight: 30
    color: Config.colors.bg

    RowLayout {
        anchors.fill: parent
        anchors.leftMargin: 8
        anchors.rightMargin: 8
        spacing: Config.spacing.normal

        // Arch logo
        Text {
            text: "  󰣇 "
            color: Config.colors.fg
            Layout.alignment: Qt.AlignVCenter

            font {
                family: Config.font.family
                pixelSize: Config.font.size
                bold: Config.font.nobold
            }
            MouseArea {
                anchors.fill: parent
                onClicked: Wayland.launchApp("wlogout", [])
                onDoubleClicked: Wayland.launchApp("alacritty", ["-e", "htop"])
                hoverEnabled: true
            }
        }

        WindowTitle {}

        // Workspaces
        Repeater {
            model: 9

            Text {
                property var ws: Hyprland.workspaces.values.find( w => w.id === index + 1)
                property bool isActive: Hyprland.focusedWorkspace?.id === (index + 1)
                property bool beingHovered: false

                text: index + 1
                color: isActive
                    ? Config.colors.fg
                    : Config.colors.fg

                Layout.alignment: Qt.AlignVCenter
                font {
                    family: Config.font.family
                    weight: Hyprland.focusedWorkspace?.id !== index+1 && beingHovered ? 900 : 400
                    pixelSize: isActive ? Config.font.size + 2 : beingHovered ? Config.font.size + 2 : Config.font.size
                    bold: isActive ? Config.font.bold : beingHovered ? Config.font.bold : Config.font.nobold
                }

                MouseArea {
                    anchors.fill: parent
                    onClicked: if (Hyprland.focusedWorkspace?.id !== index+1) Hyprland.dispatch(`workspace ${index+1}`)
                    hoverEnabled: true
                    onEntered: beingHovered = true
                    onExited: beingHovered = false
                }
            }
        }
        Item {
            Layout.fillWidth: true
        }

        Wifi {}
        Bluetooth {}
        Battery {}
        // CPU {}
        Clock {}
    }
}
