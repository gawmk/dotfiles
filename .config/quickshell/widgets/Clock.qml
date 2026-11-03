import Quickshell
import QtQuick
import QtQuick.Controls
import qs.theme

BarButton {
    id: root
    required property var barWindow

    SystemClock { id: clock; precision: SystemClock.Minutes }
    label: Qt.formatDateTime(clock.date, "ddd dd MMM  HH:mm")
    onClicked: popup.visible = !popup.visible

    BarPopup {
        id: popup
        barWindow: root.barWindow
        anchorItem: root

        property var month: new Date()
        onVisibleChanged: if (visible) month = new Date(clock.date.getFullYear(), clock.date.getMonth(), 1)

        Item {
            width: grid.width
            height: 26
            BarButton { icon: "󰅁"; anchors.left: parent.left; onClicked: popup.month = new Date(popup.month.getFullYear(), popup.month.getMonth() - 1, 1) }
            BarText {
                anchors.centerIn: parent
                text: Qt.formatDate(popup.month, "MMMM yyyy")
                color: Theme.accent
            }
            BarButton { icon: "󰅂"; anchors.right: parent.right; onClicked: popup.month = new Date(popup.month.getFullYear(), popup.month.getMonth() + 1, 1) }
        }

        DayOfWeekRow {
            width: grid.width
            locale: grid.locale
            delegate: BarText {
                required property string shortName
                text: shortName
                horizontalAlignment: Text.AlignHCenter
                color: Theme.fgDim
            }
        }

        MonthGrid {
            id: grid
            width: 260
            month: popup.month.getMonth()
            year: popup.month.getFullYear()
            locale: Qt.locale("en_GB")   // weeks start on Monday
            delegate: Rectangle {
                required property var model
                readonly property bool today: model.today
                implicitWidth: 32
                implicitHeight: 26
                radius: Theme.radius - 2
                color: today ? Theme.accent : "transparent"
                BarText {
                    anchors.centerIn: parent
                    text: model.day
                    color: today ? Theme.bg : model.month === grid.month ? Theme.fg : Theme.fgMuted
                }
            }
        }
    }
}
