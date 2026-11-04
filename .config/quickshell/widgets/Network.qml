import Quickshell
import Quickshell.Io
import Quickshell.Networking
import QtQuick
import qs.theme

// "net: up" / "net: down"; popup lists devices and wifi networks
Segment {
    id: root
    required property var barWindow

    readonly property var devices: Networking.devices.values
    readonly property var wifiDev: devices.find(d => d.type === DeviceType.Wifi) ?? null
    readonly property var wired: devices.filter(d => d.type === DeviceType.Wired)
    readonly property var active: devices.find(d => d.connected && d.type === DeviceType.Wired)
                               ?? devices.find(d => d.connected) ?? null

    function strength(n) { const s = n.signalStrength; return s > 1 ? s / 100 : s; }
    function bars(n) {
        const lvl = Math.ceil(strength(n) * 4);
        return "▂▄▆█".slice(0, lvl) + "_".repeat(4 - Math.max(0, lvl));
    }

    text: active ? "net: up" : "net: down"
    color: active ? Theme.fg : Theme.red

    onClicked: b => b === Qt.RightButton ? Quickshell.execDetached(["st", "-e", "nmtui"]) : popup.toggle()

    // wifi password: dmenu grabs the keyboard, which popups can't do on X11
    property var pskTarget: null
    property string lastError: ""
    Process {
        id: pskPrompt
        stdout: StdioCollector {
            onStreamFinished: {
                const psk = text.replace(/\n$/, "");
                if (root.pskTarget && psk) root.pskTarget.connectWithPsk(psk);
            }
        }
    }
    function connect(n) {
        lastError = "";
        if (n.known || n.security === WifiSecurityType.Open) { n.connect(); return; }
        pskTarget = n;
        pskPrompt.command = ["dmenu", "-P", "-c", "-p", "password for " + n.name + ":"];
        pskPrompt.running = true;
    }

    BarPopup {
        id: popup
        barWindow: root.barWindow
        anchorItem: root
        title: "network"

        // scan only while the popup is open
        onVisibleChanged: if (root.wifiDev) root.wifiDev.scannerEnabled = visible

        Repeater {
            model: root.wired
            ListRow {
                required property var modelData
                text: modelData.name
                detail: modelData.connected ? "connected" : "disconnected"
                active: modelData.connected
                enabled: false
            }
        }

        Item {
            visible: root.wifiDev !== null
            width: parent.width; height: wifiLabel.height
            SectionLabel { id: wifiLabel; text: "wifi" ; width: parent.width - wifiToggle.width - 8 }
            TextButton {
                id: wifiToggle
                anchors { right: parent.right; bottom: parent.bottom }
                label: Networking.wifiEnabled ? "on" : "off"
                on: Networking.wifiEnabled
                onClicked: Networking.wifiEnabled = !Networking.wifiEnabled
            }
        }

        Repeater {
            model: !root.wifiDev || !Networking.wifiEnabled ? [] :
                root.wifiDev.networks.values.slice()
                    .sort((a, b) => (b.connected - a.connected) || (b.known - a.known) || (root.strength(b) - root.strength(a)))
                    .slice(0, 12)

            ListRow {
                required property var modelData
                readonly property var net: modelData
                active: net.connected
                text: net.name + (net.known && !net.connected ? " *" : "")
                detail: (net.stateChanging ? "... " : "")
                    + (net.security !== WifiSecurityType.Open ? "\uf023 " : "  ") + root.bars(net)
                onClicked: b => {
                    if (b === Qt.RightButton) { if (net.known) net.forget(); }
                    else if (net.connected) net.disconnect();
                    else root.connect(net);
                }
                Connections {
                    target: net
                    function onConnectionFailed(reason) { root.lastError = net.name + ": " + ConnectionFailReason.toString(reason); }
                }
            }
        }

        BarText {
            visible: root.lastError !== ""
            width: parent.width
            text: root.lastError
            color: Theme.red
            wrapMode: Text.Wrap
        }
        BarText {
            visible: root.wifiDev !== null && Networking.wifiEnabled
            text: "click: (dis)connect · right-click: forget"
            width: parent.width
            wrapMode: Text.Wrap
            color: Theme.dim
        }
        Row {
            topPadding: 6
            TextButton { label: "nmtui"; onClicked: Quickshell.execDetached(["st", "-e", "nmtui"]) }
        }
    }
}
