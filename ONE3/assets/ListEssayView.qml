import bb.cascades 1.4
import bb.device 1.4
import bb.system 1.2
Page {
    property variant nav
    function setActive() {
    }
    titleBar: TitleBar {
        kind: TitleBarKind.FreeForm
        kindProperties: FreeFormTitleBarKindProperties {
            Container {
                layout: StackLayout {
                    orientation: LayoutOrientation.LeftToRight
                }
                leftPadding: 10.0
                rightPadding: 10.0
                ImageView {
                    imageSource: "asset:///icon/ic_all.png"
                    scalingMethod: ScalingMethod.AspectFit
                    verticalAlignment: VerticalAlignment.Center
                    filterColor: ui.palette.primaryBase
                    gestureHandlers: TapHandler {
                        onTapped: {
                            console.log("ALL SERIES")
                            //TODO SHOW ALL HOMEPAGE ENTRIES
                            var olddays = Qt.createComponent("Page-Articles-By-Month.qml").createObject(nav);
                            olddays.nav = nav;
                            nav.push(olddays)
                        }
                    }
                }
                Label {
                    text: qsTr("Articles")
                    verticalAlignment: VerticalAlignment.Center
                    textStyle.fontSize: FontSize.Large
                    horizontalAlignment: HorizontalAlignment.Fill
                    layoutProperties: StackLayoutProperties {
                        spaceQuota: 1.0

                    }
                    textStyle.textAlign: TextAlign.Center

                }
                ImageView {
                    imageSource: "asset:///icon/ic_search.png"
                    scalingMethod: ScalingMethod.AspectFit
                    verticalAlignment: VerticalAlignment.Center
                    filterColor: ui.palette.primaryBase
                    gestureHandlers: TapHandler {
                        onTapped: {
                            console.log("SEARCH")
                            //TODO SHOW SEARCH PANEL
                            var searchPanel = Qt.createComponent("Page-Search-Essay.qml").createObject(nav);
                            searchPanel.nav = nav;
                            nav.push(searchPanel)
                        }
                    }
                }
            }

        }
        scrollBehavior: TitleBarScrollBehavior.Sticky

    }
    actionBarAutoHideBehavior: ActionBarAutoHideBehavior.HideOnScroll
    actionBarVisibility: ChromeVisibility.Compact
    ListView {
        id: essaylistview
        property string endpoint: "http://v3.wufazhuce.com:8000/api/reading/index/"
        attachedObjects: [
            DisplayInfo {
                id: di
            },
            Common {
                id: co
            },
            SystemToast {
                id: sst
            },
            ListScrollStateHandler {
                onFirstVisibleItemChanged: {
                    if (firstVisibleItem.setActive) {
                        firstVisibleItem.setActive()
                    }
                }
            }
        ]
        dataModel: ArrayDataModel {
            id: adm
        }
        scrollIndicatorMode: ScrollIndicatorMode.ProportionalBar
        snapMode: SnapMode.LeadingEdge
        flickMode: FlickMode.SingleItem
        layout: StackListLayout {
            orientation: LayoutOrientation.LeftToRight
            headerMode: ListHeaderMode.None
        }

        property int width: di.pixelSize.width
        function showEssay(essayid) {
            // 显示短篇
            var essayview = Qt.createComponent("Detail-EssayView.qml").createObject(nav);
            essayview.essayid = essayid;
            essayview.nav = nav;
            nav.push(essayview)
        }
        function showSerial(serialid) {
            var serialview = Qt.createComponent("Detail-SerialView.qml").createObject(nav);
            serialview.serialid = serialid
            serialview.nav = nav;
            nav.push(serialview)
        }
        function showQA(qid) {
            var qaview = Qt.createComponent("Detail-QAView.qml").createObject(nav);
            qaview.qid = qid
            qaview.nav = nav;
            nav.push(qaview)
        }
        listItemComponents: [
            ListItemComponent {
                type: ""
                SingleEssayView {
                    id: shv
                    preferredHeight: Infinity
                    preferredWidth: shv.ListItem.view.width
                    // Set property
                    essay_title: ListItemData.essay.hp_title
                    essay_author: ListItemData.essay.author[0].user_name
                    essay_authorid: ListItemData.essay.author[0].user_id
                    essay_imgurl: ListItemData.essay.author[0].web_url
                    essay_weibo: ListItemData.essay.author[0].wb_name
                    essay_id: ListItemData.essay.content_id
                    essay_intro: ListItemData.essay.guide_word
                    essay: ListItemData.essay
                    // serial
                    serial_author: ListItemData.serial.author.user_name
                    serial_authorid: ListItemData.serial.author.user_id
                    serial_id: ListItemData.serial.id
                    serial_imgurl: ListItemData.serial.author.web_url
                    serial_intro: ListItemData.serial.excerpt
                    serial_title: ListItemData.serial.title
                    serial: ListItemData.serial
                    // q and a
                    q_title: ListItemData.question.question_title
                    q_intro: ListItemData.question.answer_title
                    q_id: ListItemData.question.question_id
                    q: ListItemData.question
                    onRequestAuthorView: {

                    }
                    onRequestEssay: {
                        shv.ListItem.view.showEssay(essayid)
                    }
                    onRequestQA: {
                        shv.ListItem.view.showQA(qid)
                    }
                    onRequestSerial: {
                        shv.ListItem.view.showSerial(serialid)
                    }
                    onRequestWeibo: {

                    }
                }
            }
        ]
        function invokeAuthorView(authorid) {
            //TODO AUTHORVIEW
        }

        onCreationCompleted: {
            co.ajax("GET", endpoint, [], function(b, d) {
                    if (b) {
                        d = JSON.parse(d);
                        if (d.data) {
                            for (var i = 0; i < d.data.essay.length; i ++) {
                                adm.append({
                                        "essay": d.data.essay[i],
                                        "serial": d.data.serial[i],
                                        "question": d.data.question[i]
                                    })
                            }
                        }
                    } else {
                        sst.body = d;
                        sst.show();
                    }
                }, [], false)
        }
        builtInShortcutsEnabled: false
        scrollRole: ScrollRole.None
    }

}