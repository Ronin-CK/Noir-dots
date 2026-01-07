import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Io

Item {
    id: root

    // -- Data --
    property var keyData: ({})
    property int keycode: keyData.keycode || 0
    property string shape: keyData.shape || "normal"

    // -- NEW: State Properties --
    property int currentShiftState: 0

    // Helpers to make code readable
    readonly property bool isShiftActive: currentShiftState > 0
    readonly property bool isShiftLocked: currentShiftState === 2

    // Signals
    signal requestCycleShift()
    signal requestResetShift()

    // -- Dimensions --
    property real baseWidth: 50
    property real baseHeight: 50

    property var widthMultiplier: ({
        "normal": 1, "fn": 1, "tab": 1.5, "caps": 1.8,
        "shift": 2.4, "space": 6, "enter": 2, "expand": 1, "empty": 1
    })

    implicitWidth: baseWidth * (widthMultiplier[shape] || 1)
    implicitHeight: baseHeight
    Layout.fillWidth: shape === "expand" || shape === "space"

    readonly property bool isSpecial: shape !== "normal" && shape !== "space"
    readonly property bool isShiftKey: keycode === 42 || keycode === 54

    // -- Visual Container --
    Rectangle {
        id: bg
        anchors.fill: parent
        radius: height / 2

        // -- COLORS --
        // 1. Locked -> Purple (#cba6f7)
        // 2. Active (One-shot) -> Blue (#89b4fa)
        // 3. Normal -> Dark Gray
        color: (root.isShiftKey && root.isShiftLocked) ? "#cba6f7" :
        (tapHandler.pressed || (root.isShiftKey && root.isShiftActive)) ? "#89b4fa" :
        (root.isSpecial ? "#45475a" : "#313244")

        // Add a border if Locked to make it obvious
        border.color: (root.isShiftKey && root.isShiftLocked) ? "#f5c2e7" :
        (tapHandler.pressed ? "transparent" : "#1e1e2e")
        border.width: (root.isShiftKey && root.isShiftLocked) ? 2 : 1

        scale: tapHandler.pressed ? 0.90 : 1.0

        Behavior on color { ColorAnimation { duration: 100 } }
        Behavior on scale { NumberAnimation { duration: 50 } }

        // -- Text Label --
        Text {
            anchors.centerIn: parent

            // Show Symbol if Shift is Active (State 1 OR 2)
            text: (root.isShiftActive && root.keyData.labelShift)
            ? root.keyData.labelShift
            : (root.keyData.label || "")

            // Text Color (Black if button is lit up)
            color: (tapHandler.pressed || (root.isShiftKey && root.isShiftActive)) ?
            "#11111b" : "#cdd6f4"

            font.pixelSize: root.isSpecial ? 20 : 18
            font.bold: root.isShiftLocked // Bold text when locked
            font.family: "Sans Serif"

            visible: shape !== "empty"
        }
    }

    // -- Logic --
    TapHandler {
        id: tapHandler
        enabled: root.shape !== "empty"
        onTapped: {
            if (root.keycode <= 0) return;

            if (root.isShiftKey) {
                // CYCLE: Off -> One-Shot -> Locked -> Off
                root.requestCycleShift()
            } else {
                // NORMAL KEY LOGIC
                var cmd = []

                if (root.isShiftActive) {
                    // Shift Logic: Shift Down -> Key -> Shift Up
                    cmd = ["ydotool", "key", "42:1", String(root.keycode) + ":1", String(root.keycode) + ":0", "42:0"]

                    // ONLY turn off shift if we are NOT locked (State 1)
                    if (!root.isShiftLocked) {
                        root.requestResetShift()
                    }
                } else {
                    // Normal Type
                    cmd = ["ydotool", "key", String(root.keycode) + ":1", String(root.keycode) + ":0"]
                }

                keyPress.command = cmd
                keyPress.running = true
            }
        }
    }

    Process {
        id: keyPress
    }
}
