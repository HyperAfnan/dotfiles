import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell
import Quickshell.Hyprland

RowLayout {
    spacing: Config.spacing.small
    Layout.alignment: Qt.AlignVCenter
        Repeater {
            model: 9

            Text {
                property var ws: Hyprland.workspaces.values.find( w => w.id === index + 1)
                property bool isActive: Hyprland.focusedWorkspace?.id === (index + 1)
                property bool beingHovered: false

                text: index + 1
                color: Config.colors.fg
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
     }
