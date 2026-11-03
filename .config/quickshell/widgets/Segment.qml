import QtQuick
import qs.theme

// one piece of the status text: " | label". Clicks/scroll only hit the label.
Row {
    id: root
    property string text: ""
    property color color: Theme.fg
    property bool separator: true
    signal clicked(int button)
    signal wheel(int delta)

    height: parent ? parent.height : Theme.barHeight

    BarText {
        visible: root.separator
        height: parent.height
        text: " | "
        color: Theme.dim
    }
    BarText {
        height: parent.height
        text: root.text
        color: root.color
        MouseArea {
            anchors.fill: parent
            acceptedButtons: Qt.LeftButton | Qt.RightButton | Qt.MiddleButton
            onClicked: e => root.clicked(e.button)
            onWheel: e => root.wheel(e.angleDelta.y)
        }
    }
}
