pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Io

QtObject {
    id: root

    property var colors: ({
            primary: root.primary,
            on_primary: root.onPrimary,
            primary_container: root.primaryContainer,
            on_primary_container: root.onPrimaryContainer,
            surface_container_highest: root.surfaceContainerHighest,
            surface_container_high: root.surfaceContainerHigh,
            on_surface: root.onSurface
        })

    readonly property string home: Quickshell.env("HOME")

    property color primary: "#86d6be"
    property color onPrimary: ("#00382c")
    property color primaryContainer: "#005141"
    property color onPrimaryContainer: ("#a2f2d9")
    property color inversePrimary: "#0f6b57"
    property color primaryFixed: "#a2f2d9"
    property color primaryFixedDim: "#86d6be"
    property color onPrimaryFixed: ("#002019")
    property color onPrimaryFixedVariant: ("#005141")

    property color secondary: "#b2ccc2"
    property color onSecondary: ("#1d352e")
    property color secondaryContainer: "#344c44"
    property color onSecondaryContainer: ("#cde9de")
    property color secondaryFixed: "#cde9de"
    property color secondaryFixedDim: "#b2ccc2"
    property color onSecondaryFixed: ("#072019")
    property color onSecondaryFixedVariant: ("#344c44")

    property color tertiary: "#a9cbe3"
    property color onTertiary: ("#0e3446")
    property color tertiaryContainer: "#294b5e"
    property color onTertiaryContainer: ("#c5e7ff")
    property color tertiaryFixed: "#c5e7ff"
    property color tertiaryFixedDim: "#a9cbe3"
    property color onTertiaryFixed: ("#001e2d")
    property color onTertiaryFixedVariant: ("#294b5e")

    property color error: "#ffb4ab"
    property color onError: ("#690005")
    property color errorContainer: "#93000a"
    property color onErrorContainer: ("#ffdad6")

    property color surfaceDim: "#0f1512"
    property color surface: "#0f1512"
    property color surfaceTint: "#86d6be"
    property color surfaceBright: "#343b38"
    property color surfaceContainerLowest: "#090f0d"
    property color surfaceContainerLow: "#171d1b"
    property color surfaceContainer: "#1b211f"
    property color surfaceContainerHigh: "#252b29"
    property color surfaceContainerHighest: "#303634"
    property color onSurface: ("#dee4e0")
    property color onSurfaceVariant: ("#bfc9c4")

    property color outline: "#89938e"
    property color outlineVariant: "#3f4945"

    property color inverseSurface: "#dee4e0"
    property color inverseOnSurface: "#2b322f"

    property color surfaceVariant: "#3f4945"
    property color background: "#0f1512"
    property color onBackground: ("#dee4e0")
    property color shadow: "#000000"
    property color scrim: "#000000"
    property color sourceColor: "#3a7867"

    function snakeToCamel(str) {
        return str.replace(/_([a-z])/g, function (match, letter) {
            return letter.toUpperCase();
        });
    }

    property FileView _fileView: FileView {
        path: root.home + "/.config/quickshell/colors.json"
        watchChanges: true

        onFileChanged: {
            this.reload();
        }

        onLoaded: {
            try {
                var content = this.text();
                if (content && content.trim() !== "") {
                    var parsed = JSON.parse(content);
                    root.colors = parsed;

                    for (var jsonKey in parsed) {
                        var qmlProperty = root.snakeToCamel(jsonKey);
                        if (qmlProperty in root) {
                            root[qmlProperty] = parsed[jsonKey];
                        }
                    }
                }
            } catch (e) {
                console.error("Colors.qml: Помилка парсингу colors.json ->", e);
            }
        }

        onLoadFailed: {
            console.error("Colors.qml: Не вдалося завантажити colors.json");
        }
    }
}
