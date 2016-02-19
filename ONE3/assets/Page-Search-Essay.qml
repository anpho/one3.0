import bb.cascades 1.4

Page {
    //    property alias query: titlebar.kindProperties.textField.text
    function setActive() {
        listview.scrollRole = ScrollRole.Main
    }
    property variant nav
    titleBar: TitleBar {
        id: titlebar
        kind: TitleBarKind.TextField
        kindProperties: TextFieldTitleBarKindProperties {
            textField.input.onSubmitted: {
                search()
            }
            textField.hintText: qsTr("Search in Articles")
            textField.input.keyLayout: KeyLayout.Text
            textField.input.submitKey: SubmitKey.Search
            textField.input.submitKeyFocusBehavior: SubmitKeyFocusBehavior.Lose
            textField.inputMode: TextFieldInputMode.Text
        }
    }
    function search() {
        var q = titlebar.kindProperties.textField.text;
        search_articles(q);
    }
    onCreationCompleted: {
        titlebar.kindProperties.textField.requestFocus()
    }
    property string search_articles_url: "http://v3.wufazhuce.com:8000/api/search/reading/%1"
    function search_articles(q) {
        var endp = search_articles_url.arg(encodeURIComponent(q));
        act_pic.running = true
        co.ajax("GET", endp, [], function(b, d) {
                act_pic.running = false
                if (b) {
                    try {
                        var d = JSON.parse(d).data;
                        adm.clear()
                        adm.append(d);
                    } catch (e) {
                        console.log(e)
                    }
                } else {
                    console.log(d)
                }
            }, [])
    }
    function showEssay(hid) {
        var hpview = Qt.createComponent("Detail-EssayView.qml").createObject(nav);
        hpview.nav = nav;

        nav.push(hpview)
    }
    function showSerial(sid) {
        var hpview = Qt.createComponent("Detail-SerialView.qml").createObject(nav);
        hpview.nav = nav;

        nav.push(hpview)
    }
    function showQA(qid) {
        var hpview = Qt.createComponent("Detail-QAView.qml").createObject(nav);
        hpview.nav = nav;

        nav.push(hpview)
    }
    attachedObjects: [
        Common {
            id: co
        }
    ]
    actionBarAutoHideBehavior: ActionBarAutoHideBehavior.HideOnScroll
    actionBarVisibility: ChromeVisibility.Compact
    Container {
        Header {
            id: header_art
            title: qsTr("Articles")
        }
        ActivityIndicator {
            horizontalAlignment: HorizontalAlignment.Center
            id: act_pic
        }
        Label {
            horizontalAlignment: HorizontalAlignment.Fill
            text: qsTr("Nothing Here")
            textStyle.textAlign: TextAlign.Center
            id: label_art
        }
        ListView {
            id: listview
            dataModel: ArrayDataModel {
                id: adm
                onItemsChanged: {
                    header_art.subtitle = adm.size() + qsTr(" results")
                    label_art.visible = adm.isEmpty();
                }
            }
            function itemType(data, indexPath) {
                return data.type;
            }
            scrollIndicatorMode: ScrollIndicatorMode.ProportionalBar
            snapMode: SnapMode.None
            horizontalAlignment: HorizontalAlignment.Fill
            implicitLayoutAnimationsEnabled: false
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
                    type: "essay"
                    ArticleItemTemplate {
                        id: ate
                        tid: ListItemData.id
                        ttitle: ListItemData.title
                        onReqDetail: {
                            ate.ListItem.view.showEssay(ListItemData.id)
                        }
                    }
                },
                ListItemComponent {
                    type: "question"
                    ArticleItemTemplate {
                        id: atq
                        tid: ListItemData.id
                        ttitle: ListItemData.title
                        leftImage: "asset:///icon/ic_help.png"
                        onReqDetail: {
                            atq.ListItem.view.showQA(ListItemData.id);
                        }
                    }
                },
                ListItemComponent {
                    type: "serialcontent"
                    ArticleItemTemplate {
                        id: ats
                        tid: ListItemData.id
                        ttitle: ListItemData.title
                        leftImage: "asset:///icon/ic_notes.png"
                        onReqDetail: {
                            ats.ListItem.view.showSerial(ListItemData.id)
                        }
                    }
                }
            ]
        }
    }
}
