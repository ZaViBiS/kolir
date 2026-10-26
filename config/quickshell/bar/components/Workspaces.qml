import QtQuick
import Quickshell
import Quickshell.Hyprland
import "../../theme"

// Workspaces — панель робочих столів у стилі кнопок/палітри Aseprite
PixelBox {
    id: root

    style: "sunken"
    bgColor: Colors.surfaceContainerLow

    implicitHeight: Dimensions.bar.height - 4
    implicitWidth: wsRow.implicitWidth + 6

    function getAppIcon(appClass) {
        if (!appClass || appClass === "") return ""
        const cls = appClass.toLowerCase()

        // 1. Пошук у DesktopEntries
        const apps = DesktopEntries.applications.values
        for (let i = 0; i < apps.length; i++) {
            const app = apps[i]
            const id = (app.id || "").toLowerCase()
            const name = (app.name || "").toLowerCase()
            const icon = (app.icon || "").toLowerCase()

            if (id.includes(cls) || icon.includes(cls) || name.includes(cls) || cls.includes(icon)) {
                const path = Quickshell.iconPath(app.icon, "application-x-executable")
                if (path) return path
            }
        }

        // 2. Специфічні відповідності для популярних програм
        const map = {
            "zen": "zen-browser",
            "zen-browser": "zen-browser",
            "foot": "foot",
            "steam": "steam",
            "org.gnome.nautilus": "org.gnome.Nautilus",
            "md.obsidian.obsidian": "obsidian",
            "obsidian": "obsidian",
            "kitty": "kitty",
            "alacritty": "alacritty",
            "firefox": "firefox",
            "google-chrome": "google-chrome",
            "chromium": "chromium",
            "code": "visual-studio-code",
            "telegramdesktop": "telegram",
            "org.telegram.desktop": "telegram",
            "discord": "discord",
            "vesktop": "vesktop",
            "spotify": "spotify",
            "aseprite": "aseprite"
        }

        const mapped = map[cls] || appClass
        return Quickshell.iconPath(mapped, "application-x-executable")
    }



    Row {
        id: wsRow
        anchors.centerIn: parent
        spacing: 2

        Repeater {
            model: 10

            delegate: Item {
                id: wsItem

                readonly property int wsId:       index + 1
                readonly property var ws:         Hyprland.workspaces.values.find(w => w.id === wsId)
                readonly property bool hasWindow: ws ? (ws.toplevels ? ws.toplevels.values.length > 0 : false) : false
                readonly property bool isFocused: Hyprland.focusedWorkspace?.id === wsId

                // Перше вікно на цьому воркспейсі
                readonly property var topApp: {
                    if (!ws || !ws.toplevels) return null
                    const tops = ws.toplevels.values
                    return tops.length > 0 ? tops[0] : null
                }
                readonly property string appClass: topApp ? (topApp.wayland?.appId ?? topApp.lastIpcObject?.class ?? "") : ""
                readonly property string iconSource: wsItem.hasWindow ? root.getAppIcon(wsItem.appClass) : ""

                implicitWidth:  22
                implicitHeight: 22

                // ── Квадратик у стилі Aseprite ──
                PixelBox {
                    anchors.fill: parent
                    style: wsItem.isFocused ? "raised" : (wsItem.hasWindow ? "raised" : "flat")
                    pressed: wsMouse.pressed
                    borderColor: wsItem.isFocused ? Colors.primary : Colors.outlineVariant
                    bgColor: {
                        if (wsItem.isFocused) return Colors.surfaceContainerHighest
                        if (wsItem.hasWindow) return Colors.surfaceContainerHigh
                        return wsMouse.containsMouse ? Colors.surfaceContainerHigh : Colors.surfaceContainer
                    }

                    // Акцентна 1px рамка для активного воркспейсу
                    Rectangle {
                        anchors.fill: parent
                        color: "transparent"
                        border.width: 1
                        border.color: Colors.primary
                        visible: wsItem.isFocused
                    }

                    // ── Іконка програми (якщо є вікно і знайдено іконку) ──
                    Image {
                        id: appIcon
                        anchors.centerIn: parent
                        visible: wsItem.hasWindow && wsItem.iconSource !== "" && status === Image.Ready
                        width:  16
                        height: 16
                        sourceSize: Qt.size(16, 16)
                        source: wsItem.iconSource
                        smooth: false
                    }

                    // ── Номер робочого столу ──
                    Text {
                        anchors.centerIn: parent
                        anchors.verticalCenterOffset: 1
                        visible: !wsItem.hasWindow || !appIcon.visible
                        text: wsItem.wsId
                        font.family: Typography.mainFont
                        font.pixelSize: 14
                        font.hintingPreference: Font.PreferFullHinting
                        renderType: Text.NativeRendering
                        color: {
                            if (wsItem.isFocused) return Colors.primary
                            if (wsItem.hasWindow) return Colors.onSurface
                            return Colors.outlineVariant
                        }
                    }

                    // Маленький піксельний маркер знизу якщо є вікна
                    Rectangle {
                        anchors {
                            bottom: parent.bottom
                            bottomMargin: 2
                            horizontalCenter: parent.horizontalCenter
                        }
                        width: 4
                        height: 2
                        visible: wsItem.hasWindow && appIcon.visible
                        color: wsItem.isFocused ? Colors.primary : Colors.outline
                    }
                }

                MouseArea {
                    id: wsMouse
                    anchors.fill: parent
                    hoverEnabled: true
                    cursorShape: Qt.PointingHandCursor
                    onClicked: Hyprland.dispatch(`workspace ${wsItem.wsId}`)
                }
            }
        }
    }
}
