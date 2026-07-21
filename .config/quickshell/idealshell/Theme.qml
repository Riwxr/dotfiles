pragma Singleton
import QtQuick
import Quickshell

/**

* Pill palette. Two sources: the curated washi/flame hex below is the identity
* and the default, used whenever the dynamic-palette flag is off. With the flag
* on, the surfaces and the whole accent ramp follow the wallpaper through the
* matugen-fed `Dyn` singleton, while the text family, light veils and shadow
* stay locked here so copy keeps its contrast on any generated background. Each
* token is a single ternary, so static mode renders byte-identical to the fixed
* theme and only the colours that should breathe with the wallpaper do.
  */
  Singleton {
  readonly property bool dyn: Flags.paletteMode !== "static"

  /**

  * Cool blue-white accent based around #6f89ba.
    */
    readonly property color onGlow: dyn ? Dyn.primary : "#9eb8ee"

  readonly property color verm:     dyn ? Qt.darker(Dyn.primary, 1.18) : "#5d77a8"
  readonly property color vermLit:  dyn ? Dyn.primary : "#7f9bd0"
  readonly property color vermDeep: dyn ? Dyn.primaryContainer : "#4f6691"

  readonly property color cream:    dyn ? Dyn.cream : "#edf3ff"
  readonly property color bright:   dyn ? Dyn.bright : "#ffffff"
  readonly property color dim:      dyn ? Dyn.dim : "#8c97ab"

  readonly property color cardTop:  dyn ? Dyn.surfaceContainerHigh : "#2c3749"
  readonly property color cardBot:  dyn ? Dyn.surfaceContainerLow : "#222c3c"
  readonly property color border:   dyn ? Dyn.outlineVariant : "#36455e"

  readonly property color shadow: Qt.rgba(0, 0, 0, 0.55)

  readonly property color tileBg: dyn ? Dyn.surface : "#1d2736"

  readonly property color subtle:  dyn ? Dyn.subtle : "#b8c4da"
  readonly property color faint:   dyn ? Dyn.faint : "#74829a"
  readonly property color iconDim: dyn ? Dyn.iconDim : "#cfd8e8"

  readonly property color hair:     Qt.alpha(cream, 0.13)
  readonly property color hairSoft: Qt.alpha(cream, 0.08)
  readonly property color sheen:    Qt.alpha(cream, 0.07)

  readonly property color vermDim:     dyn ? Qt.darker(Dyn.primary, 1.5) : "#627492"
  readonly property color vermDimDeep: dyn ? Qt.darker(Dyn.primary, 2.2) : "#42516b"
  readonly property color vermBurn:    dyn ? Qt.darker(Dyn.primaryContainer, 1.1) : "#52698f"

  readonly property color tickRest: dyn ? Dyn.tickRest : "#d4ddee"

  readonly property color threadBg: Qt.alpha(cream, 0.13)

  readonly property color flameCore: dyn ? Qt.lighter(onGlow, 1.03) : "#eef4ff"
  readonly property color flameGlow: dyn ? onGlow : "#9eb8ee"

  /**

  * Flame canvas ramp: literal hex strings (color type won't work), fed
  * directly to Canvas addColorStop/strokeStyle. A color property serializes
  * to #aarrggbb and corrupts the gradient render, so the dynamic branch passes
  * matugen's raw hex strings through untouched rather than any Qt.darker math.
    */
    readonly property string flameInk:   dyn ? Dyn.primary : "#7f9bd0"
    readonly property string flameEmber: dyn ? Dyn.primaryContainer : "#4f6691"
    readonly property string flameBurn:  dyn ? Dyn.primaryContainer : "#425a84"
    readonly property string flameTip:   dyn ? Dyn.onPrimaryContainer : "#d8e6ff"

  readonly property color todayWarm: dyn ? onGlow : "#d8e6ff"

  readonly property color ghost: dyn ? Dyn.surfaceContainerHighest : "#4a5d79"

  readonly property color frameBg:     Qt.alpha(cream, 0.055)
  readonly property color frameBorder: Qt.alpha(cream, 0.10)
  readonly property color creamMenu:   Qt.alpha(cream, 0.82)

  readonly property real shadowOpacity: 0.5

  readonly property var fontFamilies: Qt.fontFamilies()
  readonly property string font: (Flags.uiFont.length > 0 && fontFamilies.indexOf(Flags.uiFont) >= 0) ? Flags.uiFont : "Inter"
  readonly property string fontJp: "Zen Kaku Gothic New"

  /**

  * MPRIS trackArtists arrives as a JS array from some players and as a
  * plain string from others (Spotify); calling join on the string throws
  * and kills the whole binding. Handles both, falls back to trackArtist.
    */
    function joinArtists(artists, single) {
    if (artists && typeof artists.join === "function" && artists.length > 0)
    return artists.join(", ");
    if (artists && String(artists).length > 0)
    return String(artists);
    return single ? String(single) : "";
    }
    }

