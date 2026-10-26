// PixelBox — ретро-рамка в стилі Aseprite/Win9x
// style: "raised" — опукла кнопка (світло зверху/зліва, тінь знизу/справа)
//        "sunken" — заглиблене поле (тінь зверху/зліва, світло знизу/справа)
//        "flat"   — 1px тонка рамка без 3D бевелю (як комірка сітки/палітри)
import QtQuick
import "../../theme"

Item {
    id: root

    property string style: "raised"
    property bool   pressed: false
    property color  bgColor: Colors.surfaceContainerHigh
    property color  borderColor: Colors.shadow

    // Кольори бевелю з поточної теми
    readonly property color _hi:  Colors.surfaceContainerHighest
    readonly property color _sha: Colors.outlineVariant
    readonly property color _out: Colors.shadow

    // Чи є ефект заглиблення (sunken або натиснута кнопка)
    readonly property bool _sunken: (style === "sunken") || (style === "raised" && pressed)

    default property alias content: _inner.data

    // ── Зовнішній контур 1px ──
    Rectangle {
        anchors.fill: parent
        color: "transparent"
        border.width: 1
        border.color: root.style === "flat" ? root.borderColor : root._out
        visible: true
    }

    // ── Фон ──
    Rectangle {
        anchors {
            fill: parent
            margins: 1
        }
        color: root.bgColor
    }

    // ── 3D Бевель: highlight зверху і зліва ──
    // top
    Rectangle {
        visible: root.style !== "flat"
        x: 1; y: 1
        width: parent.width - 2
        height: 1
        color: root._sunken ? root._sha : root._hi
    }
    // left
    Rectangle {
        visible: root.style !== "flat"
        x: 1; y: 1
        width: 1
        height: parent.height - 2
        color: root._sunken ? root._sha : root._hi
    }

    // ── 3D Бевель: shadow знизу і справа ──
    // bottom
    Rectangle {
        visible: root.style !== "flat"
        x: 1; y: parent.height - 2
        width: parent.width - 2
        height: 1
        color: root._sunken ? root._hi : root._sha
    }
    // right
    Rectangle {
        visible: root.style !== "flat"
        x: parent.width - 2; y: 1
        width: 1
        height: parent.height - 2
        color: root._sunken ? root._hi : root._sha
    }

    // ── Контентна зона (з тактильним зсувом на 1px тільки при натисканні) ──
    Item {
        id: _inner
        anchors {
            fill: parent
            margins: root.style === "flat" ? 1 : 2
            topMargin:  (root.style === "flat" ? 1 : 2) + (root.pressed ? 1 : 0)
            leftMargin: (root.style === "flat" ? 1 : 2) + (root.pressed ? 1 : 0)
        }
    }
}
