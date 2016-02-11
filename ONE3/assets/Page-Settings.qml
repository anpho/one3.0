import bb.cascades 1.4

Page {
    titleBar: TitleBar {
        title: qsTr("Settings")
    }
    property variant nav
    ScrollView {
        id: scrview
        Container {
            Header {
                title: qsTr("VISUAL SETTINGS")
            }
            Container {
                layout: StackLayout {
                    orientation: LayoutOrientation.LeftToRight

                }
                topPadding: 20.0
                leftPadding: 40.0
                rightPadding: 40.0
                bottomPadding: 20.0
                Label {
                    text: qsTr("Use Dark Theme")
                    verticalAlignment: VerticalAlignment.Center
                    layoutProperties: StackLayoutProperties {
                        spaceQuota: 1.0
                    }
                }
                ToggleButton {
                    checked: Application.themeSupport.theme.colorTheme.style === VisualStyle.Dark
                    onCheckedChanged: {
                        checked ? _app.setv("use_dark_theme", "dark") : _app.setv("use_dark_theme", "bright")
                        try {
                            Application.themeSupport.setVisualStyle(checked ? VisualStyle.Dark : VisualStyle.Bright);
                        } catch (e) {
                        }
                    }
                }
            }
            Container {
                leftPadding: 40.0
                rightPadding: 40.0
                bottomPadding: 20.0
                Label {
                    multiline: true
                    text: qsTr("Turn this on to save battery on OLED screen devices.")
                    textStyle.fontWeight: FontWeight.W100
                    textStyle.fontSize: FontSize.XSmall

                }
            }
           
            Label {
                text: qsTr("-- one --")
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
        }
    }
}
