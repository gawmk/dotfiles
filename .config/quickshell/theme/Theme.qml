pragma Singleton
import Quickshell
import QtQuick

// colours and font straight from ~/source/dwm/config.def.h
Singleton {
    id: theme
    readonly property color bg:        "#282828"   // col_gray1
    readonly property color border:    "#504945"   // col_gray2
    readonly property color fg:        "#bdae93"   // col_gray3 (SchemeNorm fg)
    readonly property color selFg:     "#fbf1c7"   // col_gray4 (SchemeSel fg)
    readonly property color selBorder: "#665c54"   // col_cyan
    readonly property color accent:    "#d65d0e"   // col_orange
    readonly property color dim:       "#7c6f64"
    readonly property color red:       "#cc241d"
    readonly property color yellow:    "#d79921"
    readonly property color green:     "#98971a"

    readonly property font font: Qt.font({ family: "IosevkaComfy Nerd Font", pointSize: 14, weight: Font.DemiBold })

    // dwm: bh = font height + 2, lrpad = font height
    readonly property real fontHeight: metrics.height
    readonly property int barHeight: Math.ceil(fontHeight) + 2
    readonly property real lrpad: fontHeight

    readonly property int popupWidth: 340

    property FontMetrics metrics: FontMetrics { font: theme.font }
}
