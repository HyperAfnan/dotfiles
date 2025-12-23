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
    implicitWidth: contentRow.width
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

    property real lastRxBytes: 0
    property real downloadSpeed: 0
    property string downloadSpeedText: formatSpeed(downloadSpeed)

    function formatSpeed(bytesPerSec: real): string {
        if (bytesPerSec < 1024) {
            return Math.round(bytesPerSec) + " B/s";
        } else if (bytesPerSec < 1024 * 1024) {
            return (bytesPerSec / 1024).toFixed(1) + " KB/s";
        } else {
            return (bytesPerSec / (1024 * 1024)).toFixed(1) + " MB/s";
        }
    }

    Timer {
        id: speedTimer
        interval: 1000
        running: root.wifiEnabled
        repeat: true
        onTriggered: speedProcess.running = true
    }

    Process {
        id: speedProcess
        command: ["sh", "-c", "cat /sys/class/net/wl*/statistics/rx_bytes 2>/dev/null | head -1"]
        stdout: SplitParser {
            onRead: data => {
                var currentBytes = parseFloat(data.trim());
                if (root.lastRxBytes > 0) {
                    root.downloadSpeed = currentBytes - root.lastRxBytes;
                }
                root.lastRxBytes = currentBytes;
            }
        }
        Component.onCompleted: running = true
    }


    Row {
        id: contentRow
        anchors.centerIn: parent
        anchors.horizontalCenter: parent.horizontalCenter
        spacing: 4

        Text {
            id: speedText
            anchors.verticalCenter: parent.verticalCenter
            text: root.wifiEnabled ? root.downloadSpeedText : ""
            color: Config.colors.fg
            font.family: Config.font.family
            opacity: 1.0
            font.pixelSize: Config.font.size - 2
            visible: root.wifiEnabled
            width: 40
            horizontalAlignment: Text.AlignRight
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
    }
}
