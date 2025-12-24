pragma Singleton

import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Io

Singleton {
   id: root

   property int volume: 0
   property bool isMuted: false


   Component.onCompleted: {
      getMicStatus.running = true
   }

   Process {
      id: getMicStatus
      command: ["sh", "-c", "wpctl get-volume @DEFAULT_AUDIO_SOURCE@"]
      environment: ({ LANG: "C", LC_ALL: "C" })
      stdout: StdioCollector {
         onStreamFinished: {
               root.isMuted = text.includes("[MUTED]")
               const parts = text.trim().split(" ")
               if (parts.length >= 2) {
                  const vol = parseFloat(parts[1]) * 100
                  root.volume = Math.round(vol)
               }
         }
      }
   }

   function toggleMute(): void {
      toggleMuteProc.running = true
   }

   Process {
      id: toggleMuteProc
      command: ["wpctl", "set-mute", "@DEFAULT_AUDIO_SOURCE@", "toggle"]
      onExited: {
         getMicStatus.running = true
      }
   }

   function volumeUp(): void {
      volumeUpProc.running = true
   }

   Process {
      id: volumeUpProc
      command: ["wpctl", "set-volume", "-l", "1.5", "@DEFAULT_AUDIO_SOURCE@", "5%+"]
      onExited: {
         getMicStatus.running = true
      }
   }

   function volumeDown(): void {
      volumeDownProc.running = true
   }

   Process {
      id: volumeDownProc
      command: ["wpctl", "set-volume", "@DEFAULT_AUDIO_SOURCE@", "5%-"]
      onExited: {
         getMicStatus.running = true
      }
   }

   Timer {
      interval: 2000
      running: true
      repeat: true
      onTriggered: {
         getMicStatus.running = true
      }
   }


}
