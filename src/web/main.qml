import QtQuick
import QtQuick.Controls
import QtQuick.Effects

Window {
    id: root
    width: 1280
    height: 800
    visible: true
    title: "Foothold Safety Assistant"
    color: "#0a0618"

    Item {
        id: sceneRoot
        anchors.fill: parent
        clip: true
        HoverHandler { id: globalHover }

        property real nx: globalHover.hovered
            ? (globalHover.point.position.x / Math.max(1, width)  - 0.5) : 0
        property real ny: globalHover.hovered
            ? (globalHover.point.position.y / Math.max(1, height) - 0.5) : 0
        Behavior on nx { NumberAnimation { duration: 260; easing.type: Easing.OutCubic } }
        Behavior on ny { NumberAnimation { duration: 260; easing.type: Easing.OutCubic } }

        Image {
            anchors.fill: parent
            anchors.margins: -30
            source: "assets/sunset.jpg"
            fillMode: Image.PreserveAspectCrop
            asynchronous: true
            smooth: true
            transform: Translate { x: sceneRoot.nx * -22; y: sceneRoot.ny * -16 }
        }

        Rectangle {
            anchors.fill: parent
            gradient: Gradient {
                GradientStop { position: 0.0; color: "#141026cc" }
                GradientStop { position: 0.5; color: "#00000000" }
                GradientStop { position: 1.0; color: "#14102699" }
            }
            transform: Translate { x: sceneRoot.nx * -10; y: sceneRoot.ny * -7 }
        }

        // Dust
        Item {
            id: dustLayer
            anchors.fill: parent
            transform: Translate { x: sceneRoot.nx * -34; y: sceneRoot.ny * -24 }
            Repeater {
                model: [
                    {px:0.08,py:0.55,sz:3,dur:12000,del:0},{px:0.14,py:0.72,sz:2,dur:15000,del:1200},
                    {px:0.22,py:0.48,sz:4,dur:13000,del:2600},{px:0.30,py:0.66,sz:2,dur:17000,del:900},
                    {px:0.38,py:0.58,sz:3,dur:14000,del:3400},{px:0.44,py:0.80,sz:2,dur:18000,del:2000},
                    {px:0.52,py:0.52,sz:4,dur:12500,del:4300},{px:0.60,py:0.70,sz:3,dur:16000,del:700},
                    {px:0.66,py:0.44,sz:2,dur:19000,del:3100},{px:0.72,py:0.62,sz:3,dur:13500,del:5100},
                    {px:0.78,py:0.78,sz:2,dur:15500,del:1500},{px:0.84,py:0.50,sz:4,dur:14500,del:2800},
                    {px:0.90,py:0.68,sz:3,dur:16500,del:3900},{px:0.05,py:0.40,sz:2,dur:20000,del:4600},
                    {px:0.20,py:0.34,sz:3,dur:17500,del:600},{px:0.35,py:0.28,sz:2,dur:18500,del:3200},
                    {px:0.50,py:0.36,sz:3,dur:16500,del:4400},{px:0.64,py:0.30,sz:2,dur:19500,del:1700},
                    {px:0.78,py:0.38,sz:4,dur:15000,del:2900},{px:0.92,py:0.32,sz:2,dur:18000,del:4000},
                    {px:0.11,py:0.86,sz:2,dur:17000,del:2400},{px:0.42,py:0.88,sz:3,dur:15500,del:5000},
                    {px:0.68,py:0.86,sz:2,dur:16500,del:3700},{px:0.88,py:0.88,sz:3,dur:14500,del:1300},
                    {px:0.26,py:0.22,sz:2,dur:19500,del:2200}
                ]
                delegate: Item {
                    x: parent.width * modelData.px
                    width: modelData.sz * 6
                    height: width
                    Rectangle {
                        anchors.centerIn: parent
                        width: modelData.sz; height: modelData.sz; radius: width/2
                        color: "#ffe4b9"; opacity: 0
                        SequentialAnimation on opacity {
                            loops: Animation.Infinite; running: true
                            PauseAnimation { duration: modelData.del }
                            NumberAnimation { to: 0.75; duration: 1500; easing.type: Easing.OutSine }
                            NumberAnimation { to: 0.45; duration: modelData.dur - 3000 }
                            NumberAnimation { to: 0.00; duration: 1500; easing.type: Easing.InSine }
                        }
                    }
                    SequentialAnimation on y {
                        loops: Animation.Infinite; running: true
                        PauseAnimation { duration: modelData.del }
                        NumberAnimation {
                            from: parent.height * modelData.py + 40
                            to: parent.height * modelData.py - 80
                            duration: modelData.dur; easing.type: Easing.InOutSine
                        }
                    }
                }
            }
        }

        Rectangle {
            anchors.fill: parent
            gradient: Gradient {
                orientation: Gradient.Horizontal
                GradientStop { position: 0.0;  color: "#000000aa" }
                GradientStop { position: 0.35; color: "#00000000" }
                GradientStop { position: 0.65; color: "#00000000" }
                GradientStop { position: 1.0;  color: "#000000aa" }
            }
            transform: Translate { x: sceneRoot.nx * -40; y: sceneRoot.ny * -28 }
        }
    }

    Text { anchors.horizontalCenter: parent.horizontalCenter; anchors.top: parent.top; anchors.topMargin: 60
        text: "Foothold Safety Assistant"; color: "white"; font.pixelSize: 46; font.bold: true; font.letterSpacing: 1
        style: Text.Outline; styleColor: "#00000099"; z: 20 }
    Text { anchors.horizontalCenter: parent.horizontalCenter; anchors.top: parent.top; anchors.topMargin: 126
        text: "Step smart. Step safe."; color: "#ffffffdd"; font.pixelSize: 16; font.italic: true; font.letterSpacing: 6
        style: Text.Outline; styleColor: "#00000066"; z: 20 }

    Row {
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: parent.bottom; anchors.bottomMargin: 176; spacing: 40; z: 20

        Item { id: liveWrap; width: 240; height: 76
            ShaderEffectSource { id: liveBlurSrc; sourceItem: sceneRoot; live: true; visible: false
                sourceRect: { var tl = liveWrap.mapToItem(sceneRoot, 0, 0); return Qt.rect(tl.x, tl.y, liveWrap.width, liveWrap.height) } }
            MultiEffect { source: liveBlurSrc; anchors.fill: parent; blurEnabled: true; blur: 1.0; blurMax: 48; opacity: 0.9 }
            Rectangle { anchors.fill: parent; radius: 22
                color: liveHover.hovered ? Qt.rgba(1,1,1,0.18) : Qt.rgba(1,1,1,0.10)
                Behavior on color { ColorAnimation { duration: 150 } } }
            Rectangle { anchors.fill: parent; radius: 22
                gradient: Gradient {
                    GradientStop { position: 0.0; color: Qt.rgba(1,1,1,0.28) }
                    GradientStop { position: 0.5; color: Qt.rgba(1,1,1,0.00) }
                    GradientStop { position: 1.0; color: Qt.rgba(0,0,0,0.10) } } }
            Rectangle { anchors.fill: parent; radius: 22; color: "transparent"
                border.color: liveHover.hovered ? Qt.rgba(1,1,1,0.65) : Qt.rgba(1,1,1,0.38); border.width: 1.5
                Behavior on border.color { ColorAnimation { duration: 150 } } }
            Text { anchors.centerIn: parent; text: "LIVE"; color: "white"; font.pixelSize: 22; font.bold: true
                font.letterSpacing: 7; style: Text.Outline; styleColor: "#00000044" }
            HoverHandler { id: liveHover; cursorShape: Qt.PointingHandCursor }
            TapHandler { onTapped: { liveWrap.scale = 0.96; livePress.start(); launcher.startLive() } }
            NumberAnimation { id: livePress; target: liveWrap; property: "scale"; to: 1.0; duration: 140; easing.type: Easing.OutBack }
        }

        Item { id: upWrap; width: 240; height: 76
            ShaderEffectSource { id: upBlurSrc; sourceItem: sceneRoot; live: true; visible: false
                sourceRect: { var tl = upWrap.mapToItem(sceneRoot, 0, 0); return Qt.rect(tl.x, tl.y, upWrap.width, upWrap.height) } }
            MultiEffect { source: upBlurSrc; anchors.fill: parent; blurEnabled: true; blur: 1.0; blurMax: 48; opacity: 0.9 }
            Rectangle { anchors.fill: parent; radius: 22
                color: upHover.hovered ? Qt.rgba(1,1,1,0.18) : Qt.rgba(1,1,1,0.10)
                Behavior on color { ColorAnimation { duration: 150 } } }
            Rectangle { anchors.fill: parent; radius: 22
                gradient: Gradient {
                    GradientStop { position: 0.0; color: Qt.rgba(1,1,1,0.28) }
                    GradientStop { position: 0.5; color: Qt.rgba(1,1,1,0.00) }
                    GradientStop { position: 1.0; color: Qt.rgba(0,0,0,0.10) } } }
            Rectangle { anchors.fill: parent; radius: 22; color: "transparent"
                border.color: upHover.hovered ? Qt.rgba(1,1,1,0.65) : Qt.rgba(1,1,1,0.38); border.width: 1.5
                Behavior on border.color { ColorAnimation { duration: 150 } } }
            Text { anchors.centerIn: parent; text: "UPLOAD"; color: "white"; font.pixelSize: 22; font.bold: true
                font.letterSpacing: 7; style: Text.Outline; styleColor: "#00000044" }
            HoverHandler { id: upHover; cursorShape: Qt.PointingHandCursor }
            TapHandler { onTapped: { upWrap.scale = 0.96; upPress.start(); launcher.startUpload() } }
            NumberAnimation { id: upPress; target: upWrap; property: "scale"; to: 1.0; duration: 140; easing.type: Easing.OutBack }
        }
    }

    Text { anchors.horizontalCenter: parent.horizontalCenter; anchors.bottom: parent.bottom; anchors.bottomMargin: 26
        text: "⚠ Not safety certified. Decision support only."; color: "#ffffffcc"; font.pixelSize: 12
        style: Text.Outline; styleColor: "#00000088"; z: 20 }
}
