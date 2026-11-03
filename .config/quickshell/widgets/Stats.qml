import Quickshell
import QtQuick
import QtQuick.Layouts
import qs.theme
import qs.services

BarButton {
    id: root
    required property var barWindow

    readonly property real hot: Math.max(SysStats.cpuTemp || 0, SysStats.maxGpuTemp)
    icon: "󰍛"
    iconColor: hot >= 85 ? Theme.red : hot >= 70 ? Theme.yellow : Theme.fg
    label: Math.round(SysStats.cpu * 100) + "%"

    onClicked: b => b === Qt.RightButton
        ? Quickshell.execDetached(["st", "-e", "btop"])
        : popup.visible = !popup.visible

    function temp(t) { return isNaN(t) ? "–" : Math.round(t) + "°C"; }

    BarPopup {
        id: popup
        barWindow: root.barWindow
        anchorItem: root

        GridLayout {
            columns: 2
            columnSpacing: 24
            rowSpacing: 6

            BarText { Layout.row: 0; Layout.column: 0; text: "󰻠  CPU"; color: Theme.fgDim }
            BarText { Layout.row: 0; Layout.column: 1; text: Math.round(SysStats.cpu * 100) + "%  ·  " + root.temp(SysStats.cpuTemp); Layout.alignment: Qt.AlignRight }

            Repeater {
                model: SysStats.gpuTemps
                BarText { required property var modelData; required property int index; Layout.row: 1 + index; Layout.column: 0; text: "󰢮  " + modelData.name; color: Theme.fgDim }
            }
            Repeater {
                model: SysStats.gpuTemps
                BarText { required property var modelData; required property int index; Layout.row: 1 + index; Layout.column: 1; Layout.alignment: Qt.AlignRight; text: root.temp(modelData.temp) }
            }

            BarText { Layout.row: 1 + SysStats.gpuTemps.length; Layout.column: 0; text: "󰘚  Memory"; color: Theme.fgDim }
            BarText { Layout.row: 1 + SysStats.gpuTemps.length; Layout.column: 1; text: SysStats.memUsed.toFixed(1) + " / " + SysStats.memTotal.toFixed(1) + " GiB"; Layout.alignment: Qt.AlignRight }
        }

        // memory bar
        Rectangle {
            width: parent.width; height: 6; radius: 3
            color: Theme.bgAlt
            Rectangle {
                width: parent.width * (SysStats.memTotal ? SysStats.memUsed / SysStats.memTotal : 0)
                height: parent.height; radius: 3
                color: Theme.accent
                Behavior on width { NumberAnimation { duration: 300 } }
            }
        }
    }
}
