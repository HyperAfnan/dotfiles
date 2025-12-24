import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Io
import "./System" as System

Item {
    id: root

    Layout.alignment: Qt.AlignVCenter
    Layout.fillHeight: true
    implicitWidth: Config.sizes.large
    visible: true

    property bool isHovered: false
    property bool isMuted: System.Mic.isMuted
    property bool volume: System.Mic.volume
    readonly property string micIcon: isMuted ? "󰍭" : "󰍬"

    Text {
        id: microphoneIcon
        anchors.verticalCenter: parent.verticalCenter
        anchors.horizontalCenter: parent.horizontalCenter
        text: root.micIcon
        color: root.isMuted ? Config.colors.destructive : Config.colors.fg
        font.family: Config.font.family
        font.pixelSize: Config.sizes.normal

        opacity: root.isHovered ? 0.7 : 1.0
        scale: root.isHovered ? 1.1 : 1.3

        Behavior on opacity {
            NumberAnimation { duration: 150 }
        }
        Behavior on scale {
            NumberAnimation { duration: 150 }
        }
    }

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor

        onEntered: { root.isHovered = true }
        onExited: { root.isHovered = false }

        acceptedButtons: Qt.LeftButton
        onClicked: System.Mic.toggleMute()

        onWheel: (wheel) => {
            if (wheel.angleDelta.y > 0) {
               System.Mic.volumeUp()
            } else {
               System.Mic.volumeDown()
            }
        }
    }
}
