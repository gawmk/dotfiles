import Quickshell
import QtQuick
import qs.theme

// Rounded popup hanging under a bar widget. Put content inside; it is laid
// out in a Column. Toggle with `visible`.
PopupWindow {
    id: popup
    required property var barWindow
    required property Item anchorItem
    default property alias content: column.data
    property int padding: 14

    anchor.window: barWindow
    anchor.rect.x: {
        const p = anchorItem.mapToItem(barWindow.contentItem, 0, 0);
        const x = p.x + anchorItem.width / 2 - width / 2;
        return Math.max(6, Math.min(x, barWindow.width - width - 6));
    }
    anchor.rect.y: barWindow.height + 6

    implicitWidth: column.implicitWidth + padding * 2
    implicitHeight: column.implicitHeight + padding * 2
    color: "transparent"

    Rectangle {
        anchors.fill: parent
        radius: Theme.radius
        color: Theme.bg
        border.color: Theme.border
        border.width: 1

        Column {
            id: column
            anchors.centerIn: parent
            spacing: 8
        }
    }
}
