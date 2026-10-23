import ".."
import "../theme"
import Quickshell
import Quickshell.Wayland
import Quickshell.Io
import QtQuick

Scope {
    IpcHandler {
        target: "launcher"
        function toggle(): void {
            win.visible = !win.visible;
        }
    }

    PanelWindow {
        id: win
        visible: false
        implicitWidth: 500
        implicitHeight: 300
        color: "transparent"

        WlrLayershell.layer: WlrLayer.Overlay
        WlrLayershell.keyboardFocus: WlrKeyboardFocus.Exclusive

        onVisibleChanged: if (visible) {
            search.text = "";
            search.forceActiveFocus();
        }

        Rectangle {
            anchors.fill: parent
            radius: Dimensions.radius.large // HACK:
            color: Colors.surfaceContainer

            Column {
                anchors.fill: parent
                anchors.margins: 12
                spacing: 8

                TextInput {
                    id: search
                    width: parent.width
                    color: Colors.onSurface
                    font.pixelSize: 20
                    font.family: "Google Sans"
                    Keys.onEscapePressed: win.visible = false
                    Keys.onDownPressed: list.incrementCurrentIndex()
                    Keys.onUpPressed: list.decrementCurrentIndex()
                    Keys.onReturnPressed: {
                        if (list.currentItem) {
                            list.model[list.currentIndex].execute();
                            win.visible = false;
                        }
                    }
                }

                ListView {
                    id: list
                    width: parent.width
                    height: parent.height - search.height - 8
                    clip: true
                    currentIndex: 0

                    model: DesktopEntries.applications.values.filter(e => e.name.toLowerCase().includes(search.text.toLowerCase()))

                    delegate: Rectangle {
                        required property var modelData
                        required property int index
                        width: list.width
                        height: 40
                        radius: 12
                        color: ListView.isCurrentItem ? Colors.primaryContainer : "transparent"

                        Image {
                            id: icon
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.left: parent.left
                            anchors.leftMargin: 12
                            width: 24
                            height: 24
                            sourceSize.width: 24
                            sourceSize.height: 24
                            source: Quickshell.iconPath(modelData.icon, "application-x-executable")
                        }

                        Text {
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.left: icon.right
                            anchors.leftMargin: 12
                            text: modelData.name
                            color: Colors.onSurface
                            font.family: "Google Sans"
                            font.pixelSize: 14
                        }
                    }
                }
            }
        }
    }
}
