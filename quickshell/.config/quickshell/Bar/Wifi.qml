import QtQuick
import QtQuick.VectorImage
import QtQuick.Layouts
import Quickshell
import Quickshell.Io
import Quickshell.Wayland
import "./System" as System

Item {
    id: root
    Layout.alignment: Qt.AlignVCenter
    Layout.fillHeight: true
    implicitWidth: contentRow.width
    visible: true

    property bool isHovered: false
    readonly property bool wifiEnabled: System.NetworkManager.wifiEnabled
    readonly property int networkStrength: System.NetworkManager.active ? System.NetworkManager.active.strength : 0
    readonly property string networkIcon: !wifiEnabled ? "off" : networkStrength > 90 ? "100" : networkStrength > 66 ? "66"  : networkStrength > 33 ? "33"  : "0"
    readonly property string iconPath: wifiEnabled ? Quickshell.shellDir + "/../Icons/wifi/nm-signal-" + networkIcon + "-symbolic.svg" : Quickshell.shellDir + "/../Icons/wifi/wifi-off.svg"

    Row {
        id: contentRow
        anchors.centerIn: parent
        anchors.horizontalCenter: parent.horizontalCenter
        spacing: 4

        Text {
            id: speedText
            anchors.verticalCenter: parent.verticalCenter
            text: System.NetworkManager.wifiEnabled ? System.NetworkManager.downloadSpeedText == "0 B/s" ?  "" :  System.NetworkManager.downloadSpeedText: ""
            color: Config.colors.fg
            font.family: Config.font.family
            opacity: 1.0
            font.pixelSize: Config.font.size - 2
            visible: false
        }

        VectorImage {
            id: wifiIcon
            anchors.verticalCenter: parent.verticalCenter
            width: Config.sizes.larger
            height: Config.sizes.larger
            source: Qt.resolvedUrl(root.iconPath)
            preferredRendererType: VectorImage.CurveRenderer
            opacity: root.isHovered ? 0.5 : 1.0
            scale: root.isHovered ? 1.7 : 1.5

            Behavior on opacity {
                NumberAnimation { duration: 150 }
            }
            Behavior on scale {
                NumberAnimation { duration: 150 }
            }
            transform: Translate { y: -4}
        }

    }

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        onEntered: { root.isHovered = true }
        onExited: { root.isHovered = false }
        acceptedButtons: Qt.LeftButton | Qt.RightButton
         onClicked: (mouse) => {
             if (mouse.button === Qt.LeftButton) {
                    System.NetworkManager.toggleGUI()
              }
         }
    }
}
