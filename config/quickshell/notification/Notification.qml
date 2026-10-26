import ".."
import "../bar/components"
import "../theme"
import QtQuick
import Quickshell
import Quickshell.Wayland
import Quickshell.Services.Notifications

Scope {
    id: root

    readonly property color bg: Colors.surfaceContainer
    readonly property color fg: Colors.onSurface
    readonly property color accent: Colors.primary
    readonly property color critical: Colors.error

    NotificationServer {
        id: server
        bodySupported: true
        actionsSupported: true
        imageSupported: true
        keepOnReload: true

        onNotification: n => {
            n.tracked = true
        }
    }

    PanelWindow {
        id: win
        visible: server.trackedNotifications.values.length > 0
        color: "transparent"

        anchors {
            top: true
            right: true
        }
        margins {
            top: Dimensions.bar.height + 6
            right: 10
        }

        implicitWidth: 360
        implicitHeight: col.implicitHeight

        exclusionMode: ExclusionMode.Ignore
        WlrLayershell.layer: WlrLayer.Overlay
        WlrLayershell.namespace: "notifications"

        Column {
            id: col
            width: parent.width
            spacing: 6

            Repeater {
                model: server.trackedNotifications

                delegate: PixelBox {
                    id: card
                    required property Notification modelData

                    readonly property bool isCritical: modelData.urgency === NotificationUrgency.Critical

                    width: col.width
                    implicitHeight: content.implicitHeight + 20
                    style: "raised"
                    bgColor: root.bg
                    borderColor: isCritical ? root.critical : Colors.shadow

                    // Автозакриття: критичні лишаються, поки не закриєш вручну
                    Timer {
                        running: !card.isCritical && !hover.hovered
                        interval: card.modelData.expireTimeout > 0 ? card.modelData.expireTimeout * 1000 : 5000
                        onTriggered: card.modelData.expire()
                    }

                    HoverHandler {
                        id: hover
                    }

                    // Клік по картці закриває її
                    TapHandler {
                        onTapped: card.modelData.dismiss()
                    }

                    Column {
                        id: content
                        anchors {
                            left: parent.left
                            right: parent.right
                            top: parent.top
                            margins: 8
                        }
                        spacing: 4

                        // Заголовок програми
                        Text {
                            text: card.modelData.appName
                            color: card.isCritical ? root.critical : root.accent
                            font.family: Typography.mainFont
                            font.pixelSize: 14
                            font.hintingPreference: Font.PreferFullHinting
                            renderType: Text.NativeRendering
                            anchors.verticalCenterOffset: 1
                            elide: Text.ElideRight
                            width: parent.width
                        }

                        // Тема повідомлення
                        Text {
                            text: card.modelData.summary
                            color: root.fg
                            font.family: Typography.mainFont
                            font.pixelSize: 14
                            font.hintingPreference: Font.PreferFullHinting
                            renderType: Text.NativeRendering
                            wrapMode: Text.Wrap
                            width: parent.width
                        }

                        // Тіло повідомлення
                        Text {
                            visible: text !== ""
                            text: card.modelData.body
                            color: root.fg
                            opacity: 0.8
                            font.family: Typography.mainFont
                            font.pixelSize: 14
                            font.hintingPreference: Font.PreferFullHinting
                            renderType: Text.NativeRendering
                            wrapMode: Text.Wrap
                            textFormat: Text.StyledText
                            maximumLineCount: 4
                            elide: Text.ElideRight
                            width: parent.width
                        }

                        // Кнопки дій у ретро-стилі
                        Row {
                            spacing: 6
                            visible: card.modelData.actions.length > 0

                            Repeater {
                                model: card.modelData.actions

                                delegate: PixelBox {
                                    required property var modelData
                                    style: "raised"
                                    bgColor: actionTap.pressed ? Colors.surfaceContainerHighest : Colors.surfaceContainerHigh
                                    implicitWidth: actLabel.implicitWidth + 12
                                    implicitHeight: 22

                                    Text {
                                        id: actLabel
                                        anchors.centerIn: parent
                                        anchors.verticalCenterOffset: 1
                                        text: parent.modelData.text
                                        color: Colors.onSurface
                                        font.family: Typography.mainFont
                                        font.pixelSize: 14
                                        font.hintingPreference: Font.PreferFullHinting
                                        renderType: Text.NativeRendering
                                    }

                                    TapHandler {
                                        id: actionTap
                                        onTapped: parent.modelData.invoke()
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}
