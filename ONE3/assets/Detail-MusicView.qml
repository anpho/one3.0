import bb.cascades 1.4
import bb.system 1.2
Page {
    property variant nav
    property alias music_id: shv.music_id
    function invokeAuthorView(authorid) {
        //TODO AUTHORVIEW
    }

    attachedObjects: [
        SystemToast {
            id: sst
        }
    ]
    actionBarVisibility: ChromeVisibility.Compact
    function showweb(url) {
        var webpage = Qt.createComponent("WebBrowser.qml").createObject(nav);
        webpage.nav = nav
        webpage.uri = url;
        nav.push(webpage)
    }
    function html2text(story) {
        // override html2text function
        return _app.html2text(story);
    }
    SingleMusicView {
        id: shv
        onRequestWebView: {
            showweb(uri)
        }
        function html2text(str) {
            return _app.html2text(str)
        }
        horizontalAlignment: HorizontalAlignment.Fill
    }
}
