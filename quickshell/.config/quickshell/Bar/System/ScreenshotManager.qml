pragma Singleton

import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Io

Singleton {
   id: root

   function takeRegionScreenshot() {
      launchRegionScreenshotProc.running = true
   }

   function takeFullscreenScreenshot() {
      launchFullscreenScreenshotProc.running = true
   }

   Process {
       id: launchRegionScreenshotProc
       command: ["hyprshot", "-m", "region"]
       environment: ({ LANG: "C", LC_ALL: "C" })
   }
   Process {
       id: launchFullscreenScreenshotProc
       command: ["hyprshot", "-m", "output"]
       environment: ({ LANG: "C", LC_ALL: "C" })
   }

}
