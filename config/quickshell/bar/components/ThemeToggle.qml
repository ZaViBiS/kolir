import "../../theme"
import Quickshell
import Quickshell.Io
import QtQuick

// ThemeToggle — піксельна raised-кнопка зміни теми
PixelBox {
    id: root

    style: "raised"
    pressed: mouse.pressed
    bgColor: mouse.containsMouse
        ? Colors.surfaceContainerHighest
        : Colors.surfaceContainerHigh

    implicitWidth:  24
    implicitHeight: Dimensions.bar.height - 4

    property string currentTheme: "dark"

    FileView {
        path: Quickshell.env("HOME") + "/.cache/current_theme"
        watchChanges: true
        onFileChanged: this.reload()
        onLoaded: {
            const t = this.text().trim()
            if (t === "light" || t === "dark") root.currentTheme = t
        }
    }

    Text {
        anchors.centerIn: parent
        anchors.verticalCenterOffset: 1
        // Прості ASCII іконки: @ = "сонце" (круглий), # = "ніч" (квадратний)
        text: root.currentTheme === "light" ? "@" : "#"
        color: Colors.primary
        font.family: Typography.mainFont
        font.pixelSize: 14
        font.hintingPreference: Font.PreferFullHinting
        renderType: Text.NativeRendering
    }

    MouseArea {
        id: mouse
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        onClicked: toggleProc.running = true
    }

    Process {
        id: toggleProc
        command: ["sh", Quickshell.env("HOME") + "/.config/hypr/scripts/toggle-theme.sh"]
        running: false
    }
}
