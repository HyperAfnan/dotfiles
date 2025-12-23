import QtQuick
import QtQuick.Layouts

Text {
    id: clock
    color: Config.colors.fg
    text: Qt.formatDateTime(new Date(), "ddd dd MMM hh:mm AP")
    Layout.alignment: Qt.AlignVCenter

    font {
        family: Config.font.family
        pixelSize: Config.font.size
        bold: Config.font.nobold
    }

    Timer {
        interval: 60 * 1000
        running: true
        repeat: true
        onTriggered: {
            clock.text = Qt.formatDateTime( new Date(), "ddd dd MMM hh:mm AP")
        }
    }
}
