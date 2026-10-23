import QtQuick

Rectangle {
    id: root

    property string text: ""
    property string fontFamily: "Google Sans Flex"   // підстав назву з fc-list
    property int fontSize: 14
    signal clicked

    // ширина рахується по найжирнішому стану, щоб кнопка не змінювала розмір
    TextMetrics {
        id: widest
        text: root.text
        font.family: root.fontFamily
        font.pixelSize: root.fontSize
        font.weight: 700
    }

    implicitHeight: 36
    implicitWidth: widest.width + 24
    radius: height / 2

    color: mouse.pressed ? Theme.colors.primary_container : mouse.containsMouse ? Theme.colors.surface_container_highest : Theme.colors.surface_container_high

    Behavior on color {
        ColorAnimation {
            duration: 120
        }
    }

    Text {
        id: label
        anchors.centerIn: parent
        text: root.text
        font.family: root.fontFamily
        font.pixelSize: root.fontSize
        font.weight: mouse.containsMouse ? 700 : 400
        color: mouse.pressed ? Theme.colors.on_primary_container : Theme.colors.on_surface

        Behavior on font.weight {
            NumberAnimation {
                duration: 200
                easing.type: Easing.OutCubic
            }
        }
        Behavior on color {
            ColorAnimation {
                duration: 120
            }
        }
    }

    MouseArea {
        id: mouse
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        onClicked: root.clicked()
    }
}
