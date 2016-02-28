import bb.cascades 1.4
import bb.system 1.2
import bb.multimedia 1.4
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
        webpage.setCSS("asset:///xiami.css");
        webpage.hidebackbutton = true;
        nav.push(webpage)
    }
    function html2text(story) {
        // override html2text function
        return _app.html2text(story);
    }
    SingleMusicView {
        id: shv
        fontsize: nav.fontsize
        onRequestWebView: {
            nav.audiomgr.stop();
            showweb(uri)
        }
        onRequestDirectPlay: {
            nav.audiomgr.play(uri, meta);
        }
        onRequestDirectPause: {
            nav.audiomgr.pause();
        }
        onRequestShare: {
            _app.shareText(uri);
        }
        function checkstate() {
            return checkPlayerstate(music_url)
        }
        function checkPlayerstate(audio_url) {
            var nowstate = nav.audiomgr.mediaState;
            var playingurl = nav.audiomgr.cur;
            if (audio_url == playingurl) {
                // is playing current audio
                if (nowstate == MediaState.Started) {
                    return 1; // started
                } else if (nowstate == MediaState.Stopped) {
                    return 0;
                } else if (nowstate == MediaState.Paused) {
                    return 2;
                } else {
                    return -1;
                }
            } else {
                return 0;
            }
        }
        function html2text(str) {
            return _app.html2text(str)
        }
        horizontalAlignment: HorizontalAlignment.Fill
    }
}
