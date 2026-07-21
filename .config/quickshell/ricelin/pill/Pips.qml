import QtQuick

/**
 * Pips.qml — pip/pill clock indicator.
 *
 * Two fixed-length clusters of small pips: hours (0-11 elapsed in the
 * 12-hour cycle) and minutes (0-11 elapsed 5-minute units). Each cluster
 * is always 11 slots wide — "lit" pips show elapsed time, "dim" pips are
 * the remaining slots — so the widget's width never shifts as time passes.
 *
 * Self-contained, no external Theme/singleton dependency. Wire activeColor/
 * dimColor to your own theme when embedding (see integration notes).
 */
Item {
    id: root

    // ---- Scale (multiply by your bar's existing scale factor, e.g. pill.s) ----
    property real s: 1

    // ---- Pip geometry ----
    property real pipHeight: 2 * s
    property real pipWidth: 1.6 * s
    property real heavyWidthMult: 1.6      // every 3rd pip is this much wider
    property real pipSpacing: 1.2 * s

    // ---- Cluster layout ----
    property real clusterSpacing: 6 * s   // gap between hours and minutes clusters
    property bool showDivider: true
    property real dividerWidth: 1
    property real dividerHeight: 8 * s

    // ---- Colors / emphasis ----
    // Placeholder colors — swap for your theme's accent/dim colors when embedding.
    property color activeColor: "#e8533a"
    property color dimColor: "#555555"
    property real litOpacity: 0.7           // lit, non-heavy pip
    property real litHeavyOpacity: 1.0      // lit, every-3rd pip
    property real dimOpacity: 0.25          // unlit, non-heavy pip
    property real dimHeavyOpacity: 0.45     // unlit, every-3rd pip (still grouped, just quiet)

    // ---- Track length: fixed at 11 slots per cluster (see header comment) ----
    readonly property int trackLength: 11

    // ---- Live data (0-11 each) ----
    property int hourUnits: 0
    property int minuteUnits: 0

    /**
     * hourUnits: elapsed hours since the top of the 12-hour cycle (12 -> 0).
     * minuteUnits: current minute rounded to nearest 5, as an elapsed-unit
     * count, clamped to 11 so :58/:59 holds the cluster full instead of
     * wrapping back to empty right before the hour ticks over.
     */
    function recompute() {
        const d = new Date();
        hourUnits = d.getHours() % 12;
        minuteUnits = Math.min(11, Math.round(d.getMinutes() / 5));
    }

    Component.onCompleted: recompute()
    Timer {
        interval: 2000
        running: true
        repeat: true
        onTriggered: root.recompute()
    }

    implicitWidth: rowWrap.implicitWidth
    implicitHeight: Math.max(pipHeight, dividerHeight)

    Row {
        id: rowWrap
        anchors.centerIn: parent
        spacing: root.clusterSpacing

        Row {
            anchors.verticalCenter: parent.verticalCenter
            spacing: root.pipSpacing
            Repeater {
                model: root.trackLength
                delegate: Rectangle {
                    required property int index
                    readonly property bool heavy: (index + 1) % 3 === 0
                    readonly property bool lit: index < root.hourUnits
                    anchors.verticalCenter: parent.verticalCenter
                    width: heavy ? root.pipWidth * root.heavyWidthMult : root.pipWidth
                    height: root.pipHeight
                    radius: height / 2
                    color: lit ? root.activeColor : root.dimColor
                    opacity: lit ? (heavy ? root.litHeavyOpacity : root.litOpacity)
                                 : (heavy ? root.dimHeavyOpacity : root.dimOpacity)
                }
            }
        }

        Rectangle {
            visible: root.showDivider
            anchors.verticalCenter: parent.verticalCenter
            width: root.dividerWidth
            height: root.dividerHeight
            color: root.dimColor
            opacity: 0.4
        }

        Row {
            anchors.verticalCenter: parent.verticalCenter
            spacing: root.pipSpacing
            Repeater {
                model: root.trackLength
                delegate: Rectangle {
                    required property int index
                    readonly property bool heavy: (index + 1) % 3 === 0
                    readonly property bool lit: index < root.minuteUnits
                    anchors.verticalCenter: parent.verticalCenter
                    width: heavy ? root.pipWidth * root.heavyWidthMult : root.pipWidth
                    height: root.pipHeight
                    radius: height / 2
                    color: lit ? root.activeColor : root.dimColor
                    opacity: lit ? (heavy ? root.litHeavyOpacity : root.litOpacity)
                                 : (heavy ? root.dimHeavyOpacity : root.dimOpacity)
                }
            }
        }
    }
}
