import Quickshell
import Quickshell.Services.Pipewire
import QtQuick
import QtQuick.Controls
import qs.theme

BarButton {
    id: root
    required property var barWindow

    readonly property var sink: Pipewire.defaultAudioSink
    readonly property real volume: sink?.audio?.volume ?? 0
    readonly property bool muted: sink?.audio?.muted ?? false

    PwObjectTracker { objects: [root.sink] }

    function setVolume(v) {
        if (sink?.audio) sink.audio.volume = Math.max(0, Math.min(1.5, v));
    }

    icon: muted ? "󰝟" : volume < 0.34 ? "󰕿" : volume < 0.67 ? "󰖀" : "󰕾"
    iconColor: muted ? Theme.fgMuted : Theme.fg
    label: Math.round(volume * 100) + "%"

    onClicked: b => {
        if (b === Qt.RightButton) Quickshell.execDetached(["pavucontrol"]);
        else if (b === Qt.MiddleButton) { if (sink?.audio) sink.audio.muted = !muted; }
        else popup.visible = !popup.visible;
    }
    onWheel: d => setVolume(volume + (d > 0 ? 0.05 : -0.05))

    BarPopup {
        id: popup
        barWindow: root.barWindow
        anchorItem: root

        BarText {
            text: root.sink?.description || root.sink?.name || "No output"
            color: Theme.fgDim
            width: 240
            elide: Text.ElideRight
        }

        Row {
            spacing: 10
            BarButton {
                icon: root.icon
                iconColor: root.iconColor
                onClicked: if (root.sink?.audio) root.sink.audio.muted = !root.muted
            }
            Slider {
                id: slider
                width: 190
                anchors.verticalCenter: parent.verticalCenter
                from: 0; to: 1
                value: root.volume
                onMoved: root.setVolume(value)

                background: Rectangle {
                    x: slider.leftPadding
                    y: slider.topPadding + slider.availableHeight / 2 - height / 2
                    width: slider.availableWidth; height: 6; radius: 3
                    color: Theme.bgAlt
                    Rectangle {
                        width: slider.visualPosition * parent.width
                        height: parent.height; radius: 3
                        color: root.muted ? Theme.fgMuted : Theme.accent
                    }
                }
                handle: Rectangle {
                    x: slider.leftPadding + slider.visualPosition * (slider.availableWidth - width)
                    y: slider.topPadding + slider.availableHeight / 2 - height / 2
                    width: 14; height: 14; radius: 7
                    color: Theme.fg
                }
            }
        }
        BarText { text: "scroll: volume · middle: mute · right: mixer"; color: Theme.fgMuted; font.pixelSize: Theme.fontSize - 3 }
    }
}
