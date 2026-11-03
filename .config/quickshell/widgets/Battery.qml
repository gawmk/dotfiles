import Quickshell.Services.UPower
import QtQuick
import qs.theme

// hidden on machines without a battery
BarButton {
    readonly property var dev: UPower.displayDevice
    readonly property real pct: dev ? (dev.percentage > 1 ? dev.percentage : dev.percentage * 100) : 0
    readonly property bool charging: dev && (dev.state === UPowerDeviceState.Charging || dev.state === UPowerDeviceState.FullyCharged)

    visible: dev && dev.isLaptopBattery && dev.isPresent
    icon: charging ? "󰂄" : ["󰂎", "󰁺", "󰁻", "󰁼", "󰁽", "󰁾", "󰁿", "󰂀", "󰂁", "󰂂", "󰁹"][Math.round(pct / 10)]
    iconColor: charging ? Theme.green : pct <= 15 ? Theme.red : pct <= 30 ? Theme.yellow : Theme.fg
    label: Math.round(pct) + "%"
}
