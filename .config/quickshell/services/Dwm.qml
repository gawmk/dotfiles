pragma Singleton
import Quickshell
import Quickshell.Io
import QtQuick

// dwm state via the ipc patch (dwm-msg). Events are only used as triggers;
// the full state is re-read with `get_monitors` each time, which keeps
// parsing trivial (dwm-msg pretty-prints multi-line JSON).
Singleton {
    id: root

    property var monitors: []        // raw get_monitors output
    property var clients: ({})       // window id -> { name, tags }
    property var layouts: []         // [{ symbol, address }]
    property var tagNames: ["1", "2", "3", "4", "5", "6", "7", "8", "9"]
    property bool connected: false

    function monitorFor(screen) {
        for (const m of monitors) {
            const g = m.monitor_geometry;
            if (g.x === screen.x && g.y === screen.y)
                return m;
        }
        return monitors.length ? monitors[0] : null;
    }

    function titleFor(mon) {
        if (!mon || !mon.clients.selected) return "";
        return clients[mon.clients.selected]?.name ?? "";
    }

    // tags of the focused client on this monitor (dwm fills the occupied box for these)
    function selTagsFor(mon) {
        if (!mon || !mon.is_selected || !mon.clients.selected) return 0;
        return clients[mon.clients.selected]?.tags ?? 0;
    }

    function run(cmd, arg) {
        Quickshell.execDetached(["dwm-msg", "run_command", cmd, String(arg)]);
    }
    function view(mask)       { run("view", mask); }
    function toggleView(mask) { run("toggleview", mask); }
    function setLayout(address) { run("setlayoutsafe", address); }
    function layoutAddress(symbol) {
        return layouts.find(l => l.symbol === symbol)?.address ?? 0;
    }

    // --- state queries -------------------------------------------------

    property bool refreshPending: false
    function refresh() {
        if (monProc.running) refreshPending = true;
        else monProc.running = true;
    }

    Timer {
        id: debounce
        interval: 10
        onTriggered: root.refresh()
    }

    Process {
        id: monProc
        command: ["dwm-msg", "get_monitors"]
        stdout: StdioCollector {
            onStreamFinished: {
                try {
                    root.monitors = JSON.parse(text);
                    root.connected = true;
                } catch (e) {
                    return;
                }
                const ids = root.monitors.map(m => m.clients.selected).filter(id => id);
                if (ids.length) {
                    titleProc.command = ["sh", "-c",
                        'for id; do dwm-msg get_dwm_client "$id"; printf "\\036"; done',
                        "sh"].concat(ids.map(String));
                    titleProc.running = true;
                }
            }
        }
        onExited: if (root.refreshPending) {
            root.refreshPending = false;
            running = true;
        }
    }

    Process {
        id: titleProc
        stdout: StdioCollector {
            onStreamFinished: {
                const t = {};
                for (const chunk of text.split("\x1e")) {
                    try {
                        const c = JSON.parse(chunk);
                        t[c.window_id] = { name: c.name, tags: c.tags };
                    } catch (e) {}
                }
                root.clients = t;
            }
        }
    }

    Process {
        id: tagsProc
        command: ["dwm-msg", "get_tags"]
        stdout: StdioCollector {
            onStreamFinished: {
                try { root.tagNames = JSON.parse(text).map(t => t.name); } catch (e) {}
            }
        }
    }

    Process {
        id: layoutsProc
        command: ["dwm-msg", "get_layouts"]
        stdout: StdioCollector {
            onStreamFinished: {
                try { root.layouts = JSON.parse(text); } catch (e) {}
            }
        }
    }

    // --- event subscription (auto-reconnects when dwm restarts) ---------

    Process {
        id: sub
        running: true
        command: ["dwm-msg", "subscribe",
            "tag_change_event", "client_focus_change_event", "layout_change_event",
            "monitor_focus_change_event", "focused_title_change_event"]
        stdout: SplitParser {
            onRead: data => { if (data.includes("_event")) debounce.restart(); }
        }
        onStarted: {
            tagsProc.running = true;
            layoutsProc.running = true;
            root.refresh();
        }
        onExited: {
            root.connected = false;
            retry.start();
        }
    }

    Timer {
        id: retry
        interval: 2000
        onTriggered: sub.running = true
    }
}
