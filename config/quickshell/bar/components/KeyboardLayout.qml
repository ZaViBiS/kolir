import "../../theme"
import Quickshell.Hyprland
import Quickshell.Io
import QtQuick

// KeyboardLayout — компактний піксельний індикатор мови
PixelBox {
    id: root
    style: "raised"
    bgColor: Colors.surfaceContainerHigh

    implicitWidth:  32
    implicitHeight: Dimensions.bar.height - 4

    property string layoutName: "EN"

    Text {
        id: langText
        anchors.centerIn: parent
        anchors.verticalCenterOffset: 1
        text: root.layoutName
        color: Colors.onSurface
        font.family: Typography.mainFont
        font.pixelSize: 14
        font.hintingPreference: Font.PreferFullHinting
        renderType: Text.NativeRendering
    }

    Process {
        command: ["hyprctl", "devices", "-j"]
        running: true
        stdout: StdioCollector {
            onStreamFinished: {
                try {
                    const data = JSON.parse(text)
                    const kb = data.keyboards
                        ? (data.keyboards.find(k => k.main) || data.keyboards[0])
                        : null
                    if (kb && kb.active_keymap) {
                        const raw = kb.active_keymap.trim()
                        root.layoutName = raw.length > 3
                            ? raw.substring(0, 2).toUpperCase()
                            : raw.toUpperCase()
                    }
                } catch (e) {
                    console.error("KeyboardLayout:", e)
                }
            }
        }
    }

    Connections {
        target: Hyprland
        function onRawEvent(event) {
            if (event.name === "activelayout") {
                const raw = event.data.split(",").slice(1).join(",").trim()
                root.layoutName = raw.length > 3
                    ? raw.substring(0, 2).toUpperCase()
                    : raw.toUpperCase()
            }
        }
    }
}
