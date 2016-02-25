import bb.cascades 1.4

Page {
    actionBarAutoHideBehavior: ActionBarAutoHideBehavior.HideOnScroll
    property bool hidebackbutton: false
    function setCSS(loc){
        webv.settings.userStyleSheetLocation = loc
    }
    function setActive() {
        web_scrollview.scrollRole = ScrollRole.Main
    }

    actions: [
        ActionItem {
            ActionBar.placement: ActionBarPlacement.Signature
            title: qsTr("Back")
            imageSource: "asset:///icon/ic_previous.png"
            enabled: webv.canGoBack
            onTriggered: {
                webv.goBack()
            }
        }
    ]
    actionBarVisibility: hidebackbutton ? ChromeVisibility.Hidden : ChromeVisibility.Compact
    property variant nav
    property alias uri: webv.url
    ScrollView {
        id: web_scrollview
        horizontalAlignment: HorizontalAlignment.Fill
        WebView {
            preferredHeight: Infinity
            id: webv
            horizontalAlignment: HorizontalAlignment.Fill
            settings.userAgent: "Mozilla/5.0 (Linux; U; Android 2.3.7; en-us; Nexus One Build/FRF91) AppleWebKit/533.1 (KHTML, like Gecko) Version/4.0 Mobile Safari/533.1"
            onNavigationRequested: {
                var target = request.url;
                if (request.navigationType == WebNavigationType.OpenWindow) {
                    var newpage = Qt.createComponent("WebBrowser.qml").createObject(nav);
                    newpage.uri = target;
                    nav.push(newpage)
                    request.action = WebNavigationRequestAction.Ignore
                }
            }
        }
    }
}
