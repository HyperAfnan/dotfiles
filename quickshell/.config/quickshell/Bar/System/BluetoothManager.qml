pragma Singleton

import QtQuick
import Quickshell
import Quickshell.DBusMenu
import Quickshell.Io

Singleton {
    id: root

    property bool bluetoothEnabled: true
    property bool menuOpen: false

   function toggleBluetooth(): void {
      const cmd = root.bluetoothEnabled ? "off" : "on"
      enableBluetoothProc.exec(["bluetoothctl", "power", cmd])
      root.bluetoothEnabled = !root.bluetoothEnabled
   }

   Process {
      id: enableBluetoothProc
      environment: ({
         LANG: "C",
         LC_ALL: "C"
      })

      stdout: StdioCollector {
         onStreamFinished: {
            checkBluetoothStatus.running = false
            checkBluetoothStatus.running = true
         }
      }
   }

   function checkBluetoothStatus(): void {
      root.checkBluetoothStatus.running = true
   }

   Process {
      id: checkBluetoothStatusProc
      running: true
      command: ["bluetoothctl", "show"]
      environment: ({ LANG: "C", LC_ALL: "C" })
      stdout: StdioCollector {
         onStreamFinished: {
               const powered = text.includes("Powered: yes")
               root.bluetoothEnabled = powered
         }
      }
   }

   Process {
      running: menuOpen
      environment: ({ LANG: "C", LC_ALL: "C" })
      command: ["blueman-manager"]
   }

   Timer {
      interval: 5000
      running: true
      repeat: true
      onTriggered: {
         root.checkBluetoothStatus()
      }
   }

   Component.onCompleted: { root.checkBluetoothStatus.running = true }


}
