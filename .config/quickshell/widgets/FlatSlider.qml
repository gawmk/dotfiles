import QtQuick
import qs.theme

// square track, no handle, no animation. value 0..1; emits moved(v) on drag/click/scroll.
Item {
    id: root
    property real value: 0
    property bool muted: false
    signal moved(real v)

    height: Theme.fontHeight
    function setFromX(x) { moved(Math.max(0, Math.min(1, x / width))); }

    Rectangle {
        anchors.verticalCenter: parent.verticalCenter
        width: parent.width; height: 8
        color: Theme.border
        Rectangle {
            width: parent.width * Math.min(1, root.value)
            height: parent.height
            color: root.muted ? Theme.dim : Theme.fg
        }
    }
    MouseArea {
        anchors.fill: parent
        onPressed: e => root.setFromX(e.x)
        onPositionChanged: e => { if (pressed) root.setFromX(e.x); }
        onWheel: e => root.moved(Math.max(0, Math.min(1, root.value + (e.angleDelta.y > 0 ? 0.05 : -0.05))))
    }
}
