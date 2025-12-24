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

   Row {
       id: contentRow
       anchors.centerIn: parent
       anchors.horizontalCenter: parent.horizontalCenter
       spacing: 4

       Text {
           id: screenshotIcon
           anchors.verticalCenter: parent.verticalCenter
           text: "⛶"
           color: Config.colors.fg
           font.family: Config.font.family
           opacity: root.isHovered ? 0.5 : 1.0
           font.pixelSize: Config.font.size
           scale: root.isHovered ? 1.2 : 1.4

           MouseArea {
              anchors.fill: parent
              acceptedButtons: Qt.LeftButton | Qt.RightButton
              onClicked: (mouse) => {
                 if (mouse.button === Qt.LeftButton) {
                     System.ScreenshotManager.takeRegionScreenshot()
                   } else if (mouse.button === Qt.RightButton) {
                     System.ScreenshotManager.takeFullscreenScreenshot()
                  }
              }
              hoverEnabled: true
              onEntered: { root.isHovered = true }
              onExited: { root.isHovered = false }
           }
       }
   }
}
