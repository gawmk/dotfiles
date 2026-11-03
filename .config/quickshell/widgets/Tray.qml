import Quickshell
import Quickshell.Services.SystemTray
import Quickshell.Widgets
import QtQuick
import qs.theme

Row {
    id: root
    required property var barWindow
    spacing: 6

    Repeater {
        model: SystemTray.items

        Item {
            id: item
            required property var modelData
            width: Theme.iconSize + 4
            height: Theme.barHeight

            IconImage {
                anchors.centerIn: parent
                implicitSize: Theme.iconSize
                source: item.modelData.icon
            }

            QsMenuAnchor {
                id: menu
                menu: item.modelData.menu
                anchor.window: root.barWindow
                anchor.rect.x: item.mapToItem(root.barWindow.contentItem, 0, 0).x
                anchor.rect.y: root.barWindow.height
            }

            MouseArea {
                anchors.fill: parent
                acceptedButtons: Qt.LeftButton | Qt.RightButton | Qt.MiddleButton
                onClicked: e => {
                    if (e.button === Qt.MiddleButton) item.modelData.secondaryActivate();
                    else if (e.button === Qt.RightButton || item.modelData.onlyMenu) {
                        if (item.modelData.hasMenu) menu.open();
                    } else item.modelData.activate();
                }
                onWheel: e => item.modelData.scroll(e.angleDelta.y, false)
            }
        }
    }
}
