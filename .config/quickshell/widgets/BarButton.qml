import QtQuick
import qs.theme

// icon + optional label, with hover highlight. Emits clicked(button) / wheel(delta).
Item {
    id: root
    property string icon: ""
    property string label: ""
    property color iconColor: Theme.fg
    signal clicked(int button)
    signal wheel(int delta)

    implicitWidth: row.implicitWidth + 12
    implicitHeight: Theme.barHeight - 6

    Rectangle {
        anchors.fill: parent
        radius: Theme.radius - 2
        color: mouse.containsMouse ? Theme.bgHover : "transparent"
        Behavior on color { ColorAnimation { duration: 120 } }
    }

    Row {
        id: row
        anchors.centerIn: parent
        spacing: 6
        BarText { text: root.icon; color: root.iconColor; font.pixelSize: Theme.iconSize; visible: text !== "" }
        BarText { text: root.label; visible: text !== "" }
    }

    MouseArea {
        id: mouse
        anchors.fill: parent
        hoverEnabled: true
        acceptedButtons: Qt.LeftButton | Qt.RightButton | Qt.MiddleButton
        onClicked: e => root.clicked(e.button)
        onWheel: e => root.wheel(e.angleDelta.y)
    }
}
