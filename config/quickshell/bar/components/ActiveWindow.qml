import "../../theme"
import Quickshell.Hyprland
import QtQuick

// ActiveWindow — заглиблене поле з назвою активного вікна
PixelBox {
    id: root

    style: "sunken"
    bgColor: Colors.surfaceContainerLow

    implicitWidth: 210
    height: Dimensions.bar.height - 4
    visible: Hyprland.activeToplevel !== null

    Item {
        anchors.fill: parent

        Text {
            id: arrow
            anchors.left: parent.left
            anchors.leftMargin: 4
            anchors.verticalCenter: parent.verticalCenter
            anchors.verticalCenterOffset: 1
            text: ">"
            color: Colors.primary
            font.family: Typography.mainFont
            font.pixelSize: 14
            font.hintingPreference: Font.PreferFullHinting
            renderType: Text.NativeRendering
        }

        Text {
            id: windowTitle
            anchors.left: arrow.right
            anchors.leftMargin: 4
            anchors.right: parent.right
            anchors.rightMargin: 3
            anchors.verticalCenter: parent.verticalCenter
            anchors.verticalCenterOffset: 1
            text: {
                const c = Hyprland.activeToplevel
                if (!c) return ""
                return c.title !== "" ? c.title : (c.wayland?.appId ?? c.lastIpcObject?.class ?? "")
            }
            color: Colors.onSurface
            font.family: Typography.mainFont
            font.pixelSize: 14
            font.hintingPreference: Font.PreferFullHinting
            renderType: Text.NativeRendering
            elide: Text.ElideRight
        }
    }
}
