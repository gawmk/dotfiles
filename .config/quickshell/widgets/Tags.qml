import QtQuick
import qs.theme
import qs.services

// drawn like dwm's drawbar(): text cells, small box for occupied tags,
// filled when the focused client is on it, inverted colours when urgent.
Row {
    id: root
    required property var screen
    readonly property var mon: Dwm.monitorFor(screen)
    readonly property var state: mon ? mon.tag_state : ({ selected: 1, occupied: 0, urgent: 0 })
    readonly property int selTags: Dwm.selTagsFor(mon)
    readonly property int boxs: Math.floor(Theme.fontHeight / 9)
    readonly property int boxw: Math.floor(Theme.fontHeight / 6) + 2

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
            readonly property color fgc: selected ? Theme.selFg : Theme.fg

            width: label.implicitWidth + Theme.lrpad
            height: root.height
            color: urgent ? fgc : Theme.bg

            BarText {
                id: label
                anchors.centerIn: parent
                text: tag.modelData
                color: tag.urgent ? Theme.bg : tag.fgc
            }

            Rectangle {
                visible: tag.occupied
                x: root.boxs; y: root.boxs
                width: root.boxw; height: root.boxw
                color: root.selTags & tag.mask ? (tag.urgent ? Theme.bg : tag.fgc) : "transparent"
                border.width: 1
                border.color: tag.urgent ? Theme.bg : tag.fgc
            }

            MouseArea {
                anchors.fill: parent
                acceptedButtons: Qt.LeftButton | Qt.RightButton
                onClicked: e => e.button === Qt.RightButton ? Dwm.toggleView(tag.mask) : Dwm.view(tag.mask)
                onWheel: e => {
                    const n = Dwm.tagNames.length;
                    const cur = Math.log2(root.state.selected & -root.state.selected);
                    Dwm.view(1 << ((cur + (e.angleDelta.y < 0 ? 1 : -1) + n) % n));
                }
            }
        }
    }

    // layout symbol: left click = previous layout, right click = monocle (like dwm's buttons)
    BarText {
        height: parent.height
        leftPadding: Theme.lrpad / 2
        rightPadding: Theme.lrpad / 2
        text: root.mon ? root.mon.layout.symbol.current : ""
        MouseArea {
            anchors.fill: parent
            acceptedButtons: Qt.LeftButton | Qt.RightButton
            onClicked: e => {
                if (!root.mon) return;
                if (e.button === Qt.RightButton) Dwm.setLayout(Dwm.layoutAddress("[M]"));
                else Dwm.setLayout(root.mon.layout.address.old);
            }
        }
    }
}
