pragma Singleton

import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import Quickshell
import Quickshell.Io
import Quickshell.Wayland

Singleton { 

    id: root

    property bool isHovered: false
    property bool menuOpen: false
    property bool isMuted: false
    property int volume: 0
    property var audioSinks: []
    property string defaultSink: ""

    readonly property string volumeIcon: {
        if (isMuted || volume === 0) {
            return "󰝟"
        } else if (volume < 50) {
            return "󰖀"
        } else {
            return "󰕾"
        }
    }

    Component.onCompleted: {
        getVolume.running = true
        getAudioSinks.running = true
    }

    function onClicked(mouse) {
        if (mouse.button === Qt.LeftButton) {
            toggleMute.running = true
        } else if (mouse.button === Qt.RightButton) {
            root.menuOpen = !root.menuOpen
        }
    }

    function onWheel(wheel) {
         if (wheel.angleDelta.y > 0) {
               volumeUp.running = true
         } else {
               volumeDown.running = true
         }
    }

    function mute() {
        toggleMute.running = true
    }

    function onPositionChange(mouse, parent) {
               var newVol = Math.max(0, Math.min(100, Math.round((mouse.x / parent.width) * 100)))
               setVolume.volValue = newVol / 100
               setVolume.running = true
    }

    function setVolumeLevel(mouse, parent) {
        var newVol = Math.max(0, Math.min(100, Math.round((mouse.x / parent.width) * 100)))
        setVolume.volValue = newVol / 100
        setVolume.running = true
    }

    function setAudioSink(sinkId) {
        setSink.sinkId = sinkId
        setSink.running = true
    }

   Process {
      id: getVolume
      command: ["sh", "-c", "wpctl get-volume @DEFAULT_AUDIO_SINK@"]
      environment: ({ LANG: "C", LC_ALL: "C" })
      stdout: StdioCollector {
         onStreamFinished: {
               const parts = text.trim().split(" ")
               if (parts.length >= 2) {
                  const vol = parseFloat(parts[1]) * 100
                  root.volume = Math.round(vol)
                  root.isMuted = text.includes("[MUTED]")
               }
         }
      }
   }

   Process {
      id: toggleMute
      command: ["wpctl", "set-mute", "@DEFAULT_AUDIO_SINK@", "toggle"]
      onExited: {
         getVolume.running = true
      }
   }

   Process {
      id: volumeUp
      command: ["wpctl", "set-volume", "-l", "1.0", "@DEFAULT_AUDIO_SINK@", "5%+"]
      onExited: {
         getVolume.running = true
      }
   }

   Process {
      id: volumeDown
      command: ["wpctl", "set-volume", "@DEFAULT_AUDIO_SINK@", "5%-"]
      onExited: {
         getVolume.running = true
      }
   }

   Timer {
      interval: 2000
      running: true
      repeat: true
      onTriggered: {
         getVolume.running = true
         getAudioSinks.running = true
      }
   }

   Process {
      id: getAudioSinks
      command: ["sh", "-c", "wpctl status | sed -n '/Sinks:/,/Sources:/p' | head -n -2 | tail -n +2"]
      environment: ({ LANG: "C", LC_ALL: "C" })
      stdout: StdioCollector {
         onStreamFinished: {
               const lines = text.trim().split("\n").filter(line => line.trim().length > 0)
               var sinks = []
               for (const line of lines) {
                  const isDefault = line.includes("*")
                  const match = line.match(/(\d+)\.\s+(.+?)(?:\s+\[vol:|$)/)
                  if (match) {
                     const id = match[1]
                     const name = match[2].trim()
                     sinks.push({
                           id: id,
                           name: name,
                           isDefault: isDefault
                     })
                     if (isDefault) {
                           root.defaultSink = id
                     }
                  }
               }
               root.audioSinks = sinks
         }
      }
   }

   Process {
      id: setSink
      property string sinkId: ""
      command: ["wpctl", "set-default", sinkId]
      onExited: {
         getAudioSinks.running = true
         getVolume.running = true
      }
   }

   Process {
      id: setVolume
      property real volValue: 0.5
      command: ["wpctl", "set-volume", "-l", "1.0", "@DEFAULT_AUDIO_SINK@", Math.min(volValue, 1.0).toString()]
      onExited: {
         getVolume.running = true
      }
   }
 }
