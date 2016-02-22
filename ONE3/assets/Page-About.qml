import bb.cascades 1.4
import bb.system 1.2
import bb 1.3
Page {
    //版权页，直接显示官网内容
    actionBarAutoHideBehavior: ActionBarAutoHideBehavior.HideOnScroll
    function setActive() {
        about_scrollview.scrollRole = ScrollRole.Main
    }
    property variant nav

    actions: [
        ActionItem {
            title: qsTr("Copyrights")
            imageSource: "asset:///icon/ic_open.png"
            ActionBar.placement: ActionBarPlacement.InOverflow
            onTriggered: {
                var newpage = Qt.createComponent("WebBrowser.qml").createObject(nav);
                newpage.uri = "http://m.wufazhuce.com/about?from=ONEApp"
                nav.push(newpage)
            }
        }
    ]
    attachedObjects: [
        FontFaceRule {
            id: fontbradley
            source: "asset:///font/BradleyHandITCTTBold.ttf"
            fontFamily: "bradley"
        },
        ApplicationInfo {
            id: ai
        }
    ]
    actionBarVisibility: ChromeVisibility.Compact
    ScrollView {
        id: about_scrollview
        horizontalAlignment: HorizontalAlignment.Fill
        Container {
            Header {
                title: qsTr("ABOUT THIS APP")
                subtitle: qsTr("UNOFFICIAL ONE")
            }
            ImageView {
                imageSource: "asset:///res/icon.png"
                horizontalAlignment: HorizontalAlignment.Fill
                scalingMethod: ScalingMethod.AspectFit
                topMargin: 50.0
            }
            Label {
                textStyle.fontFamily: "bradley"
                text: qsTr("one for BlackBerry 10, ") + ai.version
                textStyle.rules: fontbradley
                horizontalAlignment: HorizontalAlignment.Fill
                textStyle.textAlign: TextAlign.Center
            }
            Divider {

            }
            Label {
                multiline: true
                text: "不追热点，不关时政，不要喧哗，不惹纷争。\r\n关掉微博，离开微信，\r\n带着微笑，去到 Web 0.1 时代。\r\n「一个」足够简单。\r\n\r\n复杂世界里，一个就够了。"
                textStyle.textAlign: TextAlign.Center
                horizontalAlignment: HorizontalAlignment.Fill
                textStyle.fontWeight: FontWeight.W100
                textStyle.fontStyle: FontStyle.Normal
            }
            Header {
                title: qsTr("ABOUT PROJECT ONE3.0")
            }
            Container {
                topPadding: 20.0
                leftPadding: 20.0
                bottomPadding: 20.0
                rightPadding: 20.0
                Label {
                    text: qsTr("Project ONE 3.0 is my 1st BlackBerry 10 project in 2016, it's FREE and offers a similar UI for ONE readers from other platforms. The complete project is open-sourced on Github, you're always welcomed to send me pull requests.")
                    multiline: true
                    horizontalAlignment: HorizontalAlignment.Fill
                    textStyle.textAlign: TextAlign.Center

                }
            }
            Button {
                horizontalAlignment: HorizontalAlignment.Center
                text: qsTr("Source Code on Github")
                onClicked: {
                    var web = Qt.createComponent("WebBrowser.qml").createObject(nav);
                    web.nav = nav;
                    web.uri = "https://github.com/anpho/one3.0"
                    nav.push(web);
                }
            }
            Container {
                topPadding: 20.0
                leftPadding: 20.0
                bottomPadding: 20.0
                rightPadding: 20.0
                Label {
                    text: qsTr("Please use the button below to submit issues, including bugs, feature requests, etc.")
                    multiline: true
                    horizontalAlignment: HorizontalAlignment.Fill
                    textStyle.textAlign: TextAlign.Center

                }
            }
            Button {
                horizontalAlignment: HorizontalAlignment.Center
                text: qsTr("Submit Issues")
                onClicked: {
                    var web = Qt.createComponent("WebBrowser.qml").createObject(nav);
                    web.nav = nav;
                    web.uri = "https://github.com/anpho/one3.0/issues"
                    nav.push(web);
                }
            }
            Header {
                title: qsTr("ABOUT THE DEVELOPER TEAM")
            }
            ImageView {
                imageSource: "asset:///res/merrick.png"
                horizontalAlignment: HorizontalAlignment.Center
                scalingMethod: ScalingMethod.AspectFit
                topMargin: 20.0
                gestureHandlers: TapHandler {
                    onTapped: {
                        var web = Qt.createComponent("WebBrowser.qml").createObject(nav);
                        web.nav = nav;
                        web.uri = qsTr("http://twitter.com/anpho")
                        nav.push(web);
                    }
                }
            }
            Label {
                multiline: true
                textStyle.textAlign: TextAlign.Center
                horizontalAlignment: HorizontalAlignment.Fill
                textStyle.fontWeight: FontWeight.W100
                textStyle.fontStyle: FontStyle.Normal
                text: qsTr("Merrick Zhang")
                textFormat: TextFormat.Html
                textStyle.fontSize: FontSize.Large
            }
            Label {
                multiline: true
                textStyle.textAlign: TextAlign.Center
                horizontalAlignment: HorizontalAlignment.Fill
                textStyle.fontWeight: FontWeight.W100
                textStyle.fontStyle: FontStyle.Normal
                text: qsTr("Designer, UI, Developer, i18n")
                textFormat: TextFormat.Html
            }
            Button {
                horizontalAlignment: HorizontalAlignment.Center
                text: qsTr("My BlackBerry 10 Apps")
                onClicked: {
                    Qt.openUrlExternally("appworld://vendor/26755")
                }
            }
            Divider {
                
            }
            Label {
                text: "果果Song"
                horizontalAlignment: HorizontalAlignment.Fill
                textStyle.textAlign: TextAlign.Center
                textStyle.fontSize: FontSize.Large
                textStyle.fontWeight: FontWeight.W100
            }
            Label {
                multiline: true
                textStyle.textAlign: TextAlign.Center
                horizontalAlignment: HorizontalAlignment.Fill
                textStyle.fontWeight: FontWeight.W100
                textStyle.fontStyle: FontStyle.Normal
                text: qsTr("Tester, Github Issues Maintainer")
                textFormat: TextFormat.Html
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
            }

        }
    }
}
