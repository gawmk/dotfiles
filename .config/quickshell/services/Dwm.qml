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
    property var titles: ({})        // window id -> title
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
        return titles[mon.clients.selected] ?? "";
    }

    function run(cmd, arg) {
        Quickshell.execDetached(["dwm-msg", "run_command", cmd, String(arg)]);
    }
    function view(mask)       { run("view", mask); }
    function toggleView(mask) { run("toggleview", mask); }

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
                        t[c.window_id] = c.name;
                    } catch (e) {}
                }
                root.titles = t;
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
