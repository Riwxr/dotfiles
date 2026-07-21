pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Effects
import Quickshell
import "."

/**
 * Bare-bones pill: two modes only.
 *   "rest"  — idle pip clusters (Pips.qml), flush at the top of the screen.
 *   "hover" — pointer is over the pill, morphs into a small clock readout.
 *
 * ALL VISUAL KNOBS ARE GROUPED RIGHT BELOW. Colors pull from Theme.qml by
 * default (so this stays in sync with the rest of your setup) — override
 * any of them here with a plain color value if you want this pill to
 * differ from your theme.
 */
Item {
    id: pill

    // ==================== SIZE ====================
    property real s: 1                          // per-monitor scale factor, set from shell.qml
    readonly property real restW: 130 * s       // minimum idle pill width (grows to fit pips if they're wider)
    readonly property real restH: 10 * s        // idle pill height
    readonly property real hoverW: hoverRow.implicitWidth + 6 * hoverPad  // hover popup width (auto-fits the clock text)
    readonly property real hoverH: 58 * s       // hover popup height
    readonly property real hoverPad: 20 * s     // horizontal padding around the clock text in hover popup

    // ==================== SHAPE ====================
    readonly property real restCorner: 18 * s   // corner roundness at idle (capsule is invisible at rest anyway, but this sets the morph starting point)
    readonly property real openCorner: 7 * s   // corner roundness when hovering

    // ==================== POSITION ====================
    readonly property real restTopNudge: -14 * s // negative = pull pips up; positive = push down

    // ==================== TIMING ====================
    readonly property int hoverGraceMs: 300     // how long the pointer can leave before it actually collapses
    // Was a flat Motion.morph (likely ~120-150ms) — slowed down to match
    // the cooler, less snappy timing now used on the workspace pills.
    readonly property int morphMs: Math.round(Motion.morph * 1.8)

    // ==================== COLORS (pulled from Theme.qml; override directly to break from theme) ====================
    property color pipColor: Theme.vermLit          // the dash/pip color
    property color cardBorderColor: Theme.border    // hover popup border
    property color cardTopColor: Theme.cardTop      // hover popup background gradient, top
    property color cardBotColor: Theme.cardBot      // hover popup background gradient, bottom
    property real cardOpacity: Math.min(Flags.pillOpacity, 0.88)    // hover popup background opacity — capped a touch lower than Flags.pillOpacity for more glassy transparency
    property real cardBlurRadius: 36 * s            // backdrop blur strength on the hover popup itself
    property color shadowColor: Qt.rgba(0, 0, 0, Theme.shadowOpacity)  // hover popup drop shadow
    property color clockTimeColor: Theme.cream      // "3:45" text color
    property color clockDateColor: Theme.dim        // "WED 24 JUN" text color
    property string clockFont: Theme.font

    // ==================== TEXT SIZE (hover popup) ====================
    property real clockTimeSize: 18 * s
    property real clockDateSize: 10.5 * s
    property real clockLineSpacing: 2 * s
    property real clockDateLetterSpacing: 1.6 * s

    // ==================== PIPS CONFIG (forwarded to Pips.qml — see that file for its own knobs) ====================
    // To change pip width/height/spacing/roundness/dot vs bar sizing, edit
    // Pips.qml directly — every one of those is a labeled property there.

    // ---------------------------------------------------------------------
    // Internals below. You shouldn't need to touch anything past this line
    // to restyle the pill — it's all wired to the properties above.
    // ---------------------------------------------------------------------

    property string screenName: ""
    property var barWindow

    property bool hovered: false
    property bool hoverLatch: false
    readonly property bool expanded: hoverLatch

    // Was set externally by a wider HoverHandler in shell.qml (a zone
    // ~160px wider than the pill itself, to make the thin idle pip row
    // easier to grab). That zone is gone now that the panel's input mask
    // is restricted to exactly the pills' own visible bounds — anything
    // outside this pill's actual rectangle no longer receives input on
    // this surface at all, so hover has to be detected from right here,
    // matching the mask exactly.
    HoverHandler {
        onHoveredChanged: pill.hovered = hovered
    }

    readonly property string mode: expanded ? "hover" : "rest"

    readonly property size targetSize: mode === "hover"
        ? Qt.size(hoverW, hoverH)
        : Qt.size(Math.max(restW, restPips.implicitWidth + 36 * s), restH)
    readonly property real targetW: targetSize.width
    readonly property real targetH: targetSize.height

    width: targetW
    height: targetH

    readonly property real morphCloseness: {
        const d = Math.max(Math.abs(width - targetW), Math.abs(height - targetH));
        return 1 - Math.min(1, d / (110 * s));
    }

    property real morphRadius: mode === "rest" ? restCorner : openCorner

    Behavior on width { NumberAnimation { duration: pill.morphMs; easing.type: Motion.easeMorph; easing.bezierCurve: Motion.morphCurve } }
    Behavior on height { NumberAnimation { duration: pill.morphMs; easing.type: Motion.easeMorph; easing.bezierCurve: Motion.morphCurve } }
    Behavior on morphRadius { NumberAnimation { duration: pill.morphMs; easing.type: Motion.easeMorph; easing.bezierCurve: Motion.morphCurve } }

    /**
     * Clock data source. Self-contained, only depends on Flags for the
     * 12h/seconds format toggles.
     */
    QtObject {
        id: clock
        readonly property var loc: Qt.locale("en_US")
        readonly property var now: sysClock.date
        readonly property string timeFormat: (Flags.time12h ? "h:mm" : "HH:mm")
            + (Flags.clockSeconds ? ":ss" : "")
            + (Flags.time12h ? " AP" : "")
        readonly property string hhmm: Qt.formatTime(now, timeFormat)
        readonly property string date: loc.toString(now, "d MMM, ddd")
    }

    SystemClock {
        id: sysClock
        precision: Flags.clockSeconds ? SystemClock.Seconds : SystemClock.Minutes
    }

    /**
     * Hover handling. hovered is set by the HoverHandler declared above.
     * graceTimer stops the pill snapping shut on a brief flicker off the
     * pointer, and won't fire mid-morph-animation.
     */
    onHoveredChanged: {
        if (hovered) {
            hoverLatch = true;
            graceTimer.stop();
        } else {
            graceTimer.restart();
        }
    }

    Timer {
        id: graceTimer
        interval: pill.hoverGraceMs
        onTriggered: {
            if (pill.morphCloseness < 0.95) {
                graceTimer.restart();
                return;
            }
            pill.hoverLatch = false;
        }
    }

    Rectangle {
        id: body
        anchors.fill: parent
        radius: pill.morphRadius
        border.width: pill.mode === "rest" ? 0 : 1
        border.color: pill.cardBorderColor
        opacity: pill.mode === "rest" ? 0 : 1
        visible: opacity > 0.01
        Behavior on opacity { NumberAnimation { duration: Motion.fast } }
        gradient: Gradient {
            GradientStop { position: 0.0; color: Qt.alpha(pill.cardTopColor, pill.cardOpacity) }
            GradientStop { position: 1.0; color: Qt.alpha(pill.cardBotColor, pill.cardOpacity) }
        }

        layer.enabled: true
        layer.effect: MultiEffect {
            shadowEnabled: true
            shadowColor: pill.shadowColor
            shadowBlur: 0.7
            shadowVerticalOffset: 3 * pill.s
            // Softens the gradient fill itself into a frosted-glass look
            // rather than a flat tinted card — paired with cardOpacity's
            // transparency for the glassy effect requested. This blurs
            // body's OWN content (its gradient), not whatever's behind
            // the window — true "see-through" backdrop blur would need
            // capturing desktop content into a texture first, which is a
            // much heavier, compositor-dependent technique not used here.
            blurEnabled: true
            blur: 0.35
            blurMax: pill.cardBlurRadius
        }
    }

    Item {
        id: rest
        anchors.fill: parent
        anchors.topMargin: pill.restTopNudge
        opacity: pill.expanded ? 0 : Math.pow(pill.morphCloseness, 1.5)
        visible: opacity > 0.01
        Behavior on opacity { NumberAnimation { duration: pill.mode === "rest" ? Motion.fast : 260 } }

        Pips {
            id: restPips
            x: (rest.width - width) / 2
            y: (rest.height - height) / 2
            s: pill.s
            activeColor: pill.pipColor
        }
    }

    Item {
        id: hover
        anchors.fill: parent
        opacity: pill.mode === "hover" ? Math.pow(pill.morphCloseness, 1.2) : 0
        visible: opacity > 0.01
        Behavior on opacity { NumberAnimation { duration: pill.mode === "hover" ? Motion.fast : 40 } }

        Column {
            id: hoverRow
            anchors.centerIn: parent
            spacing: pill.clockLineSpacing
            Text {
                anchors.horizontalCenter: parent.horizontalCenter
                text: clock.hhmm
                color: pill.clockTimeColor
                font.family: pill.clockFont
                font.pixelSize: pill.clockTimeSize
                font.weight: Font.DemiBold
                font.features: { "tnum": 1 }
            }
            Text {
                anchors.horizontalCenter: parent.horizontalCenter
                text: clock.date
                color: pill.clockDateColor
                font.family: pill.clockFont
                font.pixelSize: pill.clockDateSize
                font.weight: Font.Medium
                font.capitalization: Font.AllUppercase
                font.letterSpacing: pill.clockDateLetterSpacing
            }
        }
    }
}
