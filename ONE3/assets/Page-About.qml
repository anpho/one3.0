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
            ActionBar.placement: ActionBarPlacement.OnBar
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
                title: qsTr("ABOUT THE DEVELOPER")
            }
            Label {
                multiline: true
                textStyle.textAlign: TextAlign.Center
                horizontalAlignment: HorizontalAlignment.Fill
                textStyle.fontWeight: FontWeight.W100
                textStyle.fontStyle: FontStyle.Normal
                text: qsTr("<p>Merrick Zhang</p>\r\n<p><a href=\"mailto:anphorea@gmail.com?subject=one3\">Email</a>  ~  <a href=\"http://twitter.com/anpho\">Twitter</a></p>\r\n<p>If you like this app, please make a donation to anphorea@gmail.com via paypal or alipay to support my development. Thank you.</p>\r\n<p>This app is open-sourced</p>\r\n<a href=\"http://github.com/anpho/one3.0\">Github</a>  ~  <a href=\"https://github.com/anpho/one3.0/issues\">Submit Issues</a>\r\n")
                textFormat: TextFormat.Html
            }
        }
    }
}
