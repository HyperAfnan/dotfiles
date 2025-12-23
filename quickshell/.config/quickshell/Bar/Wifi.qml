import QtQuick
import QtQuick.VectorImage
import QtQuick.Layouts
import Quickshell
import Quickshell.Wayland
import "./System" as System

Item {
    id: root

    Layout.alignment: Qt.AlignVCenter

    implicitWidth: Config.sizes.scale
    implicitHeight: Config.sizes.scale
    visible: true

    property bool isHovered: false
    property var globalPos: root.mapToGlobal(root.width / 2, root.height)

    readonly property bool wifiEnabled: System.NetworkManager.wifiEnabled
    readonly property string networkName:
        System.NetworkManager.active ? System.NetworkManager.active.ssid : "Not connected"
    readonly property int networkStrength:
        System.NetworkManager.active ? System.NetworkManager.active.strength : 0

    readonly property string networkIcon:
        !wifiEnabled ? "off" :
        networkStrength > 90 ? "100" :
        networkStrength > 66 ? "66"  :
        networkStrength > 33 ? "33"  : "0"

    readonly property string iconPath:
        wifiEnabled
            ? Quickshell.shellDir + "/../Icons/wifi/nm-signal-" + networkIcon + "-symbolic.svg"
            : Quickshell.shellDir + "/../Icons/wifi/wifi-off.svg"


    VectorImage {
        id: rWifi
        anchors.verticalCenter: parent.verticalCenter
        anchors.horizontalCenter: parent.horizontalCenter
        width: Config.sizes.larger
        height: Config.sizes.larger
        source: Qt.resolvedUrl(root.iconPath)
        preferredRendererType: VectorImage.CurveRenderer
        transform: Translate { y : -4 }

        opacity: root.isHovered ? 0.7 : 1.0
        scale: root.isHovered ? 1.7 : 1.5

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
    }
}
