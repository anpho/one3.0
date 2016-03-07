import bb.cascades 1.4
import cn.anpho 1.0
import bb.multimedia 1.4
import bb.system 1.2
Page {
    property NavigationPane nav

    property string essayid
    property string endpoint: "http://v3.wufazhuce.com:8000/api/essay/%1"
    onEssayidChanged: {
        if (essayid.trim().length > 0) {
            load();
        }
    }
    function requestAuthorView(author_id) {
        //TODO SHOW AUTHOR VIEW
    }
    function load() {
        var endp = endpoint.arg(essayid);
        co.ajax("GET", endp, [], function(b, d) {
                if (b) {
                    try {
                        d = JSON.parse(d).data;

                        author_id = d.author[0].user_id
                        author_img = d.author[0].web_url
                        author_introduce = d.hp_author_introduce
                        author_it = d.auth_it
                        author_name = d.hp_author
                        author_weibo = d.wb_name

                        c_content = d.hp_content
                        console.log(c_content.length)
                        c_intro = d.guide_word
                        c_subtitle = co.valueOrEmpty(d.sub_title)
                        c_title = d.hp_title
                        c_time = d.hp_makettime

                        audio_url = d.audio
                    } catch (e) {
                        sst.body = qsTr("Error: %1").arg(JSON.stringify(e))
                        sst.show();
                    }

                } else {
                    sst.body = qsTr("Error : %1").arg(d)
                    sst.show();
                }
                loadRelated()
            }, [], false, true)
    }
    // AUTHOR
    property string author_img
    onAuthor_imgChanged: {
        if (author_img.length > 0) {
            author_imgview.url = author_img
        }
    }
    property string author_id
    property string author_name
    property string author_it
    property string author_weibo
    // AUDIO
    property string audio_url

    // CONTENT
    property string c_title
    property string c_subtitle
    property string c_intro
    property string c_content
    property string c_time
    property string author_introduce

    // RELATED CONTENT
    property int related_content_count
    property string related_endpoint: "http://v3.wufazhuce.com:8000/api/related/essay/%1"
    function loadRelated() {
        var endp = related_endpoint.arg(essayid)
        relatedArticles.removeAll()
        co.ajax("GET", endp, [], function(b, d) {
                if (b) {
                    try {
                        d = JSON.parse(d).data;
                        related_content_count = d.length;
                        for (var i = 0; i < related_content_count; i ++) {
                            var relContainer = relatedArticle.createObject(nav);
                            relContainer.ttitle = d[i].hp_title;
                            relContainer.tid = d[i].content_id;
                            relContainer.tintro = d[i].guide_word;
                            relContainer.timgurl = d[i].author[0].web_url;
                            relContainer.tauthor = d[i].author[0].user_name;
                            relContainer.tweibo = d[i].author[0].wb_name;
                            relatedArticles.add(relContainer)
                        }
                    } catch (e) {

                    }
                }
            }, [], false)
    }
    attachedObjects: [
        Common {
            id: co
        },
        SystemToast {
            id: sst
        },
        ComponentDefinition {
            id: relatedArticle
            ArticleItemTemplate {
                leftPadding: 0.0
                rightPadding: 0.0
                onReqDetail: {
                    var newEssay = Qt.createComponent("Detail-EssayView.qml").createObject(nav);
                    newEssay.nav = nav;
                    newEssay.essayid = tid;
                    nav.push(newEssay);
                }
            }
        }
    ]
    function setActive() {
//        scrollview.scrollRole = ScrollRole.Main
    }
    function checkstate() {
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
    titleBar: TitleBar {
        title: qsTr("Essay")
        dismissAction: ActionItem {
            title: qsTr("Back")
            onTriggered: {
                nav.pop();
            }
        }
        acceptAction: checkstate() == -1 ? bufferingbutton : checkstate() == 1 ? pausebutton : playbutton
        attachedObjects: [
            ActionItem {
                id: pausebutton
                imageSource: "asset:///icon/ic_pause.png"
                title: qsTr("PAUSE")
                onTriggered: {
                    nav.audiomgr.pause();
                }
                enabled: audio_url.length > 0
            },
            ActionItem {
                id: playbutton
                imageSource: "asset:///icon/ic_play.png"
                title: qsTr("PLAY")
                onTriggered: {
                    nav.audiomgr.play(audio_url, {
                            "title": c_title,
                            "author": author_name
                        });
                }
                enabled: audio_url.length > 0
            },
            ActionItem {
                id: bufferingbutton
                imageSource: "asset:///icon/ic_history.png"
                title: qsTr("...")
                enabled: false
            }
        ]
        scrollBehavior: TitleBarScrollBehavior.NonSticky

    }
    actionBarVisibility: ChromeVisibility.Compact
    actionBarAutoHideBehavior: ActionBarAutoHideBehavior.HideOnScroll
    ScrollView {
        id: scrollview
        gestureHandlers: DoubleTapHandler {
            onDoubleTapped: {
                scrollview.scrollToPoint(0, 0)
            }
        }
        scrollRole: ScrollRole.Main
        Container {
            leftPadding: 20.0
            topPadding: 20.0
            rightPadding: 20.0
            bottomPadding: 100.0
            Container {
                gestureHandlers: TapHandler {
                    onTapped: {
                        requestAuthorView(author_id)
                    }
                }
                implicitLayoutAnimationsEnabled: false
                Container {
                    layout: StackLayout {
                        orientation: LayoutOrientation.LeftToRight

                    }
                    implicitLayoutAnimationsEnabled: false
                    WebImageView {
                        preferredHeight: ui.du(8)
                        preferredWidth: ui.du(8)
                        id: author_imgview
                        verticalAlignment: VerticalAlignment.Center
                    }
                    Label {
                        text: author_name
                        textStyle.textAlign: TextAlign.Left
                        horizontalAlignment: HorizontalAlignment.Fill
                        verticalAlignment: VerticalAlignment.Center
                        textStyle.fontWeight: FontWeight.W100
                        textStyle.fontSize: FontSize.Large
                        implicitLayoutAnimationsEnabled: false
                        leftMargin: 20.0
                    }
                }

                Label {
                    multiline: true
                    text: author_it
                    visible: text.length > 0
                    textStyle.fontSize: FontSize.XSmall
                    textStyle.fontWeight: FontWeight.W100
                    opacity: 0.6
                    textFormat: TextFormat.Plain
                    horizontalAlignment: HorizontalAlignment.Fill
                    textStyle.textAlign: TextAlign.Left
                    implicitLayoutAnimationsEnabled: false
                }
                Label {
                    text: author_weibo
                    visible: text.length > 0
                    textStyle.fontSize: FontSize.XSmall
                    textStyle.fontWeight: FontWeight.W100
                    opacity: 0.6
                    horizontalAlignment: HorizontalAlignment.Fill
                    textStyle.textAlign: TextAlign.Left
                    implicitLayoutAnimationsEnabled: false
                }
            }
            Label {
                text: c_title
                horizontalAlignment: HorizontalAlignment.Fill
                textStyle.textAlign: TextAlign.Center
                textStyle.fontSize: FontSize.Large
                textStyle.fontWeight: FontWeight.W100
                implicitLayoutAnimationsEnabled: false
            }
            Label {
                text: _app.html2text(c_content)
                textFormat: TextFormat.Html
                verticalAlignment: VerticalAlignment.Top
                horizontalAlignment: HorizontalAlignment.Fill
                multiline: true
                textStyle.fontSize: FontSize.PercentageValue
                textStyle.fontSizeValue: nav.fontsize
                textStyle.textAlign: TextAlign.Left
                implicitLayoutAnimationsEnabled: false
            }
            Label {
                text: author_introduce
                textStyle.fontStyle: FontStyle.Italic
                textStyle.fontWeight: FontWeight.W100
                textStyle.fontSize: FontSize.XSmall
                opacity: 0.6
                verticalAlignment: VerticalAlignment.Fill
                horizontalAlignment: HorizontalAlignment.Fill
                textStyle.textAlign: TextAlign.Right
            }
            Container {
                visible: related_content_count > 0
                horizontalAlignment: HorizontalAlignment.Fill
                Header {
                    title: qsTr("RELATED ARTICLES")
                }
                Container {
                    id: relatedArticles
                }
            }
        }
    }
}
