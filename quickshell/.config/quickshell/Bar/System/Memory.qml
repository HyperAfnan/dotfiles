
pragma Singleton

import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Io

Singleton {
   id: root

   property int memUsage: 0

   function getMemStats() {
      getMemStats.running = true
   }

   Process {
      id: getMemStats
      command: ["sh", "-c", "free | grep Mem"]
      environment: ({ LANG: "C", LC_ALL: "C" })
      stdout: StdioCollector {
         onStreamFinished: {
               // Parse: Mem: total used free shared buff/cache available
               const parts = text.trim().split(/\s+/)
               if (parts.length >= 3) {
                  const total = parseFloat(parts[1])
                  const used = parseFloat(parts[2])
                  if (total > 0) {
                     root.memUsage = Math.round((used / total) * 100)
                  }
               }
         }
      }
   }

}
