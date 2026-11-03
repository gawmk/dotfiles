import Quickshell
import QtQuick
import qs.theme

BarText {
    id: root
    required property var barWindow

    SystemClock { id: clock; precision: SystemClock.Minutes }
    text: Qt.formatDateTime(clock.date, "ddd dd MMM HH:mm")

    MouseArea { anchors.fill: parent; onClicked: popup.toggle() }

    BarPopup {
        id: popup
        barWindow: root.barWindow
        anchorItem: root
        title: Qt.formatDate(month, "MMMM yyyy")
        name: "clock"
        implicitWidth: grid.width + pad * 2 + 2

        property var month: new Date()
        onVisibleChanged: if (visible) month = new Date(clock.date.getFullYear(), clock.date.getMonth(), 1)
        function shift(n) { month = new Date(month.getFullYear(), month.getMonth() + n, 1); }

        Row {
            spacing: Theme.lrpad / 2
            TextButton { label: "<"; onClicked: popup.shift(-1) }
            TextButton { label: "today"; onClicked: popup.month = new Date(clock.date.getFullYear(), clock.date.getMonth(), 1) }
            TextButton { label: ">"; onClicked: popup.shift(1) }
        }

        Grid {
            id: grid
            columns: 7
            readonly property real cell: Theme.fontHeight * 1.6
            // monday-first grid starting on the week containing the 1st
            readonly property var start: {
                const d = new Date(popup.month);
                d.setDate(1 - ((d.getDay() + 6) % 7));
                return d;
            }

            Repeater {
                model: ["mo", "tu", "we", "th", "fr", "sa", "su"]
                BarText {
                    required property string modelData
                    width: grid.cell; horizontalAlignment: Text.AlignHCenter
                    text: modelData; color: Theme.dim
                }
            }
            Repeater {
                model: 42
                Rectangle {
                    required property int index
                    readonly property date day: new Date(grid.start.getFullYear(), grid.start.getMonth(), grid.start.getDate() + index)
                    readonly property bool today: day.toDateString() === clock.date.toDateString()
                    readonly property bool inMonth: day.getMonth() === popup.month.getMonth()
                    width: grid.cell; height: Theme.fontHeight + 2
                    color: today ? Theme.fg : "transparent"
                    BarText {
                        anchors.centerIn: parent
                        text: parent.day.getDate()
                        color: parent.today ? Theme.bg : parent.inMonth ? Theme.fg : Theme.border
                    }
                }
            }
        }
    }
}
