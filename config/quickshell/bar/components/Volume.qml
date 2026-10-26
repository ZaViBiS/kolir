import QtQuick
import "../../theme"

// Volume — піксельний індикатор гучності в bar у стилі Aseprite
PixelBox {
    id: root

    style: "raised"
    pressed: mouse.pressed
    bgColor: mouse.containsMouse ? Colors.surfaceContainerHighest : Colors.surfaceContainerHigh

    implicitWidth: 76
    implicitHeight: Dimensions.bar.height - 4

    Text {
        id: volText
        anchors.centerIn: parent
        anchors.verticalCenterOffset: 1
        font.family: Typography.mainFont
        font.pixelSize: 14
        font.hintingPreference: Font.PreferFullHinting
        renderType: Text.NativeRendering

        text: AudioService.muted ? "MUTE" : ("VOL " + AudioService.volume + "%")
        color: AudioService.muted ? Colors.error : (AudioService.volume > 0 ? Colors.onSurface : Colors.outlineVariant)
    }

    MouseArea {
        id: mouse
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor

        onClicked: AudioService.toggleMute()

        onWheel: wheel => {
            if (wheel.angleDelta.y > 0) {
                AudioService.volumeUp()
            } else if (wheel.angleDelta.y < 0) {
                AudioService.volumeDown()
            }
        }
    }
}
