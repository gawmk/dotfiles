import Quickshell
import Quickshell.Services.UPower
import QtQuick
import qs.theme

// "bat: 80%" / "bat: 80% (c)"; laptop only
Segment {
    id: root
    required property var barWindow

    readonly property var dev: UPower.displayDevice
    readonly property real pct: dev ? (dev.percentage > 1 ? dev.percentage : dev.percentage * 100) : 0
    readonly property bool charging: dev && (dev.state === UPowerDeviceState.Charging || dev.state === UPowerDeviceState.FullyCharged)

    visible: dev && dev.isLaptopBattery && dev.isPresent
    text: "bat: " + Math.round(pct) + "%" + (charging ? " (c)" : "")
    color: charging ? Theme.fg : pct <= 10 ? Theme.red : pct <= 25 ? Theme.yellow : Theme.fg
    onClicked: popup.toggle()

    function hm(secs) {
        if (!secs) return "-";
        const h = Math.floor(secs / 3600), m = Math.round((secs % 3600) / 60);
        return h + "h " + m + "m";
    }

    BarPopup {
        id: popup
        barWindow: root.barWindow
        anchorItem: root
        title: "battery"

        ListRow { enabled: false; text: "charge"; detail: Math.round(root.pct) + "%" }
        ListRow { enabled: false; text: "state"; detail: root.dev ? UPowerDeviceState.toString(root.dev.state).toLowerCase() : "" }
        ListRow { enabled: false; text: root.charging ? "until full" : "remaining"; detail: root.dev ? root.hm(root.charging ? root.dev.timeToFull : root.dev.timeToEmpty) : "" }
        ListRow { enabled: false; visible: root.dev?.healthSupported ?? false; text: "health"; detail: Math.round(root.dev?.healthPercentage ?? 0) + "%" }
        ListRow {
            enabled: false
            visible: (root.dev?.changeRate ?? 0) > 0
            text: "draw"; detail: (root.dev?.changeRate ?? 0).toFixed(1) + " W"
        }
    }
}
