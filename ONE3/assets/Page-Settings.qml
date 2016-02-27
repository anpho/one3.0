import bb.cascades 1.4
import cn.anpho 1.0
import bb.system 1.2
Page {
    titleBar: TitleBar {
        title: qsTr("Settings")
    }
    property variant nav
    attachedObjects: [
        WebImageView {
            id: wiv
        },
        SystemToast {
            id: sst
        }
    ]
    actionBarVisibility: ChromeVisibility.Compact
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
                leftPadding: 20.0
                rightPadding: 20.0
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
                leftPadding: 20.0
                rightPadding: 20.0
                bottomPadding: 20.0
                Label {
                    multiline: true
                    text: qsTr("Turn this on to save battery on OLED screen devices.")
                    textStyle.fontWeight: FontWeight.W100
                    textStyle.fontSize: FontSize.XSmall

                }
            }
            Header {
                title: qsTr("CONTENT CACHE(EXPERIMENTAL)")
                subtitle: qsTr("WARNING")
            }
            Container {
                leftPadding: 20.0
                topPadding: 20.0
                rightPadding: 20.0
                bottomPadding: 20.0
                Label {
                    text: qsTr("Enable this feature will increase the storage usage, while decreases network traffic.")
                    multiline: true
                    textStyle.fontWeight: FontWeight.W100
                }
                Container {
                    layout: StackLayout {
                        orientation: LayoutOrientation.LeftToRight

                    }
                    Label {
                        text: qsTr("Use Network Cache")
                        verticalAlignment: VerticalAlignment.Center
                        layoutProperties: StackLayoutProperties {
                            spaceQuota: 1.0
                        }
                    }
                    ToggleButton {
                        checked: _app.getv("ncache", "true") == "true"
                        onCheckedChanged: {
                            _app.setv("ncache", checked)
                        }
                    }
                }
            }
            Header {
                title: qsTr("RESET APPLICATION")
            }
            Container {
                topPadding: 20.0
                leftPadding: 20.0
                bottomPadding: 20.0
                rightPadding: 20.0
                Label {
                    text: qsTr("If anything wrong happens, please use this button to RESET all application settings. This will erease all cached content too.")
                    multiline: true
                    textStyle.fontWeight: FontWeight.W100

                }
            }
            Button {
                appearance: ControlAppearance.Primary
                text: qsTr("RESET")
                horizontalAlignment: HorizontalAlignment.Center
                onClicked: {
                    _app.reset();
                    wiv.clearCache();
                    sst.body = qsTr("Settings Reseted")
                    sst.show();
                }
            }
            Header {
                title: qsTr("IMAGE CACHE")
            }
            Container {
                leftPadding: 20.0
                topPadding: 20.0
                rightPadding: 20.0
                bottomPadding: 20.0
                Label {
                    text: qsTr("This app will store as top as 100MBytes image cache on device, which will improve the application performance. Make sure you know what you're doing before you press the button below.")
                    multiline: true
                    textStyle.fontWeight: FontWeight.W100
                }
            }

            Button {
                horizontalAlignment: HorizontalAlignment.Center
                appearance: ControlAppearance.Primary
                text: qsTr("CLEAR CACHE")
                onClicked: {
                    wiv.clearCache()
                    sst.body = qsTr("Cache Cleared")
                    sst.show();
                }

            }
            Label {
                text: qsTr("-- end --")
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
                topMargin: 100.0
            }
        }
    }
}
