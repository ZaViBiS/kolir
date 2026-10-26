import "../theme"
import "./components"
import Quickshell
import Quickshell.Io
import Quickshell.Wayland
import QtQuick

PanelWindow {
    id: bar
    WlrLayershell.namespace: "bar"

    anchors { top: true; left: true; right: true }
    color: "transparent"
    implicitHeight: Dimensions.bar.height

    // ── Тіло статусбара — суцільна смуга без заокруглень, як у Aseprite ──
    Rectangle {
        anchors.fill: parent
        color: Colors.surfaceContainer
        radius: 0

        // ── Нижній 1px роздільник ──
        Rectangle {
            anchors { bottom: parent.bottom; left: parent.left; right: parent.right }
            height: 1
            color: Colors.shadow
        }

        // ╔══════════════════════════════════════════════════════╗
        // ║  ЛІВИЙ БЛОК: ActiveWindow                           ║
        // ╚══════════════════════════════════════════════════════╝
        ActiveWindow {
            id: activeWindow
            anchors.left: parent.left
            anchors.leftMargin: 4
            anchors.verticalCenter: parent.verticalCenter
        }

        // ╔══════════════════════════════════════════════════════╗
        // ║  ЦЕНТР: Workspaces                                  ║
        // ╚══════════════════════════════════════════════════════╝
        Workspaces {
            id: workspaces
            anchors.centerIn: parent
        }

        // ╔══════════════════════════════════════════════════════╗
        // ║  ПРАВИЙ БЛОК: NowPlaying + Clock + Lang + Theme     ║
        // ╚══════════════════════════════════════════════════════╝
        Row {
            anchors.right: parent.right
            anchors.rightMargin: 4
            anchors.verticalCenter: parent.verticalCenter
            spacing: 4

            // ── NowPlaying ──
            NowPlaying {
                id: nowPlaying
                anchors.verticalCenter: parent.verticalCenter
                visible: nowPlaying.hasPlayer
            }

            // ── Гучність ──
            Volume {
                id: volumeIndicator
                anchors.verticalCenter: parent.verticalCenter
            }

            // ── Годинник + мова: sunken field (фіксована ширина проти стрибків) ──
            PixelBox {
                style: "sunken"
                bgColor: Colors.surfaceContainerLow
                height: Dimensions.bar.height - 4
                width: 254
                anchors.verticalCenter: parent.verticalCenter

                SystemClock {
                    id: sysClock
                    precision: SystemClock.Seconds
                }

                Row {
                    id: clockInner
                    anchors.centerIn: parent
                    spacing: 8
                    height: parent.height

                    Text {
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.verticalCenterOffset: 1
                        width: 194
                        horizontalAlignment: Text.AlignHCenter
                        color: Colors.onSurface
                        font.family: Typography.mainFont
                        font.pixelSize: 14
                        font.hintingPreference: Font.PreferFullHinting
                        renderType: Text.NativeRendering
                        text: Qt.formatDateTime(sysClock.date, "ddd, dd MMM  HH:mm:ss")
                    }

                    KeyboardLayout {
                        anchors.verticalCenter: parent.verticalCenter
                    }
                }
            }

            // ── Кнопка теми ──
            ThemeToggle {
                anchors.verticalCenter: parent.verticalCenter
            }
        }
    }
}
