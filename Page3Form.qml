import QtQuick 2.15
import QtQuick.Controls 2.5
import QtQuick.Controls.Styles 1.4
import QtQuick.Layouts 1.3

Page {

    Component.onCompleted: {

    }

    id: pageThree
    width: 240
    height: 1440
    background: Rectangle {
        color: "#000000"
    }
    header: Label {
        id: labelHeader
        y: 5
        x: 0
        text: qsTr("Settings")
        font.pointSize: 10
        padding: 0
        bottomPadding: 20
        color: "#00ff00"
    }

    Item {
        id: settingsFrame
        anchors.fill: parent

        Label {
            id: wifiScanTitle
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.leftMargin: 5
            text: qsTr("Wifi network")
            font.pointSize: 8
            color: "#00ff00"
        }
        Label {
            id: wifiNotesLabel
            anchors.top: wifiScanTitle.bottom
            anchors.left: parent.left
            anchors.leftMargin: 5
            text: qsTr("Scan and connect to wifi network")
            font.pointSize: 6
            color: "#00ff00"
        }

        // Erase All
        Button {
            id: wifiEraseAllButton
            anchors.right: parent.right
            anchors.rightMargin: 10
            anchors.top: parent.top
            anchors.topMargin: 5
            width: 70
            height: 20
            text: "Erase All"
            font.pointSize: 8
            checkable: false
            onClicked: {
                eClass.wifiEraseAllConnection()
                eClass.registerTouch()
            }
            contentItem: Text {
                text: parent.text
                font: parent.font
                opacity: enabled ? 1.0 : 0.3
                color: parent.down ? "#0F0" : "#0D0"
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                elide: Text.ElideRight
            }
            background: Rectangle {
                anchors.fill: parent
                color: parent.down ? "#882200" : "#000"
                opacity: enabled ? 1 : 0.3
                border.color: parent.down ? "#00FF00" : "#00FF00"
                radius: 2
            }
        }

    ComboBox {
        id: control
        model: eClass.wifiNetworks
        font.pointSize: 8
        anchors.top: wifiNotesLabel.bottom
        anchors.topMargin: 10
        anchors.left: parent.left
        anchors.leftMargin: 5
        height: 20
        width: 140
        leftPadding: 3
        onCurrentIndexChanged: wifiPassword.text = "";
        delegate: ItemDelegate {
            width: control.width
            contentItem: Text {
                text: modelData
                color: "#00ff00"
                font: control.font
                elide: Text.ElideRight
                verticalAlignment: Text.AlignVCenter
            }
        }
        // red arrow down indicator
        indicator: Canvas {
            id: canvas
            x: control.width - width - control.rightPadding
            y: control.topPadding + (control.availableHeight - height) / 2
            width: 12
            height: 8
            contextType: "2d"
            Connections {
                target: control
                function onPressedChanged() { canvas.requestPaint(); }
            }
            onPaint: {
                context.reset();
                context.moveTo(0, 0);
                context.lineTo(width, 0);
                context.lineTo(width / 2, height);
                context.closePath();
                context.fillStyle = control.pressed ? "#00FF00" : "#ff0000";
                context.fill();
            }
        }
        contentItem: Text {
            leftPadding: 1
            rightPadding: control.indicator.width + control.spacing
            text: control.displayText
            font: control.font
            color: "#00ff00"
            verticalAlignment: Text.AlignVCenter
            elide: Text.ElideRight

        }
        background: Rectangle {
            color: "transparent"
            implicitWidth: 120
            implicitHeight: 20
            border.color:  "#00ff00"
            border.width: control.visualFocus ? 2 : 1
            radius: 2
        }
        popup: Popup {
            y: control.height - 1
            width: control.width
            implicitHeight: 200
            padding: 1
            contentItem: ListView {
                clip: true
                implicitHeight: contentHeight
                model: control.popup.visible ? control.delegateModel : null
                currentIndex: control.highlightedIndex
                ScrollIndicator.vertical: ScrollIndicator { }
            }
            background: Rectangle {
                color: "#000000"
                border.color: "#00ff00"
                radius: 2
            }
        }
    }

    // Buttons
    Button {
        id: wifiScanButton
        anchors.right: parent.right
        anchors.rightMargin: 10
        anchors.top: wifiEraseAllButton.bottom
        anchors.topMargin: 10
        width: 70
        height: 20
        text: "Scan"
        font.pointSize: 8
        checkable: false
        onClicked: {
            eClass.wifiScanButton()
            eClass.registerTouch()
        }
        contentItem: Text {
            text: parent.text
            font: parent.font
            opacity: enabled ? 1.0 : 0.3
            color: parent.down ? "#0F0" : "#0D0"
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            elide: Text.ElideRight
        }
        background: Rectangle {
            anchors.fill: parent
            color: parent.down ? "#141" : "#000"
            opacity: enabled ? 1 : 0.3
            border.color: parent.down ? "#0F0" : "#0D0"
            radius: 2
        }
    }
    // Password text entry
    TextField {
        id: wifiPassword
        anchors.left: parent.left
        anchors.leftMargin: 5
        height: 20
        width: 140
        anchors.top: control.bottom
        anchors.topMargin: 10
        padding: 1
        font.pointSize: 8
        color: "#00ff00"
        placeholderTextColor: "#009900"
        placeholderText: "<wifi password>"
        onAccepted: {

        }
        /* Limit to 63 */
        onTextChanged: {
            eClass.registerTouch()
            if (length > 63)
                remove(63, length)
        }
        background: Rectangle {
            radius: 2
            color: "#000000"
            anchors.fill: parent
            height: 20
            border.color: "#00ff00"
            border.width: 1
        }
    }

    // Save button
    Button {
        id: wifiConnectButton
        anchors.right: parent.right
        anchors.rightMargin: 10
        anchors.top: wifiScanButton.bottom
        anchors.topMargin: 10
        width: 70
        height: 20
        text: "Connect"
        font.pointSize: 8
        checkable: false
        onClicked: {
            eClass.wifiConnectButton(control.currentValue,wifiPassword.text)
            wifiPassword.text = "*******";
            eClass.registerTouch()
        }
        contentItem: Text {
            text: parent.text
            font: parent.font
            opacity: enabled ? 1.0 : 0.3
            color: parent.down ? "#0F0" : "#0D0"
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            elide: Text.ElideRight
        }
        background: Rectangle {
            anchors.fill: parent
            color: parent.down ? "#141" : "#000"
            opacity: enabled ? 1 : 0.3
            border.color: parent.down ? "#0F0" : "#0D0"
            radius: 2
        }
    }

    Label {
        id: wifiStatusTitle
        anchors.left: parent.left
        anchors.leftMargin: 5
        height: 15
        width: 140
        anchors.top: wifiPassword.bottom
        anchors.topMargin: 10
        padding: 1
        font.pointSize: 6
        text: qsTr("Wifi status:")
        color: "#00ff00"
    }

    Text {
        id: wifiStatusText
        anchors.left: parent.left
        anchors.leftMargin: 10
        height: 20
        width: parent.width - 50
        anchors.rightMargin: 20
        anchors.top: wifiStatusTitle.bottom
        anchors.topMargin: -1
        padding: 1
        font.pointSize: 8
        wrapMode: Text.WordWrap
        text: eClass.wifiStatusText
        color: "#00ff00"
    }

    // Wifi status button
    Button {
        id: wifiStatusButton
        anchors.right: parent.right
        anchors.rightMargin: 10
        anchors.top: wifiStatusTitle.bottom
        anchors.topMargin: -7
        width: 20
        height: 20
        text: "?"
        font.pointSize: 8
        checkable: false
        onClicked: {
            eClass.getWifiStatus()
            eClass.registerTouch()
        }
        contentItem: Text {
            text: parent.text
            font: parent.font
            opacity: enabled ? 1.0 : 0.3
            color: parent.down ? "#0F0" : "#0D0"
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            elide: Text.ElideRight
        }
        background: Rectangle {
            anchors.fill: parent
            color: parent.down ? "#141" : "#000"
            opacity: enabled ? 1 : 0.3
            border.color: parent.down ? "#0F0" : "#0D0"
            radius: 10
        }
    }

    // Power save section
    Label {
        id: powerSaveTitle
        anchors.left: parent.left
        anchors.leftMargin: 5
        height: 20
        width: 140
        anchors.top: wifiStatusText.bottom
        anchors.topMargin: 15
        padding: 1
        font.pointSize: 8
        text: qsTr("Power save options")
        color: "#00ff00"
    }

    // Checkbox (this was hard for me to understand)
    CheckBox {
        id: deepSleepCheckbox
        anchors.top: powerSaveTitle.bottom
        anchors.topMargin: -2
        anchors.left: parent.left
        anchors.leftMargin: 10
        text: qsTr("deep sleep on screen lock")
        checked: eClass.deepSleepEnabled
        onCheckedChanged: {
            if (checked !== eClass.deepSleepEnabled ) {
                eClass.changeDeepSleepEnabled(deepSleepCheckbox.checkState)
            }
        }

        indicator: Rectangle {
            implicitWidth: 10
            implicitHeight: 10
            x: deepSleepCheckbox.leftPadding
            y: parent.height / 2 - height / 2
            radius: 2
            color: "transparent"
            border.color: "#00FF00"

            Rectangle {
                width: 6
                height: 6
                x: 2
                y: 2
                radius: 2
                color: "#00FF00"
                visible: deepSleepCheckbox.checked
            }
        }

        contentItem: Text {
            text: deepSleepCheckbox.text
            font.pointSize: 8
            opacity: enabled ? 1.0 : 0.3
            color: "#00FF00"
            verticalAlignment: Text.AlignVCenter
            leftPadding: deepSleepCheckbox.indicator.width + deepSleepCheckbox.spacing
        }
    }

    // About button
    Button {
        id: aboutButton
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: deepSleepCheckbox.bottom
        anchors.topMargin: 50
        width: 20
        height: 20
        text: "i"
        font.pointSize: 10
        checkable: false
        onClicked: {
            popup.open()
            eClass.registerTouch()
        }
        contentItem: Text {
            text: parent.text
            font: parent.font
            opacity: enabled ? 1.0 : 0.3
            color: parent.down ? "#0F0" : "#0D0"
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            elide: Text.ElideRight
        }
        background: Rectangle {
            anchors.fill: parent
            color: parent.down ? "#141" : "#000"
            opacity: enabled ? 1 : 0.3
            border.color: parent.down ? "#0F0" : "#0D0"
            radius: 10
        }
    }

    // Version label
    Label {
        id: versionLabel
        height: 20
        width: 50
        anchors.top: aboutButton.bottom
        anchors.topMargin: 5
        anchors.horizontalCenter: parent.horizontalCenter
        padding: 1
        font.pointSize: 6
        text: qsTr("v0.2a [DEV]")
        color: "#00ff00"
        horizontalAlignment: Text.AlignHCenter
    }

    Popup {
            id: popup
            anchors.centerIn: parent
            width: 220
            height: 350
            modal: true
            focus: true
            clip: true
            closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutsideParent
            background: Rectangle {
                color: "#000000"
                border.color: "#00FF00"
                radius: 2
            }

            Text {
                id: popupTitleText
                    font.pointSize: 12
                    text: "About"
                    color: "#00FF00"
            }
            ScrollView {
                id: view
                clip: true
                contentWidth: -1
                anchors.fill: parent
                anchors.top: popupTitleText.bottom
                anchors.topMargin: 25
                anchors.bottomMargin: 30
                Text {
                    textFormat: Text.RichText
                    width: 200
                    wrapMode: Text.WordWrap
                    color: "#00FF00"
                    text: eClass.aboutTextContent
                    font.pointSize: 7
                }
            }
            // Close button
            Button {
                id: popupCloseButton

                anchors{
                  bottom: parent.bottom
                  horizontalCenter: parent.horizontalCenter
                }
                width: 50
                height: 20
                text: "Close"
                font.pointSize: 8
                checkable: false
                onClicked: {
                    popup.close()
                    eClass.registerTouch()
                }
                contentItem: Text {
                    text: parent.text
                    font: parent.font
                    opacity: enabled ? 1.0 : 0.3
                    color: parent.down ? "#0F0" : "#0D0"
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    elide: Text.ElideRight
                }
                background: Rectangle {
                    anchors.fill: parent
                    color: parent.down ? "#141" : "#000"
                    opacity: enabled ? 1 : 0.3
                    border.color: parent.down ? "#0F0" : "#0D0"
                    radius: 2
                }
            }
            enter: Transition {
                    NumberAnimation { property: "opacity"; from: 0.0; to: 1.0 }
            }
        }
}

}
