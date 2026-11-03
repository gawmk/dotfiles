import Quickshell
import QtQuick
import qs.theme
import qs.services

// "cpu: 2% 36°C | mem: 4.8G" — both open the same popup; right click = btop
Row {
    id: root
    required property var barWindow

    function temp(t) { return isNaN(t) ? "-" : Math.round(t) + "°C"; }
    readonly property real hot: Math.max(SysStats.cpuTemp || 0, SysStats.maxGpuTemp)
    function act(b) { b === Qt.RightButton ? Quickshell.execDetached(["st", "-e", "btop"]) : popup.toggle(); }

    Segment {
        separator: false
        text: "cpu: " + Math.round(SysStats.cpu * 100) + "% " + root.temp(SysStats.cpuTemp)
        color: root.hot >= 85 ? Theme.red : root.hot >= 70 ? Theme.yellow : Theme.fg
        onClicked: b => root.act(b)
    }
    Segment {
        text: "mem: " + SysStats.memUsed.toFixed(1) + "G"
        onClicked: b => root.act(b)
    }

    BarPopup {
        id: popup
        barWindow: root.barWindow
        anchorItem: root
        title: "system"

        ListRow { text: "cpu"; detail: Math.round(SysStats.cpu * 100) + "%  " + root.temp(SysStats.cpuTemp); enabled: false }
        Repeater {
            model: SysStats.gpuTemps
            ListRow { required property var modelData; text: modelData.name.toLowerCase(); detail: root.temp(modelData.temp); enabled: false }
        }
        ListRow {
            text: "mem"
            detail: SysStats.memUsed.toFixed(1) + " / " + SysStats.memTotal.toFixed(1) + "G"
            enabled: false
        }
        FlatSlider {
            width: parent.width
            value: SysStats.memTotal ? SysStats.memUsed / SysStats.memTotal : 0
            enabled: false
        }
        Row {
            topPadding: 6
            TextButton { label: "btop"; onClicked: Quickshell.execDetached(["st", "-e", "btop"]) }
        }
    }
}
