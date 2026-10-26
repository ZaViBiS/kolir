import "../../theme"
import Quickshell.Services.Mpris
import QtQuick

// NowPlaying — sunken поле з піснею
PixelBox {
    id: root
    style: "sunken"
    bgColor: Colors.surfaceContainerLow

    readonly property var player: {
        const list = Mpris.players.values
        return list.find(p => p.isPlaying) ?? list[0] ?? null
    }
    readonly property bool hasPlayer: player !== null
    readonly property string trackText: player
        ? ((player.trackArtist ? player.trackArtist + " - " : "") + (player.trackTitle || ""))
        : ""

    visible: hasPlayer && trackText !== ""

    implicitWidth:  220
    implicitHeight: Dimensions.bar.height - 4
    clip: true

    Row {
        anchors.centerIn: parent
        spacing: 4
        height: parent.height

        Text {
            anchors.verticalCenter: parent.verticalCenter
            anchors.verticalCenterOffset: 1
            text: "~"
            color: Colors.primary
            font.family: Typography.mainFont
            font.pixelSize: 14
            font.hintingPreference: Font.PreferFullHinting
            renderType: Text.NativeRendering
        }

        Text {
            id: trackLabel
            anchors.verticalCenter: parent.verticalCenter
            anchors.verticalCenterOffset: 1
            text: root.trackText
            color: Colors.onSurface
            font.family: Typography.mainFont
            font.pixelSize: 14
            font.hintingPreference: Font.PreferFullHinting
            renderType: Text.NativeRendering
            elide: Text.ElideRight
            width: 184
        }
    }
}
