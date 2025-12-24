import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Io
import "./System" as System

Item {
    id: root

    Layout.alignment: Qt.AlignVCenter
    Layout.fillHeight: true
    implicitWidth: contentRow.width
    visible: true

    property bool isHovered: false
    property bool expanded: false
    property int cpuUsage: System.CPU.cpuUsage
    property int memUsage: System.Memory.memUsage
    property int gpu1Usage: System.GPU.gpu1Usage
    property int gpu2Usage: System.GPU.gpu2Usage
    property real prevIdle: System.CPU.prevIdle
    property real prevTotal: System.CPU.prevTotal

    Component.onCompleted: {
        System.CPU.getCpuStats()
        System.Memory.getMemStats()
        System.GPU.getGpu1Stats()
        System.GPU.getGpu2Stats()
    }

    Timer {
        interval: 1500
        running: true
        repeat: true
        onTriggered: {
            System.CPU.getCpuStats()
            System.Memory.getMemStats()
            System.GPU.getGpu1Stats()
            System.GPU.getGpu2Stats()
        }
    }

    Row {
        id: contentRow
        anchors.centerIn: parent
        spacing: 8

        Row {
            id: statsContent
            spacing: 8
            clip: true
            width: root.expanded ? statsContentInner.width : 0
            opacity: root.expanded ? 1.0 : 0.0

            Behavior on width {
                NumberAnimation { duration: 250; easing.type: Easing.OutCubic }
            }
            Behavior on opacity {
                NumberAnimation { duration: 200 }
            }

            Row {
                id: statsContentInner
                spacing: 12

                // CPU Stat
                Column {
                    spacing: 0

                    Text {
                        text: "CPU"
                        color: Config.colors.muted
                        font.family: Config.font.family
                        font.pixelSize: Config.font.size - 4
                        horizontalAlignment: Text.AlignHCenter
                        anchors.horizontalCenter: parent.horizontalCenter
                    }

                    Text {
                        text: root.cpuUsage + "%"
                        color: root.cpuUsage > 80 ? Config.colors.destructive :
                               root.cpuUsage > 50 ? Config.colors.accent : Config.colors.fg
                        font.family: Config.font.family
                        font.pixelSize: Config.font.size
                        font.bold: true
                        horizontalAlignment: Text.AlignHCenter
                        anchors.horizontalCenter: parent.horizontalCenter
                    }
                }

                // Memory Stat
                Column {
                    spacing: 0

                    Text {
                        text: "RAM"
                        color: Config.colors.muted
                        font.family: Config.font.family
                        font.pixelSize: Config.font.size - 4
                        horizontalAlignment: Text.AlignHCenter
                        anchors.horizontalCenter: parent.horizontalCenter
                    }

                    Text {
                        text: root.memUsage + "%"
                        color: root.memUsage > 80 ? Config.colors.destructive :
                               root.memUsage > 60 ? Config.colors.accent : Config.colors.fg
                        font.family: Config.font.family
                        font.pixelSize: Config.font.size
                        font.bold: true
                        horizontalAlignment: Text.AlignHCenter
                        anchors.horizontalCenter: parent.horizontalCenter
                    }
                }

                // GPU1 Stat
                Column {
                    spacing: 0

                    Text {
                        text: "GPU1"
                        color: Config.colors.muted
                        font.family: Config.font.family
                        font.pixelSize: Config.font.size - 4
                        horizontalAlignment: Text.AlignHCenter
                        anchors.horizontalCenter: parent.horizontalCenter
                    }

                    Text {
                        text: root.gpu1Usage + "%"
                        color: root.gpu1Usage > 80 ? Config.colors.destructive :
                               root.gpu1Usage > 50 ? Config.colors.accent : Config.colors.fg
                        font.family: Config.font.family
                        font.pixelSize: Config.font.size
                        font.bold: true
                        horizontalAlignment: Text.AlignHCenter
                        anchors.horizontalCenter: parent.horizontalCenter
                    }
                }

                // GPU2 Stat
                Column {
                    spacing: 0

                    Text {
                        text: "GPU2"
                        color: Config.colors.muted
                        font.family: Config.font.family
                        font.pixelSize: Config.font.size - 4
                        horizontalAlignment: Text.AlignHCenter
                        anchors.horizontalCenter: parent.horizontalCenter
                    }

                    Text {
                        text: root.gpu2Usage
                        color: root.gpu2Usage > 25 ? Config.colors.destructive :
                               root.gpu2Usage > 60 ? Config.colors.accent : Config.colors.fg
                        font.family: Config.font.family
                        font.pixelSize: Config.font.size
                        font.bold: true
                        horizontalAlignment: Text.AlignHCenter
                        anchors.horizontalCenter: parent.horizontalCenter
                    }
                }
            }
        }

        Text {
            id: toggleIcon
            anchors.verticalCenter: parent.verticalCenter
            text: "󰅂"
            color: Config.colors.fg
            font.family: Config.font.family
            font.pixelSize: Config.sizes.normal

            rotation: root.expanded ? 0 : 180
            opacity: root.isHovered ? 0.7 : 1.0
            scale: root.isHovered ? 1.1 : 1.3

            Behavior on rotation {
                NumberAnimation { duration: 250; easing.type: Easing.OutCubic }
            }
            Behavior on opacity {
                NumberAnimation { duration: 150 }
            }
            Behavior on scale {
                NumberAnimation { duration: 150 }
            }
        }
    }

   MouseArea {
      id: mouseArea
      anchors.fill: parent
      hoverEnabled: true
      cursorShape: Qt.PointingHandCursor

      onEntered: { root.isHovered = true }
      onExited: { root.isHovered = false }

      onClicked: {
         root.expanded = !root.expanded
      }
   }
}
