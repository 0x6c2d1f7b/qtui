/*
    Small Pine phone QML interface for Out-Of-Band communication.

    Copyright (C) 2023 Resilience Theatre

    This program is free software; you can redistribute it and/or
    modify it under the terms of the GNU General Public License
    as published by the Free Software Foundation; either version 2
    of the License, or (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program; If not, see <http://www.gnu.org/licenses/>.
*/

import QtQuick 2.15
import QtQuick.Window 2.15
import QtQuick.VirtualKeyboard 2.15
import QtQuick.Controls 2.5
import QtQuick.Controls.Material 2.15

ApplicationWindow {
    id: window
    x: 0
    y: 0
    visible: true
    visibility: ApplicationWindow.FullScreen

    background: Rectangle {
        color: "#000000"
    }

    property alias pageSwipeIndex: swipeView

    Item {
        id: pageItem
        width: 480
        height: 240
        x:-120
        y:-120

        transform: Rotation {
            origin.x: window.width / 2;
            origin.y: window.height / 2 ;
            angle: 90
        }
        // Hide this after aligment
        Rectangle {
            visible: false
            anchors.fill: parent
            color: "transparent"
            border.color: "green"
            border.width: 2
            radius: 0
        }
        Component.onCompleted: {
            pinCodeEntryVertical.forceActiveFocus()
        }

        Rectangle {
            color: "transparent"
            width: 30
            height: 12
            x: 0
            y: 0
            Text {
                id: titleLabelText
                text: "OOB Comm"
                anchors.fill: parent
                horizontalAlignment: Text.AlignHleft
                verticalAlignment: Text.AlignVCenter
                font.pointSize: 7
                color: eClass.mainColor
            }
        }
        Rectangle {
            id: callSignLabel
            color: "transparent"
            visible: true
            x: 70
            y: 0
            width: 30
            height: 12
            Text {
                id: callSignLabelText
                text: eClass.myCallSign
                anchors.fill: parent
                horizontalAlignment: Text.AlignHleft
                verticalAlignment: Text.AlignVCenter
                font.pointSize: 7
                color: eClass.mainColor
            }
        }
        // Network: LTE or WIFI
        Item {
            id: connectionLabel
            visible: true
            anchors.right: parent.right
            anchors.rightMargin: 10
            width: 30
            height: 12
            Rectangle {
                visible: eClass.macsecValid
                radius: 0
                width: connectionLabel.width
                height: connectionLabel.height
                color: "#000000"
                border.width: 1
                border.color: eClass.mainColor
            }
            Text {
                id: connectionLabelText
                text: eClass.wifiNotifyText
                anchors.fill: parent
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                font.pointSize: 7
                color: eClass.wifiNotifyColor
            }
        }
        /* HF Indicator */
        Item {
            id: spacer
            visible: true
            anchors.right: connectionLabel.left
            width: 10
            height: 12
            Rectangle {
                radius: 0
                width: spacer.width
                height: spacer.height
                color: "#000000"
                border.width: 0
                border.color: eClass.mainColor
            }
            Text {
                id: hfConnectedStatus
                text: "HF"
                visible: eClass.hfIndicatorVisible
                anchors.fill: parent
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                font.pointSize: 7
                color: eClass.mainColor
            }
        }

        /* Latency */
        Item {
            id: connectionTypeLabel
            visible: true
            anchors.right: spacer.left
            width: 50
            height: 12
            Rectangle {
                radius: 0
                width: connectionTypeLabel.width
                height: connectionTypeLabel.height
                color: "#000000"
                border.width: 0
                border.color: eClass.networkStatusLabelColor
            }
            Text {
                id: connectionLteLabelText
                text: eClass.networkStatusLabelValue
                anchors.fill: parent
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                font.pointSize: 7
                color: eClass.networkStatusLabelColor
            }
        }
        Item {
            id: spacerTwo
            visible: true
            anchors.right: connectionTypeLabel.left
            width: 5
            Rectangle {
                radius: 0
                width: spacerTwo.width
                height: spacerTwo.height
                color: "#000000"
                border.width: 0
                border.color: "#00FF00"
            }
        }

        Item {
            id: batteryLabel
            visible: true
            anchors.right: spacerTwo.left
            width: 40
            height: 12
            Rectangle {
                radius: 0
                width: batteryLabel.width
                height: batteryLabel.height
                color: "#000000"
                border.width: 0
                border.color: eClass.voltageNotifyColor
            }
            Text {
                id: batteryLabelText
                text: eClass.voltageValue
                anchors.fill: parent
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                font.pointSize: 7
                color: eClass.voltageNotifyColor
            }
        }

        SwipeView {
            id: swipeView
            topPadding: 15
            anchors.fill: parent
            currentIndex: eClass.swipeViewIndex

            Page1Form {
                id: pageOne
            }

            Page2Form {
                id: pageTwo
            }

            Page3Form {
                id: pageThree
            }
            onCurrentIndexChanged: {
                eClass.registerTouch()
                eClass.setSwipeIndex(swipeView.currentIndex)
            }
        }

        // Camo screen
        Frame {
            id: camoScreenFrame
            anchors.fill: parent
            // enabled: true
            visible: eClass.camoScreen_active
            anchors.topMargin: -15
            anchors.rightMargin: -15
            anchors.leftMargin: -15
            anchors.bottomMargin: -20
            background: Rectangle {
                color: "transparent"
                border.color: "#ffffff"
                border.width: 0
            }
            Image {
                id: camoScreenImage
                anchors.centerIn: parent
                anchors.fill: parent
                source: "mainscreen.png"
            }
        }

        // Lock screen
        Frame {
            id: lockScreenFrame
            anchors.fill: parent
            visible: eClass.lockScreen_active
            anchors.topMargin: -15
            anchors.rightMargin: -15
            anchors.leftMargin: -15
            anchors.bottomMargin: -20
            /* Test for PIN code entry focus */
            onVisibleChanged: {
                if(eClass.lockScreen_active) {
                    pinCodeEntryVertical.forceActiveFocus();
                }
            }
            background: Rectangle {
                color: "black"
                border.color: "red"
                border.width: 2
            }
            Image {
                id: lockScreenImage
                anchors.centerIn: parent
                anchors.fill: parent
                visible: false
                source: "lockscreen.png"
            }

            // Vault pin indication
            Rectangle {
                id: vaultIndicator
                anchors.horizontalCenter: parent.horizontalCenter
                y: 10
                width: 150
                height: 10
                color: eClass.vaultScreenNotifyColor
                radius: 4
                visible: eClass.vaultScreen_active
                Text {
                    text: eClass.vaultScreenNotifyText
                    color: eClass.vaultScreenNotifyTextColor
                    font.pointSize: 6
                    font.bold: true
                    anchors.centerIn: parent
                }
            }

            // Pin code for vertical UI
            TextField {
                id: pinCodeEntryVertical
                anchors.centerIn: parent
                height: 30
                width: 80
                padding: 1
                font.pointSize: 12
                color: eClass.mainColor
                placeholderTextColor: eClass.dimColor
                placeholderText: ""
                focus: true
                horizontalAlignment: TextInput.AlignHCenter
                echoMode: TextField.Password
                passwordCharacter: "•"
                onAccepted: {
                    eClass.checkVerticalPinCode(pinCodeEntryVertical.text);
                    pinCodeEntryVertical.text="";
                }
                /* Limit to 10 */
                onTextChanged: {
                    eClass.registerTouch()
                    if (length > 10)
                        remove(10, length)
                }
                background: Rectangle {
                    radius: 0
                    color: "#000000"
                    anchors.fill: parent
                    height: 30
                    border.color: eClass.mainColor
                    border.width: 1
                }
            }

            // PIN code (portrait)
            Rectangle {
                id: pinEntry
                x: 40
                y: 210
                width: 160
                height: 40
                color: "transparent"
                border.color: "red"
                border.width: 0
                radius: 10
                Text {
                    text: eClass.lockScreenPinCode
                    color: "white"
                    font.pointSize: 18
                    anchors.centerIn: parent
                }
            }

            Rectangle {
                id: lockButton_1
                x: 40
                y: 260
                width: 35
                height: 40
                color: "transparent"
                border.color: "red"
                border.width: 0
                radius: 10
                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        eClass.lockNumberEntry(1)
                        eClass.registerTouch()
                    }
                }
            }

            Rectangle {
                id: lockButton_2
                x: 105
                y: 260
                width: 35
                height: 40
                color: "transparent"
                border.color: "red"
                border.width: 0
                radius: 10
                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        eClass.lockNumberEntry(2)
                        eClass.registerTouch()
                    }
                }
            }
            Rectangle {
                id: lockButton_3
                x: 172
                y: 260
                width: 35
                height: 40
                color: "transparent"
                border.color: "red"
                border.width: 0
                radius: 10
                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        eClass.lockNumberEntry(3)
                        eClass.registerTouch()
                    }
                }
            }
            // row 2
            Rectangle {
                id: lockButton_4
                x: 40
                y: 310
                width: 35
                height: 40
                color: "transparent"
                border.color: "red"
                border.width: 0
                radius: 10
                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        eClass.lockNumberEntry(4)
                        eClass.registerTouch()
                    }
                }
            }

            Rectangle {
                id: lockButton_5
                x: 105
                y: 310
                width: 35
                height: 40
                color: "transparent"
                border.color: "red"
                border.width: 0
                radius: 10
                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        eClass.lockNumberEntry(5)
                        eClass.registerTouch()
                    }
                }
            }
            Rectangle {
                id: lockButton_6
                x: 172
                y: 310
                width: 35
                height: 40
                color: "transparent"
                border.color: "red"
                border.width: 0
                radius: 10
                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        eClass.lockNumberEntry(6)
                        eClass.registerTouch()
                    }
                }
            }
            // row 3
            Rectangle {
                id: lockButton_7
                x: 40
                y: 360
                width: 35
                height: 40
                color: "transparent"
                border.color: "red"
                border.width: 0
                radius: 10
                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        eClass.lockNumberEntry(7)
                        eClass.registerTouch()
                    }
                }
            }

            Rectangle {
                id: lockButton_8
                x: 105
                y: 360
                width: 35
                height: 40
                color: "transparent"
                border.color: "red"
                border.width: 0
                radius: 10
                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        eClass.lockNumberEntry(8)
                        eClass.registerTouch()
                    }
                }
            }
            Rectangle {
                id: lockButton_9
                x: 172
                y: 360
                width: 35
                height: 40
                color: "transparent"
                border.color: "red"
                border.width: 0
                radius: 10
                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        eClass.lockNumberEntry(9)
                        eClass.registerTouch()
                    }
                }
            }
            // row 4
            Rectangle {
                id: lockButton_back
                x: 40
                y: 410
                width: 35
                height: 40
                color: "transparent"
                border.color: "red"
                border.width: 0
                radius: 10
                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        eClass.lockNumberEntry(100)
                        eClass.registerTouch()
                    }
                }
            }

            Rectangle {
                id: lockButton_0
                x: 105
                y: 410
                width: 35
                height: 40
                color: "transparent"
                border.color: "red"
                border.width: 0
                radius: 10
                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        eClass.lockNumberEntry(0)
                        eClass.registerTouch()
                    }
                }
            }
            Rectangle {
                id: lockButton_99
                x: 172
                y: 410
                width: 35
                height: 40
                color: "transparent"
                border.color: "red"
                border.width: 0
                radius: 10
                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        eClass.lockNumberEntry(99)
                        eClass.registerTouch()
                    }
                }
            }
        }

        // Touch block frame on top of everything
        Frame {
            anchors.fill: parent
            enabled: eClass.touchBlock_active
            background: Rectangle {
                color: "transparent"
                border.color: "#ffffff"
                border.width: 0
                radius: 2
            }
        }

        // Nuke counter
        Rectangle {
            id: nukeCounter
            anchors.fill: parent
            color: "transparent"
            radius: 0
            visible: eClass.nukeCounterVisible
            Text {
                text: eClass.nukeCounterText
                color: "red"
                font.pointSize: 130
                font.bold: true
                anchors.centerIn: parent
            }
        }

        // Input panel, disabled on hw kb version

//        InputPanel {
//            id: inputPanel
//            z: 99
//            x: 0
//            y: window.height
//            width: window.width
//            Component.onCompleted: {
//            }
//            states: State {
//                name: "visible"
//                when: (swipeView.currentIndex == "1" || inputPanel.active )
//                PropertyChanges {
//                    target: inputPanel
//                    y: window.height - inputPanel.height
//                }
//            }
//            transitions: Transition {
//                from: ""
//                to: "visible"
//                reversible: true
//                ParallelAnimation {
//                    NumberAnimation {
//                        properties: "y"
//                        duration: 250
//                        easing.type: Easing.InOutQuad
//                    }
//                }
//            }
//        }

    }

}
