import QtQuick

Rectangle {
    id: root
    color: "#161616"
    property int stage: 0

    onStageChanged: {
        if (stage === 1) {
            introAnimation.running = true;
        }
    }

    // Background is directly bound to the main window
    Image {
        id: backgroundImage
        source: "images/background.png"
        anchors.fill: parent
        fillMode: Image.PreserveAspectCrop
    }

    // Main Logo Group - Fully compatible with Wayland asynchronous startup geometry
    Image {
        id: topRect
        source: "images/rectangle.svg"
        anchors.horizontalCenter: parent.horizontalCenter

        // WAYLAND SAFETY: Dynamic binding to prevent crashes if the root size is not available yet
        y: root.height > 0 ? root.height / 3 : 300

        // Exact dimensions to prevent coordinate shifts if the SVG file loads slowly from disk
        width: implicitWidth > 0 ? implicitWidth : 460
        height: implicitHeight > 0 ? implicitHeight : 290
        opacity: 0 // Initially invisible, will fade in smoothly with the animator

        Image {
            source: "images/kde.svg"
            anchors.centerIn: parent
            width: implicitWidth > 0 ? implicitWidth : 600
            height: implicitHeight > 0 ? implicitHeight : 199
        }

        // Progress Bar Background
        Rectangle {
            id: progressBarBackground
            radius: 3
            color: "#55555574"
            height: 6
            width: 216 // Fixed width instead of dynamic calculation prevents deadlocks in Wayland
            anchors {
                bottom: parent.bottom
                bottomMargin: 50
                horizontalCenter: parent.horizontalCenter
            }

            // Active Blue Bar
            Rectangle {
                radius: 3
                anchors {
                    left: parent.left
                    top: parent.top
                    bottom: parent.bottom
                }

                // WAYLAND COLD-BOOT SAFETY: Width is calculated only when the scene is loaded and stage is greater than 1
                width: (stage > 1 && progressBarBackground.width > 0) ? (progressBarBackground.width / 6) * (stage - 1) : 0
                color: "#1d99f3"

                Behavior on width {
                    PropertyAnimation {
                        duration: 250
                        easing.type: Easing.InOutQuad
                    }
                }
            }
        }
    }

    // Modern fluid animation directly targeting the main logo
    OpacityAnimator {
        id: introAnimation
        running: false
        target: topRect
        from: 0
        to: 1
        duration: 1000
        easing.type: Easing.InOutQuad
    }
}
