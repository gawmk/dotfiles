import Quickshell
import Quickshell.Services.Pipewire
import QtQuick
import qs.theme

// "vol: 50%" / "vol: mut". scroll = volume, middle = mute, right = pavucontrol
Segment {
    id: root
    required property var barWindow

    readonly property var sink: Pipewire.defaultAudioSink
    readonly property var source: Pipewire.defaultAudioSource
    readonly property var nodes: Pipewire.nodes.values.filter(n => n.audio && !n.isStream)
    readonly property var sinks: nodes.filter(n => n.isSink)
    readonly property var sources: nodes.filter(n => !n.isSink)

    PwObjectTracker { objects: [root.sink, root.source] }

    function setVol(node, v) { if (node?.audio) node.audio.volume = Math.max(0, Math.min(1.5, v)); }
    function toggleMute(node) { if (node?.audio) node.audio.muted = !node.audio.muted; }
    function pct(node) { return Math.round((node?.audio?.volume ?? 0) * 100) + "%"; }
    function label(n) { return n.nickname || n.description || n.name; }

    text: "vol: " + (sink?.audio?.muted ? "mut" : pct(sink))
    onClicked: b => {
        if (b === Qt.RightButton) Quickshell.execDetached(["pavucontrol"]);
        else if (b === Qt.MiddleButton) toggleMute(sink);
        else popup.toggle();
    }
    onWheel: d => setVol(sink, (sink?.audio?.volume ?? 0) + (d > 0 ? 0.05 : -0.05))

    BarPopup {
        id: popup
        barWindow: root.barWindow
        anchorItem: root
        title: "audio"

        SectionLabel { text: "output" }
        VolumeLine { node: root.sink }
        Repeater {
            model: root.sinks
            ListRow {
                required property var modelData
                text: root.label(modelData)
                active: modelData === root.sink
                onClicked: Pipewire.preferredDefaultAudioSink = modelData
            }
        }

        SectionLabel { text: "input"; visible: root.sources.length > 0 }
        VolumeLine { node: root.source; visible: root.source !== null }
        Repeater {
            model: root.sources
            ListRow {
                required property var modelData
                text: root.label(modelData)
                active: modelData === root.source
                onClicked: Pipewire.preferredDefaultAudioSource = modelData
            }
        }

        Row {
            topPadding: 6
            TextButton { label: "pavucontrol"; onClicked: Quickshell.execDetached(["pavucontrol"]) }
        }
    }
}
