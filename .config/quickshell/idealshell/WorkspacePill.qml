pragma ComponentBehavior: Bound

import QtQuick
import Quickshell
import Quickshell.Hyprland
import "."

/**
 * Workspace pills — one file, no sub-component. Always shows 9 fixed
 * slots (workspaces 1-9), regardless of which ones currently exist or
 * have windows. Named/negative workspaces (e.g. id -97 scratchpads) are
 * never shown — only 1 through 9.
 *
 * Deliberately minimal. No numbers, no expanding capsule, no blur, no
 * backdrop fill. Just small rounded pills:
 *
 *   - empty workspace        -> invisible at idle
 *   - has windows, inactive  -> dim but visible at idle
 *   - active workspace       -> bright at idle
 *   - urgent workspace       -> blinking red, ALWAYS, completely
 *                                independent of hover
 *
 * Hover feedback, snappy and immediate:
 *   1. One step brighter on the ladder above. Already-bright (active)
 *      pills stay exactly as they are.
 *   2. A flat height bump on EVERY pill, including the active one — the
 *      one universal "the cursor is here" cue.
 *
 * Click a pill to switch to that workspace.
 *
 * Positioned flush at (0,0) of this component's own bounds, with no
 * extra nudge — wire this up in shell.qml with a plain anchors.top /
 * anchors.topMargin, the same way the clock pill is positioned, and they
 * will line up exactly with no per-module fudge factor.
 */
Item {
    id: wsPill

    // ==================== SCALE ====================
    property real s: 1

    // ==================== WORKSPACE COUNT ====================
    readonly property int workspaceCount: 9   // fixed — only 1-9 are ever shown

    // ==================== PILL GEOMETRY ====================
    property real lineWidth: 18 * s
    property real lineHeight: 2 * s            // idle height — exactly 2px (at s=1)
    property real lineSpacing: 3.5 * s
    property real sideInset: 1 * s            // left/right breathing room around the whole row
    // The hover size bump: clearly more than idle, not a near-invisible
    // +1px — this is the "a few more on hover" cue. At s=1 this lands at
    // 2 (idle) + 5 = 7px while hovered, an obvious-but-not-huge jump.
    property real hoverHeightBump: 3 * s

    // ==================== COLOR / BRIGHTNESS LADDER ====================
    property color lineColor: Theme.vermLit     // bright = active workspace
    property real activeOpacity: 1.0
    property real hasWindowsOpacity: 0.55       // dim-but-visible = has windows, not focused
    property real emptyOpacity: 0.0             // invisible = no windows (still reserves its slot)
    // One step brighter than each idle state above, used only on hover.
    property real hasWindowsHoverOpacity: 0.85
    property real emptyHoverOpacity: 0.35

    // ==================== URGENT (blinking red — untouched by hover) ====================
    property color urgentColor: "#e25a5a"
    property int urgentBlinkPeriod: 600

    // ==================== HOVER TIMING ====================
    // Snappy on purpose — immediate "yes, I see your cursor" feedback,
    // not a slow reveal.
    property int hoverInMs: 90
    property int hoverOutMs: 110

    // ==================== DATA ====================
    function wsForId(id) {
        const values = Hyprland.workspaces.values;
        for (let i = 0; i < values.length; i++) {
            if (values[i].id === id)
                return values[i];
        }
        return null;
    }

    // ---------------------------------------------------------------------
    // Layout. Flush at (0,0) — no nudge. width/height are this component's
    // real, full bounds; shell.qml positions THIS item with plain anchors,
    // same as the clock pill, and the two will align with zero fudging.
    // ---------------------------------------------------------------------
    readonly property real rowHeight: lineHeight + hoverHeightBump
    implicitWidth: row.implicitWidth + 2 * sideInset
    implicitHeight: rowHeight
    width: implicitWidth
    height: implicitHeight

    property string screenName: ""
    property var barWindow

    Row {
        id: row
        x: wsPill.sideInset
        y: 0
        spacing: wsPill.lineSpacing

        Repeater {
            model: wsPill.workspaceCount

            Item {
                id: cell
                required property int index
                readonly property int wsId: index + 1
                readonly property var ws: wsPill.wsForId(wsId)
                readonly property bool isActive: ws ? ws.active : false
                readonly property bool hasWindows: ws ? ws.toplevels.values.length > 0 : false
                readonly property bool isUrgent: ws ? ws.urgent : false
                property bool hovered: false

                // Fixed footprint — Row lays out by this, and it never
                // changes with hover, so neighbors never shift.
                width: wsPill.lineWidth
                height: wsPill.rowHeight

                Rectangle {
                    id: line
                    anchors.horizontalCenter: parent.horizontalCenter
                    // Anchored to the top, growing straight down on
                    // hover. Never crosses above y:0, never affects
                    // neighbors.
                    anchors.top: parent.top
                    width: wsPill.lineWidth
                    height: cell.hovered ? (wsPill.lineHeight + wsPill.hoverHeightBump) : wsPill.lineHeight
                    radius: 0   // square corners, no rounding at all
                    color: cell.isUrgent ? wsPill.urgentColor : wsPill.lineColor

                    // Urgent overrides everything and is completely
                    // unaffected by hover.
                    opacity: cell.isUrgent ? blink.opacity
                        : (cell.isActive
                            ? wsPill.activeOpacity   // already brightest; hover has nothing to add
                            : (cell.hasWindows
                                ? (cell.hovered ? wsPill.hasWindowsHoverOpacity : wsPill.hasWindowsOpacity)
                                : (cell.hovered ? wsPill.emptyHoverOpacity : wsPill.emptyOpacity)))

                    Behavior on opacity {
                        enabled: !cell.isUrgent
                        NumberAnimation { duration: cell.hovered ? wsPill.hoverInMs : wsPill.hoverOutMs }
                    }
                    Behavior on height {
                        NumberAnimation { duration: cell.hovered ? wsPill.hoverInMs : wsPill.hoverOutMs; easing.type: Easing.OutQuad }
                    }
                    Behavior on color { ColorAnimation { duration: 150 } }

                    // Blink driver — only runs while this workspace is
                    // urgent, completely separate from hover.
                    SequentialAnimation {
                        id: blink
                        property real opacity: 1.0
                        running: cell.isUrgent
                        loops: Animation.Infinite
                        onRunningChanged: if (!running) blink.opacity = 1.0
                        NumberAnimation { target: blink; property: "opacity"; from: 1.0; to: 0.25; duration: wsPill.urgentBlinkPeriod / 2; easing.type: Easing.InOutSine }
                        NumberAnimation { target: blink; property: "opacity"; from: 0.25; to: 1.0; duration: wsPill.urgentBlinkPeriod / 2; easing.type: Easing.InOutSine }
                    }
                }

                MouseArea {
                    // Hit-zone matches the cell's fixed footprint exactly.
                    anchors.fill: parent
                    hoverEnabled: true
                    cursorShape: Qt.PointingHandCursor
                    onEntered: cell.hovered = true
                    onExited: cell.hovered = false
                    onClicked: {
                        // cell.ws is the live HyprlandWorkspace object when
                        // that workspace currently exists. Its activate()
                        // is documented as exactly equivalent to
                        // Hyprland.dispatch("workspace " + name) under the
                        // hood — so if THAT already works for existing
                        // workspaces (it does, you confirmed it), the
                        // exact same dispatch call should also work for
                        // a workspace that doesn't exist yet, since
                        // Hyprland creating a workspace on demand from
                        // this exact dispatcher is the entire point of
                        // how "switch to workspace N" has always worked.
                        //
                        // Previous attempts here went looking for a
                        // Hyprland-0.55-Lua-syntax problem (hl.dsp.focus,
                        // execDetached + hyprctl, luaMode branching) that
                        // turned out to be solving the wrong thing: if
                        // dispatch("workspace "+id) already switches to
                        // an EXISTING workspace correctly through this
                        // same Quickshell binding, there's no reason the
                        // same call would be rejected only when the
                        // workspace doesn't exist yet — Quickshell's own
                        // dispatch() most likely already handles
                        // legacy-vs-Lua translation internally before
                        // anything reaches Hyprland's socket. Removed all
                        // of that speculative branching; one plain call,
                        // unconditionally, for every workspace.
                        if (cell.ws) {
                            cell.ws.activate();
                        } else {
                            Hyprland.dispatch("hl.dsp.focus({ workspace = " + cell.wsId + " })")
                        }
                    }
                }
            }
        }
    }
}
