import QtQuick
import QtQuick.Layouts
import Quickshell.Hyprland
import "../../theme"

Rectangle {
    id: root

    color: Colors.surfaceContainerHigh
    radius: Dimensions.radius.large

    implicitWidth: workspacesRow.implicitWidth + (Dimensions.padding.horizontal * 2)
    implicitHeight: Dimensions.bar.height - Dimensions.padding.vertical

    RowLayout {
        id: workspacesRow
        anchors.centerIn: parent
        spacing: 6

        Repeater {
            model: 10

            delegate: Item {
                id: wsItem

                readonly property int wsId: index + 1
                readonly property var ws: Hyprland.workspaces.values.find(w => w.id === wsId)
                readonly property bool hasWindow: ws ? ws.toplevels.values.length > 0 : false
                readonly property bool isFocused: Hyprland.focusedWorkspace?.id === wsId

                implicitWidth: 28
                implicitHeight: 28

                // Кнопка робочого стола
                Rectangle {
                    anchors.fill: parent
                    radius: Dimensions.radius.full

                    // 1. Колір для активного столу (Theme.tertiary)
                    // 2. Колір для всіх неактивних столів (Theme.surfaceContainerLowest)
                    color: wsItem.isFocused ? Colors.tertiary : Colors.surfaceContainerLowest
                }

                // Текст з номером
                Text {
                    anchors.centerIn: parent
                    text: hasWindow ? wsItem.wsId : "•"
                    font.pixelSize: 13
                    font.bold: true

                    color: wsItem.isFocused ? Colors.onTertiary : Colors.onSurfaceVariant
                }

                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    onClicked: Hyprland.dispatch(`workspace ${wsItem.wsId}`)
                }
            }
        }
    }
}
