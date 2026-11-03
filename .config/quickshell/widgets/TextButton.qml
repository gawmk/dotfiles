import QtQuick
import qs.theme

// "[label]" — click to act. Used for toggles and footer actions.
BarText {
    id: root
    property string label: ""
    property bool on: false          // for toggles: highlights when on
    signal clicked(int button)

    text: "[" + label + "]"
    color: mouse.containsMouse ? Theme.selFg : on ? Theme.accent : Theme.fg
    MouseArea {
        id: mouse
        anchors.fill: parent
        hoverEnabled: true
        acceptedButtons: Qt.LeftButton | Qt.RightButton
        onClicked: e => root.clicked(e.button)
    }
}
