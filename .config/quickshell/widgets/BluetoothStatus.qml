import Quickshell
import Quickshell.Bluetooth
import QtQuick
import qs.theme

// "bt: off" / "bt: on" / "bt: <device>"; hidden when there's no adapter
Segment {
    id: root
    required property var barWindow

    readonly property var adapter: Bluetooth.defaultAdapter
    readonly property var devices: adapter ? adapter.devices.values : []
    readonly property var paired: devices.filter(d => d.paired || d.bonded)
    readonly property var others: devices.filter(d => !d.paired && !d.bonded && d.name)
    readonly property var connected: paired.filter(d => d.connected)

    visible: adapter !== null
    text: !adapter?.enabled ? "bt: off"
        : connected.length ? "bt: " + connected.map(d => d.name).join(", ")
        : "bt: on"
    color: adapter?.enabled ? Theme.fg : Theme.dim
    onClicked: b => b === Qt.RightButton ? Quickshell.execDetached(["st", "-e", "bluetoothctl"]) : popup.toggle()

    function detail(d) {
        let s = d.pairing ? "pairing..." : d.state === BluetoothDeviceState.Connecting ? "connecting..."
              : d.state === BluetoothDeviceState.Disconnecting ? "..." : d.connected ? "connected" : "";
        if (d.batteryAvailable) s += (s ? "  " : "") + Math.round(d.battery * 100) + "%";
        return s;
    }

    BarPopup {
        id: popup
        barWindow: root.barWindow
        anchorItem: root
        title: "bluetooth"

        // stop scanning when closed
        onVisibleChanged: if (!visible && root.adapter?.discovering) root.adapter.discovering = false

        Row {
            spacing: Theme.lrpad / 2
            TextButton {
                label: root.adapter?.enabled ? "on" : "off"
                on: root.adapter?.enabled ?? false
                onClicked: root.adapter.enabled = !root.adapter.enabled
            }
            TextButton {
                visible: root.adapter?.enabled ?? false
                label: root.adapter?.discovering ? "scanning" : "scan"
                on: root.adapter?.discovering ?? false
                onClicked: root.adapter.discovering = !root.adapter.discovering
            }
        }

        SectionLabel { text: "paired"; visible: root.paired.length > 0 && root.adapter?.enabled }
        Repeater {
            model: root.adapter?.enabled ? root.paired : []
            ListRow {
                required property var modelData
                text: modelData.name
                detail: root.detail(modelData)
                active: modelData.connected
                onClicked: b => {
                    if (b === Qt.RightButton) modelData.forget();
                    else if (modelData.connected) modelData.disconnect();
                    else modelData.connect();
                }
            }
        }

        SectionLabel { text: "nearby"; visible: root.adapter?.discovering ?? false }
        Repeater {
            model: root.adapter?.discovering ? root.others : []
            ListRow {
                required property var modelData
                text: modelData.name
                detail: root.detail(modelData)
                onClicked: modelData.pair()
                // once paired: trust and connect
                Connections {
                    target: modelData
                    function onPairedChanged() {
                        if (modelData.paired) { modelData.trusted = true; modelData.connect(); }
                    }
                }
            }
        }

        BarText {
            visible: root.adapter?.enabled ?? false
            text: "click: (dis)connect · right-click: forget"
            width: parent.width
            wrapMode: Text.Wrap
            color: Theme.dim
        }
    }
}
