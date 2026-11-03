import QtQuick
import qs.theme

// "-- output ------------------" divider inside popups
Item {
    property string text: ""
    width: parent ? parent.width : 0
    height: Theme.fontHeight + 6
    BarText { id: t; y: 4; text: parent.text; color: Theme.dim }
    Rectangle {
        anchors { left: t.right; leftMargin: 8; right: parent.right; verticalCenter: t.verticalCenter }
        height: 1
        color: Theme.border
    }
}
