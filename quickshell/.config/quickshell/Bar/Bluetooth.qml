import QtQuick
import QtQuick.VectorImage
import QtQuick.Layouts
import Quickshell
import Quickshell.DBusMenu
import Quickshell.Io

Item {
    id: root

    Layout.alignment: Qt.AlignVCenter
    implicitWidth: Config.sizes.large
    implicitHeight: Config.sizes.large
    visible: true

    property bool isHovered: false
    property bool bluetoothEnabled: false
    property string connectedDevice: ""
    property int connectedCount: 0
    property bool menuOpen: false

    Component.onCompleted: { checkBluetoothStatus.running = true }

    Process {
        id: checkBluetoothStatus
        running: true
        command: ["bluetoothctl", "show"]
        environment: ({ LANG: "C", LC_ALL: "C" })
        stdout: StdioCollector {
            onStreamFinished: {
                const powered = text.includes("Powered: yes")
                root.bluetoothEnabled = powered
                if (powered) {
                    getConnectedDevices.running = true
                }
            }
        }
    }

    Process {
        id: getConnectedDevices
        command: ["bluetoothctl", "devices", "Connected"]
        environment: ({
            LANG: "C",
            LC_ALL: "C"
        })
        stdout: StdioCollector {
            onStreamFinished: {
                const lines = text.trim().split("\n").filter(line => line.length > 0)
                root.connectedCount = lines.length
                if (lines.length > 0) {
                    const firstDevice = lines[0]
                    const parts = firstDevice.split(" ")
                    if (parts.length >= 3) {
                        root.connectedDevice = parts.slice(2).join(" ")
                    }
                } else {
                    root.connectedDevice = ""
                }
            }
        }
    }

    Process {
       running: menuOpen
       command: ["blueman-manager"]
    }

    Process {
        running: true
        command: ["bluetoothctl"]
        stdout: SplitParser {
            onRead: {
                checkBluetoothStatus.running = true
            }
        }
    }

    Timer {
        interval: 5000
        running: true
        repeat: true
        onTriggered: {
            checkBluetoothStatus.running = true
        }
    }

    readonly property string iconPath: {
        if (!bluetoothEnabled) {
            return Quickshell.shellDir + "/../Icons/bluetooth/bluetooth-off.svg"
        } else if (connectedCount > 0) {
            return Quickshell.shellDir + "/../Icons/bluetooth/bluetooth.svg"
        } else {
            return Quickshell.shellDir + "/../Icons/bluetooth/bluetooth.svg"
        }
    }

    Text {
        id: btIcon
        anchors.verticalCenter: parent.verticalCenter
        anchors.horizontalCenter: parent.horizontalCenter
        text: !root.bluetoothEnabled ? "󰂲" : "󰂯"
        color: Config.colors.fg
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
        acceptedButtons: Qt.LeftButton | Qt.RightButton
        onClicked: (mouse) => {
           if (mouse.button === Qt.LeftButton) {
               root.menuOpen = !root.menuOpen
           }
           else if (mouse.button === Qt.RightButton) {
               toggleBluetooth.running = true
           }
        }
    }

    Process {
        id: toggleBluetooth
        command: ["bluetoothctl", "power", root.bluetoothEnabled ? "off" : "on"]
        onExited: { checkBluetoothStatus.running = true }
    }
}
