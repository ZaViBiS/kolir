import "../../theme"
import Quickshell.Hyprland
import Quickshell.Io
import QtQuick

Item {
    id: root

    implicitWidth: label.implicitWidth
    implicitHeight: label.implicitHeight

    Text {
        id: label
        anchors.centerIn: parent
        color: Colors.onSurface
        font.family: "Google Sans"
        font.pixelSize: 16
        font.styleName: "Bold"
    }

    Process {
        command: ["hyprctl", "devices", "-j"]
        running: true
        stdout: StdioCollector {
            onStreamFinished: {
                try {
                    const data = JSON.parse(text);
                    const kb = data.keyboards ? (data.keyboards.find(k => k.main) || data.keyboards[0]) : null;
                    if (kb && kb.active_keymap)
                        label.text = kb.active_keymap;
                } catch (e) {
                    console.error("Failed to parse keyboards:", e);
                }
            }
        }
    }

    Connections {
        target: Hyprland
        function onRawEvent(event) {
            if (event.name === "activelayout")
                label.text = event.data.split(",").slice(1).join(",");
        }
    }
}
