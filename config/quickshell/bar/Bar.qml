import "../theme"
import "./components"
import Quickshell
import Quickshell.Io
import QtQuick.Layouts
import Quickshell.Wayland
import QtQuick

PanelWindow {
    id: bar
    WlrLayershell.namespace: "bar"

    anchors {
        top: true
        left: true
        right: true
    }

    color: "transparent"
    implicitHeight: Dimensions.bar.height

    Rectangle {
        anchors.fill: parent
        color: Colors.surfaceContainer
        radius: Dimensions.radius.medium

        opacity: 0.85

        // 1. cut up corners
        // Rectangle {
        //     anchors {
        //         top: parent.top
        //         left: parent.left
        //         right: parent.right
        //     }
        //     height: 20
        //     color: parent.color
        // }

        // 2. left: ActiveWindow
        RowLayout {
            anchors.left: parent.left
            anchors.leftMargin: Dimensions.spacing.large
            anchors.verticalCenter: parent.verticalCenter

            ActiveWindow {
                Layout.preferredWidth: 200
                Layout.preferredHeight: 28
            }
        }

        // 3. center: Workspaces
        Workspaces {
            id: workspacesWidget
            anchors.centerIn: parent
        }

        // 4. right: clock & language
        Rectangle {
            id: clockRectangle

            color: Colors.surfaceContainerHigh
            radius: Dimensions.radius.large

            implicitWidth: clockRow.implicitWidth + (Dimensions.padding.horizontal * 2)
            implicitHeight: Dimensions.insideBarSize.rectangleHight

            anchors.left: workspacesWidget.right
            anchors.leftMargin: Dimensions.spacing.large
            anchors.verticalCenter: parent.verticalCenter

            SystemClock {
                id: sysClock
                precision: SystemClock.Seconds
            }

            RowLayout {
                id: clockRow
                anchors.centerIn: parent
                spacing: Dimensions.spacing.large

                Text {
                    id: clock
                    color: Colors.onSurface
                    font.family: "Google Sans"
                    font.pixelSize: 16
                    font.styleName: "Bold"
                    text: Qt.formatDateTime(sysClock.date, "ddd, dd MMM yyyy HH:mm:ss")
                }

                KeyboardLayout {
                    id: language
                }
            }
        }
        Rectangle {
            color: Colors.surfaceContainerHigh
            radius: Dimensions.radius.large
            implicitWidth: nowPlaying.implicitWidth + Dimensions.padding.horizontal
            implicitHeight: nowPlaying.implicitHeight + Dimensions.padding.vertical

            anchors.right: workspacesWidget.left
            anchors.verticalCenter: parent.verticalCenter
            anchors.rightMargin: Dimensions.spacing.large

            NowPlaying {
                id: nowPlaying

                anchors.centerIn: parent
            }
        }

        // 5. right-most: theme toggle button
        Rectangle {
            id: themeToggleBtn

            // читаємо стан теми з файлу
            property string currentTheme: "dark"

            FileView {
                path: Quickshell.env("HOME") + "/.cache/current_theme"
                watchChanges: true
                onFileChanged: this.reload()
                onLoaded: {
                    var t = this.text().trim();
                    if (t === "light" || t === "dark")
                        themeToggleBtn.currentTheme = t;
                }
            }

            color: themeToggleMouse.pressed
                ? Colors.primaryContainer
                : themeToggleMouse.containsMouse
                    ? Colors.surfaceContainerHighest
                    : Colors.surfaceContainerHigh

            Behavior on color {
                ColorAnimation { duration: 150 }
            }

            radius: Dimensions.radius.large
            implicitHeight: Dimensions.insideBarSize.rectangleHight
            implicitWidth: themeIconText.implicitWidth + (Dimensions.padding.horizontal * 2)

            anchors.right: parent.right
            anchors.rightMargin: Dimensions.spacing.large
            anchors.verticalCenter: parent.verticalCenter

            // анімація при кліку — пружній пульс
            scale: themeToggleMouse.pressed ? 0.88 : 1.0
            Behavior on scale {
                NumberAnimation {
                    duration: 180
                    easing.type: Easing.OutBack
                }
            }

            Item {
                id: iconContainer
                anchors.centerIn: parent
                implicitWidth: themeIconText.implicitWidth
                implicitHeight: themeIconText.implicitHeight

                // іконка: ☀ light, 󰖔 dark (Nerd Fonts)
                Text {
                    id: themeIconText
                    anchors.centerIn: parent
                    text: themeToggleBtn.currentTheme === "light" ? "☀" : "󰖔"
                    font.pixelSize: 16
                    color: themeToggleMouse.pressed ? Colors.onPrimaryContainer : Colors.onSurface

                    Behavior on color {
                        ColorAnimation { duration: 150 }
                    }

                    // анімація зміни іконки: fade + rotate + scale
                    opacity: 1.0
                    rotation: 0
                    scale: 1.0

                    states: State {
                        name: "switching"
                        PropertyChanges { target: themeIconText; opacity: 0; rotation: 45; scale: 0.5 }
                    }

                    transitions: Transition {
                        from: ""
                        to: "switching"
                        reversible: true
                        SequentialAnimation {
                            // fade out + rotate
                            ParallelAnimation {
                                NumberAnimation { property: "opacity"; duration: 150; easing.type: Easing.InCubic }
                                NumberAnimation { property: "rotation"; duration: 150; easing.type: Easing.InCubic }
                                NumberAnimation { property: "scale"; duration: 150; easing.type: Easing.InCubic }
                            }
                            // зміна тексту відбувається тут (у середині анімації)
                            // fade in
                            ParallelAnimation {
                                NumberAnimation { property: "opacity"; duration: 200; easing.type: Easing.OutCubic }
                                NumberAnimation { property: "rotation"; duration: 200; easing.type: Easing.OutBack }
                                NumberAnimation { property: "scale"; duration: 200; easing.type: Easing.OutBack }
                            }
                        }
                    }
                }
            }

            MouseArea {
                id: themeToggleMouse
                anchors.fill: parent
                hoverEnabled: true
                cursorShape: Qt.PointingHandCursor
                onClicked: {
                    themeIconText.state = "switching";
                    toggleThemeProcess.running = true;
                    switchTimer.restart();
                }
            }

            // скидаємо стан анімації після переходу
            Timer {
                id: switchTimer
                interval: 160
                onTriggered: themeIconText.state = ""
            }

            Process {
                id: toggleThemeProcess
                command: ["sh", Quickshell.env("HOME") + "/.config/hypr/scripts/toggle-theme.sh"]
                running: false
            }
        }
    }
}
