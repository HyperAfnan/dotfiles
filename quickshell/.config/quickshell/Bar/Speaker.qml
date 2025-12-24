import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import Quickshell
import Quickshell.Io
import Quickshell.Wayland
import "./System" as System

Item {
    id: root

    Layout.alignment: Qt.AlignVCenter
    Layout.fillHeight: true
    implicitWidth: Config.sizes.large
    visible: true

    Text {
        id: speakerIcon
        anchors.verticalCenter: parent.verticalCenter
        anchors.horizontalCenter: parent.horizontalCenter
        text: System.Speaker.volumeIcon
        color: System.Speaker.isMuted ? Config.colors.muted : Config.colors.fg
        font.family: Config.font.family
        font.pixelSize: Config.sizes.normal

        opacity: System.Speaker.isHovered ? 0.7 : 1.0
        scale: System.Speaker.isHovered ? 1.1 : 1.3
    }

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor

        onEntered: { System.Speaker.isHovered = true }
        onExited: { System.Speaker.isHovered = false }

        acceptedButtons: Qt.LeftButton | Qt.RightButton

        onClicked: (mouse) => System.Speaker.onClicked(mouse)
        onWheel: (wheel) => System.Speaker.onWheel(wheel)
    }

   LazyLoader {
      id: menuLoader
      active: System.Speaker.menuOpen

      PanelWindow {
         id: contextMenu
         visible: System.Speaker.menuOpen
         color: "transparent"

         screen: Quickshell.screens[0]

         anchors.top: true
         anchors.left: true
         margins.top: 35
         margins.left: root.mapToGlobal(root.width / 2, 0).x - 125

         implicitWidth: 280
         implicitHeight: menuContent.height + 20

         WlrLayershell.namespace: "quickshell-popup"
         WlrLayershell.layer: WlrLayer.Overlay

         WlrLayershell.keyboardFocus: WlrKeyboardFocus.OnDemand


         Shortcut {
               sequence: "Escape"
               onActivated: System.Speaker.menuOpen = false
         }

         Rectangle {
               anchors.fill: parent
               color: Config.colors.bg
               radius: Config.radius.normal
               border.color: Config.colors.accent
               border.width: 1

               Column {
                  id: menuContent
                  anchors.left: parent.left
                  anchors.right: parent.right
                  anchors.top: parent.top
                  anchors.margins: 10
                  spacing: 12

                  Row {
                     width: parent.width
                     spacing: 10

                     Text {
                           id: muteButton
                           anchors.verticalCenter: parent.verticalCenter
                           text: System.Speaker.volumeIcon
                           color: System.Speaker.isMuted ? Config.colors.muted : Config.colors.fg
                           font.family: Config.font.family
                           font.pixelSize: Config.font.size + 2

                           MouseArea {
                              anchors.fill: parent
                              cursorShape: Qt.PointingHandCursor
                              onClicked: System.Speaker.mute()
                           }
                     }

                     Rectangle {
                           id: sliderTrack
                           width: parent.width - muteButton.width - volumeText.width - 20
                           height: 6
                           radius: 3
                           color: Config.colors.muted
                           anchors.verticalCenter: parent.verticalCenter

                           Rectangle {
                              width: parent.width * (System.Speaker.volume / 100)
                              height: parent.height
                              radius: parent.radius
                              color: System.Speaker.isMuted ? Config.colors.muted : Config.colors.accent
                           }

                           Rectangle {
                              id: sliderHandle
                              width: 14
                              height: 14
                              radius: 7
                              color: System.Speaker.isMuted ? Config.colors.muted : Config.colors.fg
                              x: (parent.width * (System.Speaker.volume / 100)) - 7
                              anchors.verticalCenter: parent.verticalCenter
                           }

                           MouseArea {
                              anchors.fill: parent
                              anchors.margins: -5
                              cursorShape: Qt.PointingHandCursor
                              onClicked: (mouse) => System.Speaker.setVolumeLevel(mouse, parent)
                              onPositionChanged: (mouse) => System.Speaker.onPositionChange(mouse, parent)                            
                           }
                     }

                     Text {
                           id: volumeText
                           anchors.verticalCenter: parent.verticalCenter
                           text: System.Speaker.volume + "%"
                           color: Config.colors.fg
                           font.family: Config.font.family
                           font.pixelSize: Config.font.size - 2
                           width: 35
                           horizontalAlignment: Text.AlignRight
                     }
                  }

                  Rectangle {
                     width: parent.width
                     height: 1
                     color: Config.colors.muted
                  }

                  // Device selector
                  Repeater {
                     model: System.Speaker.audioSinks

                     Rectangle {
                           width: menuContent.width
                           height: 32
                           radius: Config.radius.small
                           color: deviceMouse.containsMouse ? Config.colors.accent : (modelData.isDefault ? Config.colors.muted : "transparent")

                           Row {
                              anchors.fill: parent
                              anchors.leftMargin: 8
                              anchors.rightMargin: 8
                              spacing: 8

                              Text {
                                 anchors.verticalCenter: parent.verticalCenter
                                 text: modelData.isDefault ? "󰓃" : "󰓄"
                                 color: modelData.isDefault ? Config.colors.success : Config.colors.fg
                                 font.family: Config.font.family
                                 font.pixelSize: Config.font.size
                              }

                              Text {
                                 anchors.verticalCenter: parent.verticalCenter
                                 text: modelData.name
                                 color: Config.colors.fg
                                 font.family: Config.font.family
                                 font.pixelSize: Config.font.size - 2
                                 elide: Text.ElideRight
                                 width: parent.width - 40
                              }
                           }

                           MouseArea {
                              id: deviceMouse
                              anchors.fill: parent
                              hoverEnabled: true
                              cursorShape: Qt.PointingHandCursor
                              onClicked: () => System.Speaker.setAudioSink(modelData.id )
                           }
                     }
                  }
               }
         }
      }
   }
}
