import bb.cascades 1.4
Sheet {
    id: sheet
    Page {
        titleBar: TitleBar {
            title: qsTr("Welcome")
            dismissAction: ActionItem {
                title: qsTr("Close")
                onTriggered: {
                    _app.setv("showwelcome", "false")
                    sheet.close()
                }
            }
        }
        Container {
            horizontalAlignment: HorizontalAlignment.Fill
            Header {
                title: qsTr("Disclaimer")
            }
            Container {
                topPadding: 20.0
                leftPadding: 20.0
                bottomPadding: 20.0
                rightPadding: 20.0
                horizontalAlignment: HorizontalAlignment.Fill
                Label {
                    multiline: true
                    text: qsTr("This is an early development version of ONE, in this version you may find some features are limited or disabled, trust me, I'm working on it.")

                }
                ImageView {
                    imageSource: "asset:///res/nav_title.png"
                    horizontalAlignment: HorizontalAlignment.Center
                    topMargin: 50.0
                    bottomMargin: 50.0
                    scalingMethod: ScalingMethod.AspectFit
                    layoutProperties: StackLayoutProperties {
                        spaceQuota: 1.0
                    }
                }
                Label {
                    text: qsTr("-- rebuilt for You --")
                    textStyle.textAlign: TextAlign.Center
                    horizontalAlignment: HorizontalAlignment.Fill
                    textStyle.rules: [
                        FontFaceRule {
                            source: "asset:///font/BradleyHandITCTTBold.ttf"
                            fontFamily: "bradley"
                        }
                    ]
                    textStyle.fontFamily: "bradley"
                    textStyle.fontWeight: FontWeight.Normal
                    textStyle.fontStyle: FontStyle.Default
                }
                Button {
                    horizontalAlignment: HorizontalAlignment.Center
                    text: qsTr("Close")
                    appearance: ControlAppearance.Primary
                    onClicked: {
                        _app.setv("showwelcome", "false")
                        sheet.close()
                    }
                }
            }
        }
    }
}