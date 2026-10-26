pragma Singleton
import QtQuick
import Quickshell.Io

QtObject {
    id: root

    property int volume: 0
    property bool muted: false
    property bool ready: false
    signal volumeChangedManually(int vol, bool isMuted)

    // Процес зчитування поточного рівня гучності через wpctl
    property Process getProc: Process {
        command: ["wpctl", "get-volume", "@DEFAULT_AUDIO_SINK@"]
        running: false
        stdout: StdioCollector {
            onStreamFinished: {
                const raw = text.trim()
                if (!raw) return
                // raw: "Volume: 0.28" або "Volume: 0.28 [MUTED]"
                const parts = raw.split(/\s+/)
                if (parts.length >= 2) {
                    const val = Math.round(parseFloat(parts[1]) * 100)
                    const isMuted = raw.includes("[MUTED]")

                    if (root.ready && (root.volume !== val || root.muted !== isMuted)) {
                        root.volumeChangedManually(val, isMuted)
                    }
                    root.volume = val
                    root.muted = isMuted
                    root.ready = true
                }
            }
        }
    }

    // Слухач подій Pipewire/PulseAudio в реальному часі через pactl subscribe
    property Process subProc: Process {
        command: ["pactl", "subscribe"]
        running: true
        stdout: SplitParser {
            splitMarker: "\n"
            onRead: data => {
                if (data.includes("sink") || data.includes("card")) {
                    if (!root.getProc.running) {
                        root.getProc.running = true
                    }
                }
            }
        }
    }

    // Одноразовий таймер після старту для початкового зчитування
    property Timer initTimer: Timer {
        interval: 100
        running: true
        repeat: false
        onTriggered: root.getProc.running = true
    }

    // Процеси для керування гучністю
    property Process muteProc: Process {
        command: ["wpctl", "set-mute", "@DEFAULT_AUDIO_SINK@", "toggle"]
        running: false
    }

    property Process volUpProc: Process {
        command: ["wpctl", "set-volume", "-l", "1.0", "@DEFAULT_AUDIO_SINK@", "5%+"]
        running: false
    }

    property Process volDownProc: Process {
        command: ["wpctl", "set-volume", "@DEFAULT_AUDIO_SINK@", "5%-"]
        running: false
    }

    function toggleMute() {
        muteProc.running = true
    }

    function volumeUp() {
        volUpProc.running = true
    }

    function volumeDown() {
        volDownProc.running = true
    }
}
