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
        },
        NowPlayingConnection {
            connectionName: "mpconnMusic"
            id: npc
            iconUrl: "asset:///res/nav_title.png"
            onAcquired: {
                var metadata = {
                    "track": "",
                    "artist": ""
                };
                npc.mediaState = MediaState.Started;
                npc.setMetaData(metadata);
            }
            nextEnabled: false
            previousEnabled: false
            repeatMode: RepeatMode.Unsupported
            shuffleMode: ShuffleMode.Unsupported
            onPause: {
                mp.pause()
            }
            onPlay: {
                mp.play()
            }
        },
        MediaPlayer {
            id: mp
            onMediaStateChanged: {
                if (mediaState == MediaState.Started) {
                    npc.acquire()
                } else {
                    npc.revoke()
                }
            }
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
        onRequestDirectPlay: {
            isPlaying = true
            mp.reset()
            mp.sourceUrl = uri;
            mp.play();
        }
        onRequestDirectPause: {
            isPlaying = false;
            mp.stop();
        }
        function html2text(str) {
            return _app.html2text(str)
        }
        horizontalAlignment: HorizontalAlignment.Fill
    }
}
