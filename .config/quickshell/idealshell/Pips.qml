import QtQuick

/**
 * Pips — bars+dots time readout. Hours cluster on the left, minutes on the
 * right, each growing outward from the center divider. Every 3 elapsed
 * units collapses into one wide "bar"; the remainder (0-2) shows as small
 * "dots". Variable-length by design — width changes slightly through the
 * hour, by at most one pip's worth.
 *
 * Every visual property below is safe to tweak directly.
 */
Item {
    id: root

    // ==================== SCALE ====================
    // Multiplies most sizes below. Set from Pill.qml's own `s` (per-monitor
    // DPI scale) — leave at 1 if using this standalone.
    property real s: 1

    // ==================== PIP GEOMETRY ====================
    property real pillWidth: 15 * s        // width of a "bar" (3-unit group)
    property real smallPillWidth: 7 * s    // width of a "dot" (remainder pip)
    property real pillHeight: 2 * s        // height of every pip — the "thickness"
    property real pipRadius: pillHeight / 2 // corner roundness; 0 = square, height/2 = fully round (pill-shaped)

    // ==================== SPACING / LAYOUT ====================
    property real itemSpacing: 4 * s       // gap between pips within a cluster
    property real clusterSpacing: 26 * s   // gap between hours cluster and minutes cluster

    // ==================== DIVIDER (the line between hours | minutes) ====================
    property bool showDivider: true
    property real dividerWidth: 1
    property real dividerHeight: 12 * s
    property real dividerOpacity: 0.25

    // ==================== COLOR ====================
    property color activeColor: "#6f89ba"  // color of every pip and the divider
    property real litOpacity: 0.9          // opacity of pips (divider has its own dividerOpacity above)

    // ==================== TIME DATA ====================
    property int hourUnits: 0    // 0-11, elapsed hours in the 12-hour cycle
    property int minuteUnits: 0 // 0-11, elapsed 5-minute units (rounded, wraps at the hour)

    function recompute() {
        const d = new Date();
        hourUnits = d.getHours() % 12;
        minuteUnits = Math.round(d.getMinutes() / 5) % 12;
    }

    function bars(units) { return Math.floor(units / 3); }
    function dots(units) { return units % 3; }

    Component.onCompleted: recompute()
    Timer {
        interval: 1000
        running: true
        repeat: true
        onTriggered: root.recompute()
    }

    implicitWidth: rowWrap.implicitWidth
    implicitHeight: dividerHeight
    width: implicitWidth
    height: implicitHeight

    Row {
        id: rowWrap
        anchors.centerIn: parent
        spacing: root.clusterSpacing

        // Hours: grows from the divider outward to the left.
        Row {
            spacing: root.itemSpacing
            layoutDirection: Qt.RightToLeft

            Repeater {
                model: root.bars(root.hourUnits)
                Rectangle {
                    width: root.pillWidth
                    height: root.pillHeight
                    radius: root.pipRadius
                    color: root.activeColor
                    opacity: root.litOpacity
                    anchors.verticalCenter: parent.verticalCenter
                }
            }
            Repeater {
                model: root.dots(root.hourUnits)
                Rectangle {
                    width: root.smallPillWidth
                    height: root.pillHeight
                    radius: root.pipRadius
                    color: root.activeColor
                    opacity: root.litOpacity
                    anchors.verticalCenter: parent.verticalCenter
                }
            }
        }

        Rectangle {
            visible: root.showDivider
            width: root.dividerWidth
            height: root.dividerHeight
            color: root.activeColor
            opacity: root.dividerOpacity
            anchors.verticalCenter: parent.verticalCenter
        }

        // Minutes: grows from the divider outward to the right.
        Row {
            spacing: root.itemSpacing

            Repeater {
                model: root.bars(root.minuteUnits)
                Rectangle {
                    width: root.pillWidth
                    height: root.pillHeight
                    radius: root.pipRadius
                    color: root.activeColor
                    opacity: root.litOpacity
                    anchors.verticalCenter: parent.verticalCenter
                }
            }
            Repeater {
                model: root.dots(root.minuteUnits)
                Rectangle {
                    width: root.smallPillWidth
                    height: root.pillHeight
                    radius: root.pipRadius
                    color: root.activeColor
                    opacity: root.litOpacity
                    anchors.verticalCenter: parent.verticalCenter
                }
            }
        }
    }
}
