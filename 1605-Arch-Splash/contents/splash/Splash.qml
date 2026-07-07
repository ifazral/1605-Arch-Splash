import QtQuick

Rectangle {
    id: root
    color: "#161616" // Görseller yüklenirken arkada kalacak yedek renk
    property int stage

    onStageChanged: {
        if (stage == 1) {
            introAnimation.running = true;
        }
    }

    // Tüm açılış görsellerini pürüzsüz animasyon için tek bir Item içine alıyoruz
    Item {
        id: content
        anchors.fill: parent
        opacity: 0

        // Arch arka plan görseli
        Image {
            id: backgroundImage
            source: "images/background.png"
            anchors.fill: parent
            fillMode: Image.PreserveAspectCrop
        }

        // Merkezdeki Arch Logo taşıyıcısı
        Image {
            id: topRect
            anchors.horizontalCenter: parent.horizontalCenter
            y: parent.height / 3
            source: "images/rectangle.svg"

            // İç kısımdaki Arch/KDE Logosu
            Image {
                source: "images/kde.svg"
                anchors.centerIn: parent
            }

            // İlerleme Çubuğu Arka Planı
            Rectangle {
                radius: 3
                color: "#55555574"
                height: 6
                width: height * 36
                anchors {
                    bottom: parent.bottom
                    bottomMargin: 50
                    horizontalCenter: parent.horizontalCenter
                }

                // Aktif İlerleme Çubuğu (Mavi Renk)
                Rectangle {
                    radius: 3
                    anchors {
                        left: parent.left
                        top: parent.top
                        bottom: parent.bottom
                    }
                    width: (parent.width / 6) * (stage - 1)
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
    }

    // Kuro temasındaki modern yumuşak açılış efekti
    OpacityAnimator {
        id: introAnimation
        running: false
        target: content
        from: 0
        to: 1
        duration: 1000
        easing.type: Easing.InOutQuad
    }
}
