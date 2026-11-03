import QtQuick
import qs.theme
import qs.services

Row {
    id: root
    required property var screen
    readonly property var mon: Dwm.monitorFor(screen)
    readonly property var state: mon ? mon.tag_state : ({ selected: 1, occupied: 0, urgent: 0 })
    spacing: 4

    Repeater {
        model: Dwm.tagNames

        Rectangle {
            id: tag
            required property string modelData
            required property int index
            readonly property int mask: 1 << index
            readonly property bool selected: root.state.selected & mask
            readonly property bool occupied: root.state.occupied & mask
            readonly property bool urgent: root.state.urgent & mask

            width: selected ? 30 : 22
            height: Theme.barHeight - 10
            anchors.verticalCenter: parent.verticalCenter
            radius: height / 2
            color: urgent ? Theme.red
                 : selected ? Theme.accent
                 : hover.containsMouse ? Theme.bgHover
                 : "transparent"

            Behavior on width { NumberAnimation { duration: 150; easing.type: Easing.OutCubic } }
            Behavior on color { ColorAnimation { duration: 150 } }

            BarText {
                anchors.centerIn: parent
                text: tag.modelData
                color: tag.selected || tag.urgent ? Theme.bg
                     : tag.occupied ? Theme.fg
                     : Theme.fgMuted
            }

            // small dot under occupied, unselected tags
            Rectangle {
                visible: tag.occupied && !tag.selected
                width: 4; height: 4; radius: 2
                color: Theme.fgDim
                anchors { horizontalCenter: parent.horizontalCenter; bottom: parent.bottom; bottomMargin: 1 }
            }

            MouseArea {
                id: hover
                anchors.fill: parent
                hoverEnabled: true
                acceptedButtons: Qt.LeftButton | Qt.RightButton
                onClicked: e => e.button === Qt.RightButton ? Dwm.toggleView(tag.mask) : Dwm.view(tag.mask)
            }
        }
    }

    BarText {
        anchors.verticalCenter: parent.verticalCenter
        leftPadding: 6
        text: root.mon ? root.mon.layout.symbol.current : ""
        color: Theme.fgDim
    }

    // scroll over tags to move between them
    WheelHandler {
        acceptedDevices: PointerDevice.Mouse | PointerDevice.TouchPad
        onWheel: e => {
            const n = Dwm.tagNames.length;
            const cur = Math.log2(root.state.selected & -root.state.selected);
            const next = (cur + (e.angleDelta.y < 0 ? 1 : -1) + n) % n;
            Dwm.view(1 << next);
        }
    }
}
