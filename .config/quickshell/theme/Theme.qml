pragma Singleton
import Quickshell
import QtQuick

// gruvbox, matching dwm's config.def.h
Singleton {
    readonly property color bg:       "#282828"
    readonly property color bgAlt:    "#3c3836"
    readonly property color bgHover:  "#504945"
    readonly property color border:   "#665c54"
    readonly property color fg:       "#ebdbb2"
    readonly property color fgDim:    "#a89984"
    readonly property color fgMuted:  "#665c54"
    readonly property color accent:   "#d65d0e"
    readonly property color yellow:   "#d79921"
    readonly property color green:    "#98971a"
    readonly property color red:      "#cc241d"
    readonly property color blue:     "#458588"

    readonly property string font: "IosevkaComfy Nerd Font"
    readonly property int fontSize: 14
    readonly property int iconSize: 16

    readonly property int barHeight: 30
    readonly property int radius: 8
    readonly property int spacing: 14
}
