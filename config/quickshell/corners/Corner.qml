import "../theme"
import Quickshell
import Quickshell.Wayland
import QtQuick

PanelWindow {
    id: win

    property int pos: 0          // 0=TL, 1=TR, 2=BL, 3=BR
    property int radius: Dimensions.radius.medium
    property color fill: Colors.shadow

    anchors {
        top: pos < 2
        bottom: pos >= 2
        left: pos % 2 === 0
        right: pos % 2 === 1
    }

    implicitWidth: radius
    implicitHeight: radius
    color: "transparent"
    exclusionMode: ExclusionMode.Ignore
    WlrLayershell.layer: WlrLayer.Overlay
    mask: Region {}              // кліки проходять крізь

    Canvas {
        anchors.fill: parent
        rotation: [0, 90, 270, 180][win.pos]

        onPaint: {
            var ctx = getContext("2d");
            var r = win.radius;
            ctx.reset();
            ctx.fillStyle = win.fill;
            ctx.beginPath();
            ctx.moveTo(0, 0);
            ctx.lineTo(r, 0);
            ctx.arc(r, r, r, Math.PI * 1.5, Math.PI, true);
            ctx.closePath();
            ctx.fill();
        }
    }
}
