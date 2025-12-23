pragma Singleton

import QtQuick
import Quickshell
import "./System" as System

QtObject {
  id: root

  property QtObject colors
  property QtObject radius
  property QtObject spacing
  property QtObject padding
  property QtObject sizes
  property QtObject durations
  property QtObject transparency
  property QtObject font

  font: QtObject {
    property string family: Fonts.sFProRounded.family
    property int size: 14
    property bool bold: true
    property bool nobold: false
  }

  colors: QtObject {
    // Background with 80% opacity using pywal background color
    property color bg: System.PywalColors.bgWithAlpha(0.8)

    // Pywal-based colors
    property string fg: System.PywalColors.foreground
    property string muted: System.PywalColors.color8
    property string bright: System.PywalColors.color7
    property string accent: System.PywalColors.color4
    property string light: System.PywalColors.color7

    // Semantic colors from pywal palette
    property string success: System.PywalColors.color2
    property string primary: System.PywalColors.color4
    property string secondary: System.PywalColors.color5
    property string destructive: System.PywalColors.color1

    // Battery text should contrast with success color
    property string batteryText: System.PywalColors.color0
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

  padding: QtObject {
    property real scale: 1
    property int extraSmall: 5 * scale
    property int small: 7 * scale
    property int normal: 10 * scale
    property int large: 12 * scale
    property int extraLarge: 15 * scale
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

  durations: QtObject {
    property real scale: 1
    property int extraFast: 100 * scale
    property int fast: 200 * scale
    property int normal: 400 * scale
    property int slow: 600 * scale
    property int extraSlow: 1000 * scale
  }

  transparency: QtObject {
    property bool enabled: true
    property real base: 0.8
    property real layers: 0.4
  }
}
