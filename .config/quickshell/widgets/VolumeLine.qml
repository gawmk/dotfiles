import QtQuick
import qs.theme

// [vol] =========------  50%   for one pipewire node
Row {
    id: line
    property var node: null
    readonly property var audio: node?.audio ?? null
    spacing: 8
    width: parent ? parent.width : 0

    function setVol(v) { if (audio) audio.volume = Math.max(0, Math.min(1.5, v)); }

    TextButton {
        id: muteBtn
        label: line.audio?.muted ? "mut" : "vol"
        on: line.audio?.muted ?? false
        onClicked: if (line.audio) line.audio.muted = !line.audio.muted
    }
    FlatSlider {
        width: line.width - muteBtn.width - pctText.width - line.spacing * 2
        anchors.verticalCenter: parent.verticalCenter
        value: line.audio?.volume ?? 0
        muted: line.audio?.muted ?? false
        onMoved: v => line.setVol(v)
    }
    BarText {
        id: pctText
        width: Theme.fontHeight * 2.2
        horizontalAlignment: Text.AlignRight
        text: Math.round((line.audio?.volume ?? 0) * 100) + "%"
    }
}
