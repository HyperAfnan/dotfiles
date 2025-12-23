import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell
import Quickshell.Io

Item {
  implicitWidth: text.implicitWidth
  implicitHeight: text.implicitHeight

  property string percentUsed
  anchors.verticalCenter: parent.verticalCenter

  Process {
    id: cpuProc
    command: ["sh", "-c", "top -bn 1 | grep \"%Cpu(s)\" | awk '{usage=100-$8; printf \"%02d%%\\n\", usage}'"]
    running: true

    stdout: SplitParser {
      onRead: data => percentUsed = data
    }
  }

  Timer {
    interval: 2000
    running: true
    repeat: true
    onTriggered: cpuProc.running = true
  }

  Text {
    id: text
      anchors.verticalCenter: parent.verticalCenter
      color: Config.colors.fg
      font {
        family: Config.font.family
        pixelSize: Config.font.size
        bold: Config.font.nobold
      }
      text: "CPU:" + percentUsed 
  }
}
