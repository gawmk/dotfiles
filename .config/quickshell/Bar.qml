import Quickshell
import QtQuick
import QtQuick.Layouts
import qs.theme
import qs.widgets

PanelWindow {
    id: bar
    required property var modelData
    screen: modelData

    anchors { top: true; left: true; right: true }
    implicitHeight: Theme.barHeight
    color: Theme.bg

    // left: tags, layout, title
    RowLayout {
        anchors { left: parent.left; verticalCenter: parent.verticalCenter; leftMargin: 8 }
        spacing: Theme.spacing
        Tags { screen: bar.screen }
        WindowTitle {
            screen: bar.screen
            Layout.maximumWidth: bar.width / 2 - 260
        }
    }

    // center: clock
    Clock {
        anchors.centerIn: parent
        barWindow: bar
    }

    // right: status widgets
    RowLayout {
        anchors { right: parent.right; verticalCenter: parent.verticalCenter; rightMargin: 12 }
        spacing: Theme.spacing
        Tray { barWindow: bar }
        Stats { barWindow: bar }
        Network { barWindow: bar }
        Audio { barWindow: bar }
        Battery {}
    }
}
