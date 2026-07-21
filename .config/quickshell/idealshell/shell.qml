//@ pragma UseQApplication

import QtQuick
import Quickshell
import Quickshell.Wayland

/**
 * Bare-bones shell: one overlay PanelWindow per screen, hosting both the
 * clock pill and the workspace pills. No reserve/exclusion-zone window —
 * neither pill has a visible capsule at rest, so there's nothing to leave
 * room for. No IPC handlers, no surface routing.
 *
 * Input mask: the surface's clickable/hoverable area is restricted to
 * exactly the pills' own live, visible bounds (see `mask` below) — not
 * the full reserved rectangle. Each pill detects its own hover
 * internally (Pill.qml has its own HoverHandler; WorkspacePill.qml has
 * its own MouseArea per workspace cell), so there's nothing left to wire
 * up from here.
 */
ShellRoot {
    id: root

    Variants {
        model: Quickshell.screens

        PanelWindow {
            id: overlay
            required property var modelData
            readonly property real s: modelData ? modelData.height / 1080 : 1

            screen: modelData
            color: "transparent"
            WlrLayershell.layer: WlrLayer.Overlay
            exclusionMode: ExclusionMode.Ignore
            aboveWindows: true

            anchors { top: true; left: true; right: true }

            // Two INDEPENDENT vertical offsets — one per module — each
            // used in exactly two places: that module's own pill anchor,
            // and that module's own mask proxy's y. Previously there was
            // a single shared pillTopMargin, which meant nudging just the
            // workspace pills required overriding it inline on wsPill's
            // anchor only (e.g. "pillTopMargin - 8") — which moved the
            // visible pill without moving wsMaskProxy, immediately
            // breaking hover again, the same desync bug as before, just
            // rebuilt one level up. Splitting into two separate
            // properties means adjusting the workspace pills' position
            // doesn't touch anything related to the clock at all, and
            // there is exactly one number to change for each module, not
            // two.
            readonly property real clockTopMargin: 8 * s
            readonly property real wsTopMargin: 0 * s   // tweak THIS to move the workspace row — it drives both the visible pill below AND wsMaskProxy above, always in sync
            // Confirmed target position: 1*s - 1 (effectively flush, with
            // a 1px nudge baked into the expression itself). Both of
            // these only ever feed batteryMaskProxy below — batteryPill
            // has no anchors.topMargin/rightMargin of its own anymore;
            // its x/y are bound directly to batteryMaskProxy.x/y. So
            // changing these two values here is the ONLY edit needed to
            // move the battery pill; nothing else can drift out of sync
            // with it.
            readonly property real batteryTopMargin: 1 * s - 1
            readonly property real wsLeftMargin: 0 * s -2  // flush left — wsPill's anchor and wsMaskProxy both read this, so they move together
            readonly property real batteryRightMargin: 1 * s - 1

            //implicitHeight: 60 * s
            // Was pill.height + a hardcoded top margin — the surface only
            // ever sized itself to the CLOCK pill. wsPill's hover capsule
            // (with the falling numbers) had nowhere to expand into on
            // the actual Wayland surface, so it got clipped at the window
            // edge regardless of anything inside WorkspacePill.qml
            // itself. That's also why flicking from the workspace pill
            // to the clock pill produced a flash of the workspace pill's
            // closing animation: the window only grew once the clock
            // pill demanded it, and for one frame the previously-clipped,
            // still-collapsing workspace pill suddenly had room to render
            // in full.
            //
            // Compares actual bottom edges (topMargin + height) for both
            // pills using their OWN respective margin — each module can
            // move independently without affecting how much room the
            // other reserves.
            implicitHeight: Math.max(overlay.clockTopMargin + pill.height, overlay.wsTopMargin + wsPill.height, overlay.batteryTopMargin + batteryPill.height)

            // Mask-tracking proxy for the clock pill: positioned from
            // overlay's own fixed anchor math (overlay.width/2,
            // overlay.clockTopMargin — the SAME property pill's own
            // anchor below uses), sized to pill.targetW/targetH (which
            // snap instantly, no Behavior) rather than reading pill's
            // own, sometimes-animating width/height directly — Region's
            // docs note "in some cases the region does not update
            // automatically," and a target that only moves in clean,
            // discrete steps is far more reliable to mask against.
            Item {
                id: clockMaskProxy
                width: pill.targetW
                height: pill.targetH
                x: overlay.width / 2 - width / 2
                y: overlay.clockTopMargin
            }

            // Mask-tracking proxy for the workspace pills: same
            // overlay.wsTopMargin/wsLeftMargin as wsPill's own anchors
            // below. If you ever need to move wsPill again, change
            // wsTopMargin/wsLeftMargin ONCE above — both this proxy and
            // wsPill's anchor read them, so they can't drift apart. Keep
            // wsTopMargin at 0 or higher, though — this surface is a
            // Wayland layer-shell surface, which has no
            // negative-coordinate space at all, so a negative value
            // would push the pill (and its mask) partly or fully outside
            // anything the compositor can actually draw or accept input
            // on, not just "very close to the edge." 0 is already flush.
            Item {
                id: wsMaskProxy
                width: wsPill.width
                height: wsPill.height
                x: overlay.wsLeftMargin
                y: overlay.wsTopMargin
            }

            // Mask-tracking proxy for the battery pill: anchored from the
            // RIGHT edge (overlay.width - batteryRightMargin - width),
            // same idea as the other two proxies but mirrored
            // horizontally since this pill lives in the top-right corner
            // instead of top-left/top-center.
            Item {
                id: batteryMaskProxy
                width: batteryPill.width
                height: batteryPill.height
                x: overlay.width - overlay.batteryRightMargin - width
                y: overlay.batteryTopMargin
            }

            // Input mask: without this, the surface accepted clicks/hover
            // across its ENTIRE reserved rectangle even though almost none
            // of that was actually visible.
            mask: Region {
                Region { item: clockMaskProxy }
                Region { item: wsMaskProxy }
                Region { item: batteryMaskProxy }
            }

            Pill {
                id: pill
                anchors.top: parent.top
                anchors.topMargin: overlay.clockTopMargin
                anchors.horizontalCenter: parent.horizontalCenter
                s: overlay.s
                screenName: overlay.modelData.name
                barWindow: overlay
            }

            WorkspacePill {
                id: wsPill
                // anchors.topMargin/leftMargin read overlay.wsTopMargin/
                // wsLeftMargin — the SAME two properties wsMaskProxy
                // above reads. Change those, not these lines, if you
                // want to move this row.
                anchors.top: parent.top
                anchors.topMargin: overlay.wsTopMargin
                anchors.left: parent.left
                anchors.leftMargin: overlay.wsLeftMargin
                s: overlay.s
                screenName: overlay.modelData.name
                barWindow: overlay
            }

            BatteryPill {
                id: batteryPill
                // NO anchors.topMargin/rightMargin here on purpose, and
                // no overlay.batteryTopMargin/batteryRightMargin read
                // directly either. This is what caused the actual bug:
                // editing this anchor's margin inline (e.g.
                // "overlay.batteryTopMargin - 7") moves the VISIBLE pill
                // while batteryMaskProxy above keeps reading the
                // unmodified property — a few pixels of drift that's
                // easy to miss by eye but enough to put the mask
                // somewhere the cursor isn't.
                //
                // Instead, this pill's position is derived FROM the
                // proxy below, not the other way around — there is no
                // longer a second copy of the position to accidentally
                // edit. To move this pill, change batteryMaskProxy's x/y
                // (or the margin properties it reads) and this follows
                // automatically; there is no other line that moves it.
                x: batteryMaskProxy.x
                y: batteryMaskProxy.y
                s: overlay.s
                screenName: overlay.modelData.name
                barWindow: overlay
            }
        }
    }

}
