import QtQuick
import qs.theme

// a selectable line in a popup: "> left .......... right", dmenu-style highlight on hover
Rectangle {
    id: root
    property string text: ""
    property string detail: ""
    property bool active: false
    property bool enabled: true
    property color textColor: active ? Theme.selFg : Theme.fg
    signal clicked(int button)

    width: parent ? parent.width : 0
    height: Theme.fontHeight + 2
    color: enabled && mouse.containsMouse ? Theme.selBorder : "transparent"

    BarText {
        anchors { left: parent.left; right: detailText.left; rightMargin: 8; leftMargin: 2 }
        height: parent.height
        text: (root.active ? "> " : "  ") + root.text
        color: root.textColor
        elide: Text.ElideRight
    }
    BarText {
        id: detailText
        anchors { right: parent.right; rightMargin: 2 }
        height: parent.height
        text: root.detail
        color: root.active ? Theme.selFg : Theme.dim
    }
    MouseArea {
        id: mouse
        anchors.fill: parent
        hoverEnabled: true
        enabled: root.enabled
        acceptedButtons: Qt.LeftButton | Qt.RightButton
        onClicked: e => root.clicked(e.button)
    }
}
