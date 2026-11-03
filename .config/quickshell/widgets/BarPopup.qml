import Quickshell
import QtQuick
import qs.theme
import qs.services

// flat panel hanging under the bar: square, 1px border, no animation.
PopupWindow {
    id: popup
    required property var barWindow
    required property Item anchorItem
    property string title: ""
    property string name: title          // for `qs ipc call bar toggle <name>`
    default property alias content: column.data
    readonly property int pad: Math.round(Theme.lrpad / 2)

    function toggle() { visible = !visible; }

    anchor.window: barWindow
    anchor.rect.x: {
        const p = anchorItem.mapToItem(barWindow.contentItem, 0, 0);
        const x = p.x + anchorItem.width / 2 - width / 2;
        return Math.max(0, Math.min(x, barWindow.width - width));
    }
    anchor.rect.y: barWindow.height

    implicitWidth: Theme.popupWidth
    implicitHeight: header.height + column.implicitHeight + pad * 3
    color: Theme.border   // shows through as the 1px border

    onVisibleChanged: visible ? PopupState.opened(popup) : PopupState.closed(popup)
    Component.onCompleted: PopupState.register(name, popup)

    Rectangle {
        anchors { fill: parent; margins: 1 }
        color: Theme.bg

        // title + [x]
        Item {
            id: header
            x: popup.pad; y: popup.pad
            width: parent.width - popup.pad * 2
            height: Theme.fontHeight
            BarText { text: popup.title; color: Theme.selFg }
            BarText {
                anchors.right: parent.right
                text: "[x]"
                color: closeMouse.containsMouse ? Theme.selFg : Theme.dim
                MouseArea { id: closeMouse; anchors.fill: parent; hoverEnabled: true; onClicked: popup.visible = false }
            }
        }

        Column {
            id: column
            x: popup.pad
            y: header.y + header.height + popup.pad
            width: parent.width - popup.pad * 2
            spacing: 2
        }
    }
}
