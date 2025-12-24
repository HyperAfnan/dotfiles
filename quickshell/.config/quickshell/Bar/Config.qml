pragma Singleton

import QtQuick
import Quickshell
import "./System" as System

QtObject {
  id: root

  property QtObject font
  property QtObject colors
  property QtObject radius
  property QtObject spacing
  property QtObject sizes
  property QtObject ui

  ui : QtObject {
    property bool showNotch: true
  }

  font: QtObject {
    property string family: Fonts.sFProRounded.family
    property int size: 14
    property bool bold: true
    property bool nobold: false
  }

  colors: QtObject {
    property color bg: System.PywalColors.bgWithAlpha(0.7)

    property string fg: System.PywalColors.foreground
    property string muted: System.PywalColors.color8
    property string bright: System.PywalColors.color7
    property string accent: System.PywalColors.color4
    property string light: System.PywalColors.color7

    property string success: System.PywalColors.color2
    property string primary: System.PywalColors.color4
    property string secondary: System.PywalColors.color5
    property string destructive: System.PywalColors.color1

    property string batteryText: System.PywalColors.color0
    property string black: "#000000"
  }

  radius: QtObject {
    property real scale: 1
    property int small: 4 * scale
    property int normal: 8 * scale
    property int large: 16 * scale
    property int full: 1000 * scale
  }

  spacing: QtObject {
    property real scale: 1
    property int extraSmall: 2 * scale
    property int small: 4 * scale
    property int normal: 12 * scale
    property int large: 16 * scale
    property int extraLarge: 24 * scale
  }

  sizes: QtObject {
    property real scale: 1
    property int small: 11 * scale
    property int smaller: 12 * scale
    property int normal: 13 * scale
    property int larger: 15 * scale
    property int large: 20 * scale
    property int extraLarge: 28 * scale
  }
}
