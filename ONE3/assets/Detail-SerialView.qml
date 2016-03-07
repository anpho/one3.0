import bb.cascades 1.4
import cn.anpho 1.0
import bb.system 1.2
Page {
    property variant nav

    property string serialid
    property string endpoint: "http://v3.wufazhuce.com:8000/api/serialcontent/%1"
    onSerialidChanged: {
        if (serialid.trim().length > 0) {
            load();
        }
    }
    function requestAuthorView(author_id) {
        //TODO SHOW AUTHOR VIEW
    }
    function load() {
        var endp = endpoint.arg(serialid);
        co.ajax("GET", endp, [], function(b, d) {
                if (b) {
                    try {
                        d = JSON.parse(d).data;

                        author_id = d.author.user_id
                        author_img = d.author.web_url
                        author_introduce = d.charge_edt
                        author_name = d.author.user_name

                        c_content = d.content
                        console.log(c_content.length)
                        c_intro = d.excerpt
                        c_subtitle = d.number
                        c_title = d.title
                        c_time = d.maketime

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
    property string related_endpoint: "http://v3.wufazhuce.com:8000/api/related/serial/%1"
    function loadRelated() {
        var endp = related_endpoint.arg(serialid)
        relatedArticles.removeAll()
        co.ajax("GET", endp, [], function(b, d) {
                if (b) {
                    try {
                        d = JSON.parse(d).data;
                        related_content_count = d.length;
                        for (var i = 0; i < related_content_count; i ++) {
                            var relContainer = relatedArticle.createObject(nav);
                            relContainer.ttitle = d[i].title;
                            relContainer.tid = d[i].id;
                            relContainer.tintro = d[i].excerpt;
                            relContainer.timgurl = d[i].author.web_url;
                            relContainer.tauthor = d[i].author.user_name;
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
                leftImage: "asset:///icon/ic_notes.png"
                onReqDetail: {
                    var newEssay = Qt.createComponent("Detail-SerialView.qml").createObject(nav);
                    newEssay.nav = nav;
                    newEssay.serialid = tid;
                    nav.push(newEssay);
                }
            }
        }
    ]
    function setActive() {
        scrollview.scrollRole = ScrollRole.Main
    }
    titleBar: TitleBar {
        title: qsTr("Serials")
        dismissAction: ActionItem {
            title: qsTr("Back")
            onTriggered: {
                nav.pop();
            }
        }
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
        Container {
            leftPadding: 20.0
            topPadding: 20.0
            rightPadding: 20.0
            bottomPadding: 20.0
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
