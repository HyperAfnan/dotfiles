import QtQuick 
import Quickshell
import QtQuick.Layouts
    Canvas {
        id: notch
        width: 270
        height: parent.height
        anchors.horizontalCenter: parent.horizontalCenter
        z: 1

        property real curveRadius: 15
        property real notchWidth: 230

        onPaint: {
            var ctx = getContext("2d");
            ctx.reset();
            ctx.fillStyle = Config.colors.black;

            var r = curveRadius;
            var startX = (width - notchWidth) / 2;
            var endX = (width + notchWidth) / 2;

            ctx.beginPath();
            ctx.moveTo(0, 0);
            ctx.lineTo(startX - r, 0);
            ctx.quadraticCurveTo(startX, 0, startX, r);
            ctx.lineTo(startX, height - r);
            ctx.quadraticCurveTo(startX, height, startX + r, height);
            ctx.lineTo(endX - r, height);
            ctx.quadraticCurveTo(endX, height, endX, height - r);
            ctx.lineTo(endX, r);
            ctx.quadraticCurveTo(endX, 0, endX + r, 0);
            ctx.lineTo(width, 0);
            ctx.closePath();
            ctx.fill();
        }
        Component.onCompleted: requestPaint()
    }

