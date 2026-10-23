import Quickshell
import "bar"
import "launcher"
import "corners"
import "notification"

ShellRoot {
    Bar {}
    Launcher {}
    Notification {}

    Variants {
        model: Quickshell.screens

        delegate: Scope {
            required property var modelData

            Corner {
                screen: modelData
                pos: 0
            }
            Corner {
                screen: modelData
                pos: 1
            }
            Corner {
                screen: modelData
                pos: 2
            }
            Corner {
                screen: modelData
                pos: 3
            }
        }
    }
}
