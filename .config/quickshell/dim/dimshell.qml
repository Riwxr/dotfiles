import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Wayland

ShellRoot {
	Variants {
		// Create the panel once on each monitor.
		model: Quickshell.screens

		PanelWindow {
			id: w
			
			property real opacity: 0.00
			
			property var modelData
			screen: modelData

			anchors {
				
				right: true
				top: true
			}

			margins {
				right:0
				bottom: 0
				top: -25
			}

			implicitWidth: screen.width
			implicitHeight: screen.height
			

			function setOpacity(val) {
				opacity = val
			}
			
			color: Qt.rgba(0, 0, 0, opacity)

			// Give the window an empty click mask so all clicks pass through it.
			mask: Region {}

			// Use the wlroots specific layer property to ensure it displays over
			// fullscreen windows.
			WlrLayershell.layer: WlrLayer.Overlay


		}
	}
}
