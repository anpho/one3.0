import bb.cascades 1.4
import cn.anpho 1.0
import bb.system 1.2
Page {
    property variant nav

    property string qid
    property string endpoint: "http://v3.wufazhuce.com:8000/api/question/%1"
    onQidChanged: {
        if (qid.trim().length > 0) {
            load();
        }
    }
    function load() {
        var endp = endpoint.arg(qid);
        co.ajax("GET", endp, [], function(b, d) {
                if (b) {
                    try {
                        d = JSON.parse(d).data;

                        q_title = d.question_title
                        q_content = d.question_content
                        a_title = d.answer_title
                        a_content = d.answer_content
                        charge_edt = d.charge_edt
                    } catch (e) {
                        sst.body = qsTr("Error: %1").arg(JSON.stringify(e))
                        sst.show();
                    }

                } else {
                    sst.body = qsTr("Error : %1").arg(d)
                    sst.show();
                }
                loadRelated()
            }, [], false,true )
    }

    // CONTENT
    property string q_title
    property string q_content
    property string a_title
    property string a_content
    property string charge_edt

    // RELATED CONTENT
    property int related_content_count
    property string related_endpoint: "http://v3.wufazhuce.com:8000/api/related/question/%1"
    function loadRelated() {
        var endp = related_endpoint.arg(qid)
        relatedArticles.removeAll()
        co.ajax("GET", endp, [], function(b, d) {
                if (b) {
                    try {
                        d = JSON.parse(d).data;
                        related_content_count = d.length;
                        for (var i = 0; i < related_content_count; i ++) {
                            var relContainer = relatedArticle.createObject(nav);
                            relContainer.ttitle = d[i].question_title;
                            relContainer.tid = d[i].question_id;
                            relContainer.tintro = d[i].answer_title;
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
                    var qe = Qt.createComponent("Detail-QAView.qml").createObject(nav);
                    qe.nav = nav;
                    qe.qid = tid;
                    nav.push(qe);
                }
            }
        }
    ]
    function setActive() {
        scrollview.scrollRole = ScrollRole.Main
    }
    titleBar: TitleBar {
        title: qsTr("Q&A")
        dismissAction: ActionItem {
            title: qsTr("Back")
            onTriggered: {
                nav.pop();
            }
        }
    }
    actionBarVisibility: ChromeVisibility.Compact
    actionBarAutoHideBehavior: ActionBarAutoHideBehavior.HideOnScroll
    ScrollView {
        id: scrollview
        Container {
            leftPadding: 20.0
            topPadding: 20.0
            rightPadding: 20.0
            bottomPadding: 100.0
            Label {
                text: q_title
                horizontalAlignment: HorizontalAlignment.Fill
                textStyle.textAlign: TextAlign.Left
                textStyle.fontSize: FontSize.Large
                textStyle.fontWeight: FontWeight.W100
                implicitLayoutAnimationsEnabled: false
                multiline: true
            }

            Label {
                text: q_content
                textFormat: TextFormat.Html
                verticalAlignment: VerticalAlignment.Top
                horizontalAlignment: HorizontalAlignment.Fill
                multiline: true
                textStyle.fontSize: FontSize.PercentageValue
                textStyle.fontSizeValue: nav.fontsize
                textStyle.textAlign: TextAlign.Left
                implicitLayoutAnimationsEnabled: false
                textStyle.fontWeight: FontWeight.W100
            }
            Divider {
                visible: q_content.length > 0
            }
            Label {
                text: a_title
                horizontalAlignment: HorizontalAlignment.Fill
                textStyle.textAlign: TextAlign.Left
                textStyle.fontSize: FontSize.Large
                textStyle.fontWeight: FontWeight.W100
                implicitLayoutAnimationsEnabled: false
                multiline: true
            }

            Label {
                text: _app.html2text(a_content)
                textFormat: TextFormat.Html
                verticalAlignment: VerticalAlignment.Top
                horizontalAlignment: HorizontalAlignment.Fill
                multiline: true
                textStyle.fontSize: FontSize.PercentageValue
                textStyle.fontSizeValue: nav.fontsize
                textStyle.textAlign: TextAlign.Left
                implicitLayoutAnimationsEnabled: false
                textStyle.fontWeight: FontWeight.W100
            }
            Label {
                text: charge_edt
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
