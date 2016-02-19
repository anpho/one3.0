import bb.cascades 1.4
import bb.system 1.2
Page {
    property variant nav
    property alias hid: shv.hid
    function invokeShareText(text) {
        _app.shareText(text)
    }
    function invokeCopyText(text) {
        var ret = parseInt(_app.setTextToClipboard(text))
        if (ret > 0) {
            sst.body = qsTr("Copied to Clipboard");
        } else {
            sst.body = qsTr("ERROR")
        }
        sst.show();
    }
    function invokeAuthorView(authorid) {
        //TODO AUTHORVIEW
    }
    function invokeImageViewer(imgsrc) {
        _app.viewimage(imgsrc)
    }
    attachedObjects: [
        SystemToast {
            id: sst
        }
    ]
    actionBarVisibility: ChromeVisibility.Compact
    SingleHomepageView {
        id: shv
        verticalAlignment: VerticalAlignment.Fill
        onRequestAuthorView: {
            invokeAuthorView(authorid)
        }
        onRequestImageView: {
            invokeImageViewer(src)
        }
        onRequestCopyText: {
            invokeCopyText(text)
        }
        onRequestShareText: {
            invokeShareText(text)
        }
        horizontalAlignment: HorizontalAlignment.Fill
    }
}
