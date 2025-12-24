pragma Singleton

import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Io

Singleton {
   id: root

   property int cpuUsage: 0
   property real prevIdle: 0
   property real prevTotal: 0

   function getCpuStats() {
      getCpuStatsProc.running = true
   }

   Process {
      id: getCpuStatsProc
      command: ["sh", "-c", "head -1 /proc/stat"]
      environment: ({ LANG: "C", LC_ALL: "C" })
      stdout: StdioCollector {
         onStreamFinished: {
               // Parse: cpu user nice system idle iowait irq softirq steal
               const parts = text.trim().split(/\s+/)
               if (parts.length >= 5) {
                  const user = parseFloat(parts[1])
                  const nice = parseFloat(parts[2])
                  const system = parseFloat(parts[3])
                  const idle = parseFloat(parts[4])
                  const iowait = parseFloat(parts[5]) || 0
                  const irq = parseFloat(parts[6]) || 0
                  const softirq = parseFloat(parts[7]) || 0
                  const steal = parseFloat(parts[8]) || 0

                  const totalIdle = idle + iowait
                  const total = user + nice + system + idle + iowait + irq + softirq + steal

                  if (root.prevTotal > 0) {
                     const diffIdle = totalIdle - root.prevIdle
                     const diffTotal = total - root.prevTotal
                     if (diffTotal > 0) {
                           root.cpuUsage = Math.round(100 * (1 - diffIdle / diffTotal))
                     }
                  }

                  root.prevIdle = totalIdle
                  root.prevTotal = total
               }
         }
      }
   }
}
