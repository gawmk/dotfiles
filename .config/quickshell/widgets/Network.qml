import Quickshell
import Quickshell.Networking
import QtQuick
import QtQuick.Layouts
import qs.theme

BarButton {
    id: root
    required property var barWindow

    readonly property var devices: Networking.devices.values
    readonly property var active: devices.find(d => d.connected && d.type === DeviceType.Wired)
                               ?? devices.find(d => d.connected) ?? null
    readonly property var wifiNet: active && active.type === DeviceType.Wifi
        ? active.networks.values.find(n => n.connected) ?? null : null
    readonly property real signal: wifiNet ? (wifiNet.signalStrength > 1 ? wifiNet.signalStrength / 100 : wifiNet.signalStrength) : 0

    icon: !active ? "󰤮"
        : active.type === DeviceType.Wired ? "󰈀"
        : ["󰤟", "󰤢", "󰤥", "󰤨"][Math.min(3, Math.floor(signal * 4))]
    iconColor: active ? Theme.fg : Theme.red

    onClicked: b => b === Qt.RightButton
        ? Quickshell.execDetached(["st", "-e", "nmtui"])
        : popup.visible = !popup.visible

    BarPopup {
        id: popup
        barWindow: root.barWindow
        anchorItem: root

        GridLayout {
            columns: 2
            columnSpacing: 24
            rowSpacing: 6

            Repeater {
                model: root.devices.filter(d => d.type !== DeviceType.None)
                delegate: BarText {
                    required property var modelData
                    Layout.row: index
                    required property int index
                    text: (modelData.type === DeviceType.Wifi ? "󰖩  " : "󰈀  ") + modelData.name
                    color: Theme.fgDim
                }
            }
            Repeater {
                model: root.devices.filter(d => d.type !== DeviceType.None)
                delegate: BarText {
                    required property var modelData
                    required property int index
                    Layout.row: index
                    Layout.column: 1
                    Layout.alignment: Qt.AlignRight
                    readonly property var net: modelData.networks.values.find(n => n.connected)
                    text: modelData.connected ? (net ? net.name : "connected") : "disconnected"
                    color: modelData.connected ? Theme.green : Theme.fgMuted
                }
            }
        }
        BarText { text: "right-click: nmtui"; color: Theme.fgMuted; font.pixelSize: Theme.fontSize - 3 }
    }
}
