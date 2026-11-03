pragma Singleton
import Quickshell
import Quickshell.Io
import QtQuick

// only one popup open at a time; popups can also be toggled from outside:
//   qs ipc call bar toggle audio      (names: clock system network bluetooth audio battery)
Singleton {
    id: root
    property var current: null
    property var registry: ({})   // name -> popup (first bar wins)

    function opened(p) {
        if (current && current !== p) current.visible = false;
        current = p;
    }
    function closed(p) { if (current === p) current = null; }
    function register(name, p) { if (name && !registry[name]) registry[name] = p; }

    // X11 can't tell us about clicks outside the popup, so close it when
    // dwm reports that focus moved instead
    Connections {
        target: Dwm
        function onFocusMoved() { if (root.current) root.current.visible = false; }
    }

    IpcHandler {
        target: "bar"
        function toggle(name: string): void { root.registry[name]?.toggle(); }
        function close(): void { if (root.current) root.current.visible = false; }
    }
}
