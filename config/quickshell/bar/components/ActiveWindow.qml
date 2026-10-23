import "../../theme"
import Quickshell.Hyprland
import QtQuick

Rectangle {
    id: root

    visible: Hyprland.activeToplevel !== null

    color: Colors.surfaceContainerHigh
    radius: Dimensions.radius.medium

    implicitWidth: 200
    implicitHeight: 28
    clip: true

    Text {
        id: windowTitle
        anchors.fill: parent
        anchors.leftMargin: Dimensions.padding.horizontal
        anchors.rightMargin: Dimensions.padding.horizontal

        verticalAlignment: Text.AlignVCenter
        horizontalAlignment: Text.AlignHCenter

        text: {
            const client = Hyprland.activeToplevel;
            if (!client)
                return "Desktop";
            return client.title !== "" ? client.title : client.class;
        }

        color: Colors.onSurface
        font.pixelSize: 16
        font.family: "Google Sans"
        elide: Text.ElideRight
    }
}
