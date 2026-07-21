pragma ComponentBehavior: Bound

import QtQuick
import Quickshell
import Quickshell.Io
import Quickshell.Services.UPower
import "."

/**
 * Battery pill — completely static otherwise: no percentage text, no
 * numbers, nothing. Just a small dot/pill, same minimal language as the
 * workspace pills, sitting top-right.
 *
 * Color ladder (idle), muted/desaturated tones throughout, not vivid:
 *   - charging          -> blue (same accent as the rest of the bar),
 *                           with a slow traveling shimmer to read as
 *                           "energizing" rather than a flat fill
 *   - 100% -> 60%        -> green
 *   -  60% -> 40%        -> pale yellow-green
 *   -  40% -> 30%        -> yellow
 *   -  30% -> 10%        -> orange
 *   -  10% -> 0%         -> red, PULSING (the one state that animates
 *                           even at idle, as an urgency cue)
 * Charging always wins over the percentage-based color, same as how
 * urgent always wins for the workspace pills.
 *
 * Hover: same language as the workspace pills — a flat +2px height bump,
 * nothing else. No tooltip (deliberately left out for now).
 *
 * Click endpoints: left / right / middle / back (button 4) / forward
 * (button 5), each configurable to a SCRIPT PATH (not an inline shell
 * command — see the commandFor* properties below). Left empty to do
 * nothing. Defaults to a `notify-send` call per button so you can see
 * each endpoint is wired up before pointing them at real scripts.
 */
Item {
    id: batteryPill

    // ==================== SCALE ====================
    property real s: 1

    // ==================== GEOMETRY ====================
    // "10-20px wide, ~2px thick" per spec — 16px lands in the middle of
    // that range.
    property real pillWidth: 10 * s
    property real pillHeight: 2 * s
    property real hoverHeightBump: 2 * s   // same +2px hover language as the workspace pills

    // ==================== COLOR LADDER (muted/desaturated, not vivid) ====================
    property color chargingColor: Theme.vermLit      // same blue accent the rest of the bar uses
    property color highColor: "#7fae8c"               // 100-60%: muted green
    property color midColor: "#a8b07a"                // 60-40%: pale yellow-green
    property color lowColor: "#c9a35a"                 // 40-30%: muted yellow
    property color criticalColor: "#c97f4f"            // 30-10%: muted orange
    property color emptyColor: "#c0584f"               // below 10%: muted red, pulsing

    // Thresholds — adjust the boundaries here if you want the bands to
    // land somewhere else.
    property int highThreshold: 60        // at/above this -> highColor
    property int midThreshold: 40         // at/above this -> midColor
    property int lowThreshold: 30         // at/above this -> lowColor
    property int criticalThreshold: 10    // at/above this -> criticalColor; below -> emptyColor (pulsing)

    // ==================== CHARGING SHIMMER ====================
    // A slow, soft traveling highlight along the pill while charging —
    // reads as "actively energizing" rather than a flat static blue.
    property int shimmerPeriodMs: 1600

    // ==================== CRITICAL PULSE ====================
    property int pulsePeriodMs: 900   // full bright<->dim cycle while below criticalThreshold

    // ==================== HOVER TIMING ====================
    property int hoverInMs: 90
    property int hoverOutMs: 110

    // ==================== CLICK COMMANDS ====================
    // Each of these is a PATH TO A SCRIPT, executed directly (no shell
    // involved) — e.g. "/home/you/.config/quickshell/scripts/battery-left.sh".
    // Leave any of them as "" to do nothing for that button. The script
    // just needs to be executable (chmod +x).
    //
    // Defaults below run notify-send so you can see each endpoint firing
    // before wiring up real scripts — swap the property value, not the
    // Process blocks further down, to point a button at your own script.
    property string commandLeftClick: ""
    property string commandRightClick: ""
    property string commandMiddleClick: "/home/riwxr/scripts/tts-edge.sh"
    property string commandBackClick: ""      // mouse button 4 / "back"
    property string commandForwardClick: ""   // mouse button 5 / "forward"

    // Demo fallback: if a command path above is empty, this still fires
    // a notify-send naming the button, purely so you can confirm the
    // click is reaching this component at all. Set demoNotifyWhenEmpty
    // to false once you've wired up real scripts and don't want the
    // fallback notifications anymore.
    property bool demoNotifyWhenEmpty: true

    function runForButton(buttonName, scriptPath) {
        if (scriptPath && scriptPath.length > 0) {
            Quickshell.execDetached([scriptPath]);
        } else if (batteryPill.demoNotifyWhenEmpty) {
            Quickshell.execDetached(["notify-send", buttonName]);
        }
    }

    // ==================== DATA ====================
    readonly property var device: UPower.displayDevice
    readonly property bool deviceReady: device && device.ready && device.isLaptopBattery
    readonly property real percent: deviceReady ? device.percentage * 100 : 100
    // UPowerDeviceState's exact member names mirror the UPower D-Bus
    // state strings (Charging, Discharging, FullyCharged, etc). If your
    // Quickshell version names this enum member differently, this is the
    // one line to fix.
    readonly property bool isCharging: deviceReady && device.state === UPowerDeviceState.Charging
    readonly property bool isCritical: !isCharging && percent < criticalThreshold

    readonly property color idleColor: isCharging ? chargingColor
        : (percent >= highThreshold ? highColor
        : (percent >= midThreshold ? midColor
        : (percent >= lowThreshold ? lowColor
        : (percent >= criticalThreshold ? criticalColor
        : emptyColor))))

    property bool hovered: false

    // ---------------------------------------------------------------------
    // Layout. Flush at (0,0) of this component's own bounds — wire this
    // up in shell.qml with plain anchors (top-right corner), the same
    // pattern as the clock and workspace pills.
    // ---------------------------------------------------------------------
    implicitWidth: pillWidth
    implicitHeight: pillHeight + hoverHeightBump
    width: implicitWidth
    height: implicitHeight

    property string screenName: ""
    property var barWindow

    Rectangle {
        id: dot
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: parent.top
        width: batteryPill.pillWidth
        height: batteryPill.hovered ? (batteryPill.pillHeight + batteryPill.hoverHeightBump) : batteryPill.pillHeight
        radius: height / 2
        color: batteryPill.idleColor
        opacity: batteryPill.isCritical ? pulse.opacity : 1.0

        Behavior on height {
            NumberAnimation { duration: batteryPill.hovered ? batteryPill.hoverInMs : batteryPill.hoverOutMs; easing.type: Easing.OutQuad }
        }
        Behavior on color { ColorAnimation { duration: 250 } }

        // Critical pulse — only runs below criticalThreshold and only
        // while NOT charging (isCritical already excludes charging).
        // Mirrors the workspace pills' urgent-blink pattern: a separate,
        // always-on animation that owns opacity outright rather than
        // fighting the Behavior above.
        SequentialAnimation {
            id: pulse
            property real opacity: 1.0
            running: batteryPill.isCritical
            loops: Animation.Infinite
            onRunningChanged: if (!running) pulse.opacity = 1.0
            NumberAnimation { target: pulse; property: "opacity"; from: 1.0; to: 0.3; duration: batteryPill.pulsePeriodMs / 2; easing.type: Easing.InOutSine }
            NumberAnimation { target: pulse; property: "opacity"; from: 0.3; to: 1.0; duration: batteryPill.pulsePeriodMs / 2; easing.type: Easing.InOutSine }
        }

        // Charging shimmer — a soft highlight band that sweeps left to
        // right along the pill on a loop, clipped to the pill's own
        // rounded shape. Only visible while charging; harmless/idle
        // otherwise (opacity 0).
        Item {
            id: shimmerClip
            anchors.fill: parent
            clip: true
            visible: batteryPill.isCharging

            Rectangle {
                id: shimmerBand
                width: parent.width * 0.5
                height: parent.height
                // Soft, low-contrast highlight — kept subtle/desaturated
                // per "muted tone, not too overdone."
                color: Qt.lighter(batteryPill.chargingColor, 1.6)
                opacity: 0.55
                x: -width

                SequentialAnimation {
                    running: batteryPill.isCharging
                    loops: Animation.Infinite
                    NumberAnimation {
                        target: shimmerBand
                        property: "x"
                        from: -shimmerBand.width
                        to: shimmerClip.width
                        duration: batteryPill.shimmerPeriodMs
                        easing.type: Easing.InOutSine
                    }
                }
            }
        }

        MouseArea {
            anchors.fill: parent
            hoverEnabled: true
            acceptedButtons: Qt.LeftButton | Qt.RightButton | Qt.MiddleButton | Qt.BackButton | Qt.ForwardButton
            cursorShape: Qt.PointingHandCursor
            onEntered: batteryPill.hovered = true
            onExited: batteryPill.hovered = false
            onClicked: (mouse) => {
                if (mouse.button === Qt.LeftButton) {
                    batteryPill.runForButton("left click", batteryPill.commandLeftClick);
                } else if (mouse.button === Qt.RightButton) {
                    batteryPill.runForButton("right click", batteryPill.commandRightClick);
                } else if (mouse.button === Qt.MiddleButton) {
                    batteryPill.runForButton("middle click", batteryPill.commandMiddleClick);
                } else if (mouse.button === Qt.BackButton) {
                    batteryPill.runForButton("back click", batteryPill.commandBackClick);
                } else if (mouse.button === Qt.ForwardButton) {
                    batteryPill.runForButton("forward click", batteryPill.commandForwardClick);
                }
            }
        }
    }
}
