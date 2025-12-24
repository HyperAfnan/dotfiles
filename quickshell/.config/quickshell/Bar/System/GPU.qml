pragma Singleton

import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Io

Singleton {
   id: root

   property int gpu1Usage: 0;
   property int gpu2Usage: 0;

   function getGpu1Stats() {
      getGpu1StatsProc.running = true
   }

   function getGpu2Stats() {
      getGpu2StatsProc.running = true
   }

   Process {
      id: getGpu1StatsProc
      command: [ "sh", "-c", "intel_gpu_top -J -s 1000 2>/dev/null \ | awk 'BEGIN{c=0}{print;if($0~/^{/)c++;if($0~/^}/&&c>0)exit}' \ | jq '(.engines[\"Render/3D\"].busy | round)'" ]
      environment: ({ LANG: "C", LC_ALL: "C" })
      stdout: StdioCollector {
         onStreamFinished: {
               const usage = parseInt(text.trim())
               root.gpu1Usage = isNaN(usage) ? 0 : usage
         }
      }
   }

   Process {
      id: getGpu2StatsProc
      command: ["sh", "-c", "nvidia-smi --query-gpu=power.draw --format=csv,noheader,nounits"]
      environment: ({ LANG: "C", LC_ALL: "C" })
      stdout: StdioCollector {
         onStreamFinished: {
               const power = parseFloat(text)
               root.gpu2Usage = power
         }
      }
   }

}
