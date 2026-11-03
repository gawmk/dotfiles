pragma Singleton
import Quickshell
import Quickshell.Io
import QtQuick

Singleton {
    id: root

    property real cpu: 0          // 0..1
    property real memUsed: 0      // GiB
    property real memTotal: 0     // GiB
    property real cpuTemp: NaN
    property var gpuTemps: []     // [{ name, temp }], one per amdgpu chip
    readonly property real maxGpuTemp: gpuTemps.reduce((m, g) => Math.max(m, g.temp), 0)

    property var _lastCpu: null

    Timer {
        interval: 2000
        running: true
        repeat: true
        triggeredOnStart: true
        onTriggered: procStat.running = true
    }

    Timer {
        interval: 5000
        running: true
        repeat: true
        triggeredOnStart: true
        onTriggered: sensors.running = true
    }

    Process {
        id: procStat
        command: ["sh", "-c", "head -1 /proc/stat; grep -E '^(MemTotal|MemAvailable):' /proc/meminfo"]
        stdout: StdioCollector {
            onStreamFinished: {
                const lines = text.trim().split("\n");
                const f = lines[0].split(/\s+/).slice(1).map(Number);
                const idle = f[3] + f[4];
                const total = f.reduce((a, b) => a + b, 0);
                if (root._lastCpu) {
                    const dt = total - root._lastCpu.total;
                    if (dt > 0) root.cpu = 1 - (idle - root._lastCpu.idle) / dt;
                }
                root._lastCpu = { idle, total };

                const kb = l => Number(l.split(/\s+/)[1]);
                const total_ = kb(lines[1]), avail = kb(lines[2]);
                root.memTotal = total_ / 1048576;
                root.memUsed = (total_ - avail) / 1048576;
            }
        }
    }

    Process {
        id: sensors
        command: ["sensors", "-j"]
        stdout: StdioCollector {
            onStreamFinished: {
                let d;
                try { d = JSON.parse(text); } catch (e) { return; }
                const input = obj => {
                    for (const k in obj) if (k.endsWith("_input")) return obj[k];
                    return NaN;
                };
                // CPU: AMD (k10temp Tctl) or Intel (coretemp package)
                let cpu = NaN;
                for (const chip in d) {
                    if (chip.startsWith("k10temp") && d[chip].Tctl) cpu = input(d[chip].Tctl);
                    else if (chip.startsWith("coretemp") && d[chip]["Package id 0"]) cpu = input(d[chip]["Package id 0"]);
                }
                root.cpuTemp = cpu;
                // GPUs: every amdgpu chip with an edge sensor, ordered by PCI address
                const gpus = Object.keys(d).filter(c => c.startsWith("amdgpu") && d[c].edge).sort();
                root.gpuTemps = gpus.map((c, i) => ({
                    name: gpus.length > 1 ? "GPU " + (i + 1) : "GPU",
                    temp: input(d[c].edge)
                }));
            }
        }
    }
}
