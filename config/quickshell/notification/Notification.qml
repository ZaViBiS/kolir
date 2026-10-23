import ".."
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
            n.tracked = true;
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
            top: 10
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
            spacing: 8

            Repeater {
                model: server.trackedNotifications

                delegate: Rectangle {
                    id: card
                    required property Notification modelData

                    readonly property bool isCritical: modelData.urgency === NotificationUrgency.Critical

                    width: col.width
                    implicitHeight: content.implicitHeight + 24
                    radius: Sizes.rounding.large
                    color: root.bg
                    border.width: 2
                    border.color: isCritical ? root.critical : root.accent

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
                            margins: 12
                        }
                        spacing: 4

                        Text {
                            text: card.modelData.appName
                            color: root.accent
                            font.pixelSize: 11
                            elide: Text.ElideRight
                            width: parent.width
                        }
                        Text {
                            text: card.modelData.summary
                            color: root.fg
                            font.pixelSize: 14
                            font.bold: true
                            wrapMode: Text.Wrap
                            width: parent.width
                        }
                        Text {
                            visible: text !== ""
                            text: card.modelData.body
                            color: root.fg
                            opacity: 0.8
                            font.pixelSize: 12
                            wrapMode: Text.Wrap
                            textFormat: Text.StyledText
                            maximumLineCount: 4
                            elide: Text.ElideRight
                            width: parent.width
                        }

                        Row {
                            spacing: 6
                            visible: card.modelData.actions.length > 0

                            Repeater {
                                model: card.modelData.actions

                                delegate: Rectangle {
                                    required property var modelData
                                    radius: 6
                                    color: root.accent
                                    implicitWidth: label.implicitWidth + 16
                                    implicitHeight: label.implicitHeight + 8

                                    Text {
                                        id: label
                                        anchors.centerIn: parent
                                        text: parent.modelData.text
                                        color: root.bg
                                        font.pixelSize: 11
                                    }
                                    TapHandler {
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
