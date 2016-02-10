import bb.cascades 1.4

Page {
    actionBarAutoHideBehavior: ActionBarAutoHideBehavior.HideOnScroll
    function setActive() {
        web_scrollview.scrollRole = ScrollRole.Main
    }
    property variant nav
    property alias uri: webv.url
    ScrollView {
        id: web_scrollview
        horizontalAlignment: HorizontalAlignment.Fill
        WebView {
            id: webv
            horizontalAlignment: HorizontalAlignment.Fill
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
