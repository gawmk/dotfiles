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

    onVisibleChanged: {
        armed = false;
        visible ? PopupState.opened(popup) : PopupState.closed(popup);
    }

    // close shortly after the pointer leaves both the popup and the bar segment
    // that opened it. Only armed once the pointer has been over either, so a
    // popup opened from a keybinding doesn't vanish straight away.
    property bool armed: false
    readonly property bool hovered: popupHover.hovered || anchorHover.hovered
    onHoveredChanged: {
        if (hovered) { armed = true; leaveTimer.stop(); }
        else if (armed && visible) leaveTimer.restart();
    }
    Timer { id: leaveTimer; interval: 400; onTriggered: if (!popup.hovered) popup.visible = false }
    HoverHandler { id: anchorHover; parent: popup.anchorItem }
    Component.onCompleted: PopupState.register(name, popup)

    Rectangle {
        anchors { fill: parent; margins: 1 }
        color: Theme.bg
        HoverHandler { id: popupHover }

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
