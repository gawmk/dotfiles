import QtQuick
import qs.theme
import qs.services

BarText {
    required property var screen
    readonly property var mon: Dwm.monitorFor(screen)
    text: Dwm.titleFor(mon)
    color: mon && mon.is_selected ? Theme.selFg : Theme.fg
    leftPadding: Theme.lrpad / 2
    elide: Text.ElideRight
}
