import QtQuick
import QtQuick.Layouts
import "layouts.js" as Layouts

Item {
    id: oskContentRoot
    property var layouts: Layouts.byName
    property var activeLayoutName: "English (US)"

    // -- NEW: 3-State Shift --
    // 0 = Off, 1 = One-Shot, 2 = Locked
    property int shiftState: 0

    property var currentLayout: layouts[activeLayoutName] || { keys: [] }

    implicitWidth: keyRows.implicitWidth
    implicitHeight: keyRows.implicitHeight

    ColumnLayout {
        id: keyRows
        anchors.centerIn: parent
        spacing: 8

        Repeater {
            model: oskContentRoot.currentLayout.keys

            delegate: RowLayout {
                required property var modelData
                spacing: 8

                Repeater {
                    model: parent.modelData

                    delegate: OskKey {
                        keyData: modelData

                        // Pass the integer state down
                        currentShiftState: oskContentRoot.shiftState

                        // -- NEW: Logic for Cycling --
                        // If 0 -> go to 1. If 1 -> go to 2. If 2 -> go to 0.
                        onRequestCycleShift: {
                            if (oskContentRoot.shiftState === 0) oskContentRoot.shiftState = 1;
                            else if (oskContentRoot.shiftState === 1) oskContentRoot.shiftState = 2;
                            else oskContentRoot.shiftState = 0;
                        }

                        // Reset to 0 (Off)
                        onRequestResetShift: oskContentRoot.shiftState = 0
                    }
                }
            }
        }
    }

    Text {
        anchors.centerIn: parent
        text: "ERROR: Layout not found"
        color: "red"
        visible: oskContentRoot.currentLayout.keys === undefined || oskContentRoot.currentLayout.keys.length === 0
        z: 100
    }
}
