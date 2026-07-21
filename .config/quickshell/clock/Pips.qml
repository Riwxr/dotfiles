import QtQuick

Item {
    id: root

    // ---- Scale ----
    property real s: 1

    // ---- Geometry ----
    property real pillWidth: 15 * s
    property real smallPillWidth: 7 * s
    property real pillHeight: 2 * s

    property real itemSpacing: 4 * s
    property real clusterSpacing: 26 * s

    // ---- Divider ----
    property bool showDivider: true
    property real dividerWidth: 1
    property real dividerHeight: 12 * s

    // ---- Colors ----
    property color activeColor: "#6f89ba"

    property real litOpacity: 0.9

    // ---- Time ----
    property int hourUnits: 0
    property int minuteUnits: 0

    function recompute() {
        const d = new Date()

        // Hours: 0-11
        hourUnits = d.getHours() % 12

        // Minutes: rounded to nearest 5-minute bucket
        minuteUnits = Math.round(d.getMinutes() / 5) % 12
    }

    function bars(units) {
        return Math.floor(units / 3)
    }

    function dots(units) {
        return units % 3
    }

    Component.onCompleted: recompute()

    Timer {
        interval: 1000
        running: true
        repeat: true
        onTriggered: root.recompute()
    }

    implicitWidth: rowWrap.implicitWidth
    implicitHeight: dividerHeight

    Row {
        id: rowWrap

        anchors.centerIn: parent
        spacing: root.clusterSpacing

        // =====================
        // HOURS (center -> left)
        // =====================
        Row {
            spacing: root.itemSpacing
            layoutDirection: Qt.RightToLeft

            Repeater {
                model: root.bars(root.hourUnits)

                Rectangle {
                    width: root.pillWidth
                    height: root.pillHeight
                    radius: height / 2

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
                    radius: height / 2

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
            opacity: 0.25

            anchors.verticalCenter: parent.verticalCenter
        }

        // =====================
        // MINUTES (center -> right)
        // =====================
        Row {
            spacing: root.itemSpacing

            Repeater {
                model: root.bars(root.minuteUnits)

                Rectangle {
                    width: root.pillWidth
                    height: root.pillHeight
                    radius: height / 2

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
                    radius: height / 2

                    color: root.activeColor
                    opacity: root.litOpacity

                    anchors.verticalCenter: parent.verticalCenter
                }
            }
        }
    }
}
