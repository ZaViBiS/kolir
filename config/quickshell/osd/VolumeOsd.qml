import QtQuick
import Quickshell
import Quickshell.Wayland
import "../bar/components"
import "../theme"

Scope {
    id: root

    Timer {
        id: hideTimer
        interval: 1600
        repeat: false
        onTriggered: osdWin.visible = false
    }

    Connections {
        target: AudioService
        function onVolumeChangedManually(vol, isMuted) {
            osdWin.visible = true
            hideTimer.restart()
        }
    }

    PanelWindow {
        id: osdWin

        visible: false
        color: Colors.surfaceContainer

        anchors {
            bottom: true
        }
        margins.bottom: 70

        implicitWidth: 220
        implicitHeight: 56

        exclusionMode: ExclusionMode.Ignore
        WlrLayershell.layer: WlrLayer.Overlay
        WlrLayershell.namespace: "volume-osd"

        // ── Вікно OSD у стилі Aseprite ──
        PixelBox {
            anchors.fill: parent
            style: "raised"
            bgColor: Colors.surfaceContainer

            Column {
                anchors.fill: parent
                anchors.margins: 6
                spacing: 6

                // ── Заголовок: AUDIO / % ──
                Item {
                    width: parent.width
                    height: 16

                    Text {
                        anchors.left: parent.left
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.verticalCenterOffset: 1
                        text: AudioService.muted ? "MUTED" : "VOLUME"
                        font.family: Typography.mainFont
                        font.pixelSize: 14
                        font.hintingPreference: Font.PreferFullHinting
                        renderType: Text.NativeRendering
                        color: AudioService.muted ? Colors.error : Colors.primary
                    }

                    Text {
                        anchors.right: parent.right
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.verticalCenterOffset: 1
                        text: AudioService.volume + "%"
                        font.family: Typography.mainFont
                        font.pixelSize: 14
                        font.hintingPreference: Font.PreferFullHinting
                        renderType: Text.NativeRendering
                        color: Colors.onSurface
                    }
                }

                // ── Піксельний сегментований прогресбар (10 ретро-блоків) ──
                PixelBox {
                    width: parent.width
                    height: 18
                    style: "sunken"
                    bgColor: Colors.surfaceContainerLow

                    Row {
                        anchors.centerIn: parent
                        spacing: 2

                        Repeater {
                            model: 10

                            delegate: Rectangle {
                                readonly property int blockIndex: index
                                readonly property bool isFilled: (blockIndex + 1) * 10 <= AudioService.volume || (blockIndex * 10 < AudioService.volume && (blockIndex + 1) * 10 > AudioService.volume)

                                width: 16
                                height: 10
                                color: isFilled
                                    ? (AudioService.muted ? Colors.error : Colors.primary)
                                    : Colors.surfaceContainerHigh
                                border.width: 1
                                border.color: isFilled
                                    ? Colors.shadow
                                    : Colors.outlineVariant
                            }
                        }
                    }
                }
            }
        }
    }
}
