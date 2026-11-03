//@ pragma UseQApplication
import Quickshell
import QtQuick

ShellRoot {
    // one bar per monitor
    Variants {
        model: Quickshell.screens
        Bar {}
    }
}
