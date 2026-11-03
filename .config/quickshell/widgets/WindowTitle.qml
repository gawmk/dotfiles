import QtQuick
import qs.theme
import qs.services

BarText {
    required property var screen
    text: Dwm.titleFor(Dwm.monitorFor(screen))
    color: Theme.fgDim
    elide: Text.ElideRight
}
