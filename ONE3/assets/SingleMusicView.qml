import bb.cascades 1.4
import cn.anpho 1.0
import bb.device 1.4
ScrollView {
    id: scrollviewroot
    signal requestWebView(string uri)
    signal requestDirectPlay(string uri, variant meta)
    signal requestDirectPause()
    function setActive() {
        scrollRole = ScrollRole.Main
    }
    function checkstate() {
        return scrollviewroot.ListItem.view.checkstate(music_url)
    }

    function html2text(story) {
        return scrollviewroot.ListItem.view.html2text(story)
    }
    property string endpoint: "http://v3.wufazhuce.com:8000/api/music/detail/%1"
    property string errmsg: qsTr("Error : %1")

    property variant ajaxdata

    // MUSIC INFO
    property string music_id
    onMusic_idChanged: {
        if (music_id.trim().length > 0)
            load();
    }
    property string music_title
    property string music_cover
    onMusic_coverChanged: {
        if (music_cover.length > 0) {
            cover_img.url = music_cover
        }
    }
    property string music_lyric
    property string music_info
    property string related_to
    property string xiami_id
    property string charge_edt
    property string web_url
    property string music_url
    property string author_name
    property string author_id
    property string author_img
    onAuthor_imgChanged: {
        if (author_img.length > 0) {
            singer_img.url = author_img
        }
    }
    property string author_desc
    property string story
    property string story_author_id
    property string story_author_name
    property string story_title
    function load() {
        var endp = endpoint.arg(music_id);
        co.ajax("GET", endp, [], function(b, d) {
                if (b) {
                    d = JSON.parse(d);
                    if (d.data) {
                        ajaxdata = d.data;
                        music_cover = ajaxdata.cover;
                        music_info = ajaxdata.info
                        music_lyric = ajaxdata.lyric
                        music_title = ajaxdata.title
                        music_url = ajaxdata.music_id
                        related_to = ajaxdata.related_to
                        xiami_id = ajaxdata.music_id
                        charge_edt = ajaxdata.charge_edt
                        web_url = ajaxdata.web_url
                        author_id = ajaxdata.author.user_id
                        author_name = ajaxdata.author.user_name
                        author_img = ajaxdata.author.web_url
                        author_desc = ajaxdata.author.desc
                        story = ajaxdata.story
                        story_title = ajaxdata.story_title
                        if (story.length > 0) {
                            story_author_id = ajaxdata.story_author.user_id
                            story_author_name = ajaxdata.story_author.user_name
                        }
                    }
                } else {
                    music_info = errmsg.arg(d)
                }
            }, [], false, true);
    }
    attachedObjects: [
        Common {
            id: co
        },
        DisplayInfo {
            id: di
        }
    ]
    scrollRole: ScrollRole.Main
    builtInShortcutsEnabled: true
    Container {
        horizontalAlignment: HorizontalAlignment.Fill
        bottomPadding: 100.0
        WebImageView {
            scalingMethod: ScalingMethod.AspectFill
            horizontalAlignment: HorizontalAlignment.Fill
            implicitLayoutAnimationsEnabled: false
            imageSource: "asset:///res/music_cover.png"
            id: cover_img
            preferredWidth: di.pixelSize.width
            preferredHeight: di.pixelSize.width * 9 / 16
        }
        Container {
            translationY: -50.0
            leftPadding: 40.0
            rightPadding: 40.0
            horizontalAlignment: HorizontalAlignment.Fill
            Container {
                background: ui.palette.background
                layout: StackLayout {
                    orientation: LayoutOrientation.LeftToRight
                }
                horizontalAlignment: HorizontalAlignment.Fill
                topPadding: 20.0
                leftPadding: 20.0
                bottomPadding: 20.0
                rightPadding: 20.0
                opacity: 0.8
                WebImageView {
                    imageSource: "asset:///res/music_tone.png"
                    id: singer_img
                    preferredHeight: ui.du(8)
                    scalingMethod: ScalingMethod.AspectFit
                    verticalAlignment: VerticalAlignment.Center
                }
                Label {
                    text: author_name
                    textStyle.fontSize: FontSize.Large
                    verticalAlignment: VerticalAlignment.Center
                    layoutProperties: StackLayoutProperties {
                        spaceQuota: 1.0
                    }
                }
                ImageView {
                    imageSource: "asset:///res/xiami.png"
                    scalingMethod: ScalingMethod.AspectFit
                    visible: music_url.indexOf("http://") < 0
                    gestureHandlers: TapHandler {
                        onTapped: {
                            requestWebView(web_url)
                        }
                    }
                }
                ImageView {
                    visible: music_url.indexOf("http://") == 0
                    imageSource: checkstate() == 1 ? "asset:///icon/ic_pause.png" : "asset:///icon/ic_play.png"
                    filterColor: Color.create("#ff00a4ff")
                    gestureHandlers: TapHandler {
                        onTapped: {
                            checkstate() == 1 ? requestDirectPause() : requestDirectPlay(music_url, {
                                    "title": music_title,
                                    "author": author_name
                                })
                        }
                    }
                }
            }
            Label {
                text: author_desc
                textStyle.fontSize: FontSize.XSmall
                opacity: 0.6
                multiline: true
            }
            Label {
                text: music_title
                textStyle.fontSize: FontSize.Large
                multiline: true
                horizontalAlignment: HorizontalAlignment.Fill
                textStyle.textAlign: TextAlign.Center
            }
        }
        SegmentedControl {
            id: togglecontrol
            options: [
                Option {
                    text: qsTr("STORY")
                    id: tstory
                },
                Option {
                    text: qsTr("LYRICS")
                    id: tlyric
                },
                Option {
                    text: qsTr("INFO")
                    id: tinfo
                }
            ]
            horizontalAlignment: HorizontalAlignment.Center
        }
        Container {
            visible: togglecontrol.selectedOption == tstory
            horizontalAlignment: HorizontalAlignment.Fill
            leftPadding: 20.0
            rightPadding: 20.0
            Label {
                text: story_title
                multiline: true
                textStyle.fontSize: FontSize.Large
                textStyle.fontWeight: FontWeight.W100
                horizontalAlignment: HorizontalAlignment.Fill
                textStyle.textAlign: TextAlign.Left
            }
            Label {
                text: story_author_name
                horizontalAlignment: HorizontalAlignment.Left
            }
            Label {
                text: html2text(story)
                multiline: true
                textFormat: TextFormat.Html
                horizontalAlignment: HorizontalAlignment.Fill
                textStyle.textAlign: TextAlign.Justify
                textStyle.fontSize: FontSize.Medium
            }
        }
        Container {
            visible: togglecontrol.selectedOption == tlyric
            horizontalAlignment: HorizontalAlignment.Fill
            leftPadding: 20.0
            rightPadding: 20.0
            Label {
                text: music_lyric
                multiline: true
                textFormat: TextFormat.Html
                textStyle.fontSize: FontSize.Medium
            }
        }
        Container {
            visible: togglecontrol.selectedOption == tinfo
            horizontalAlignment: HorizontalAlignment.Fill
            leftPadding: 20.0
            rightPadding: 20.0
            Label {
                text: music_info
                multiline: true
                textFormat: TextFormat.Html
                textStyle.fontSize: FontSize.Medium
            }
        }
        Container {
            id: related_musics_container

            topMargin: 50.0
            visible: false
            opacity: 0.1
            Header {
                title: qsTr("RELATED MUSIC")
            }
        }
        Divider {
            topMargin: 50.0

        }
    }
}
