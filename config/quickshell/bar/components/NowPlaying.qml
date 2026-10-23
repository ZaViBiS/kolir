import "../../theme"
import Quickshell.Services.Mpris
import QtQuick

Item {
    id: root

    // активний плеєр: той, що грає, інакше перший зі списку
    readonly property var player: {
        const list = Mpris.players.values;
        return list.find(p => p.isPlaying) ?? list[0] ?? null;
    }

    visible: player !== null
    implicitWidth: 200
    implicitHeight: 28

    Text {
        id: label
        anchors.centerIn: parent
        color: Colors.onSurface
        font.family: "Google Sans"
        font.pixelSize: 16
        font.styleName: "Bold"
        elide: Text.ElideRight
        width: Math.min(implicitWidth, 190)

        text: root.player ? (root.player.trackArtist ? root.player.trackArtist + " - " : "") + root.player.trackTitle : ""
    }
}
