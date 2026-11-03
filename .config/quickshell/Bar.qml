import Quickshell
import QtQuick
import qs.theme
import qs.widgets

PanelWindow {
    id: bar
    required property var modelData
    screen: modelData

    anchors { top: true; left: true; right: true }
    implicitHeight: Theme.barHeight
    color: Theme.bg

    // left: tags, layout symbol, title (title stops before the clock)
    Row {
        id: left
        anchors { left: parent.left; top: parent.top; bottom: parent.bottom }
        Tags { screen: bar.screen; height: parent.height }
        WindowTitle {
            screen: bar.screen
            height: parent.height
            width: Math.max(0, clock.x - left.x - x - Theme.lrpad)
        }
    }

    // centre: date/time
    Clock {
        id: clock
        barWindow: bar
        anchors.centerIn: parent
        height: parent.height
    }

    // right: tray + status text
    Row {
        anchors { right: parent.right; top: parent.top; bottom: parent.bottom; rightMargin: Theme.lrpad / 2 }
        Tray { barWindow: bar; height: parent.height }
        Stats { barWindow: bar; height: parent.height }
        BluetoothStatus { barWindow: bar; height: parent.height }
        Network { barWindow: bar; height: parent.height }
        Audio { barWindow: bar; height: parent.height }
        Battery { barWindow: bar; height: parent.height }
    }
}
