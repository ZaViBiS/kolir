pragma Singleton
import QtQuick

QtObject {
    id: root

    readonly property QtObject radius: QtObject {
        readonly property int extraSmall: 4
        readonly property int small: 8
        readonly property int medium: 12
        readonly property int large: 16
        readonly property int largeIncreased: 20
        readonly property int extraLarge: 28
        readonly property int extraLargeIncreased: 32
        readonly property int extraExtraLarge: 48
        readonly property int full: 9999
    }

    readonly property QtObject bar: QtObject {
        readonly property int height: 40
    }
    // HACK: просто скопіював з gemini
    readonly property QtObject padding: QtObject {
        readonly property int horizontal: 10
        readonly property int vertical: 6
    }

    readonly property QtObject spacing: QtObject {
        readonly property int none: 0
        readonly property int large: 16
    }

    readonly property QtObject insideBarSize: QtObject {
        readonly property int rectangleHight: root.bar.height - root.padding.vertical
    }
}
