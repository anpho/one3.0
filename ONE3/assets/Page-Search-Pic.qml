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
            textField.hintText: qsTr("Search in Pictures")
            textField.input.keyLayout: KeyLayout.Text
            textField.input.submitKey: SubmitKey.Search
            textField.input.submitKeyFocusBehavior: SubmitKeyFocusBehavior.Lose
            textField.inputMode: TextFieldInputMode.Text
        }
    }
    function search() {
        var q = titlebar.kindProperties.textField.text;
        search_pic(q);
    }
    onCreationCompleted: {
        titlebar.kindProperties.textField.requestFocus()
    }
    property string search_pic_url: "http://v3.wufazhuce.com:8000/api/search/hp/%1"
    property variant search_pic_data: []
    function search_pic(q) {
        var endp = search_pic_url.arg(encodeURIComponent(q));
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
    function showHP(hid) {
        var hpview = Qt.createComponent("Detail-HPView.qml").createObject(nav);
        hpview.nav = nav;
        hpview.hid = hid;
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
            id: header_pic
            title: qsTr("Pictures")
        }
        ActivityIndicator {
            horizontalAlignment: HorizontalAlignment.Center
            id: act_pic
        }
        Label {
            horizontalAlignment: HorizontalAlignment.Fill
            text: qsTr("Nothing Here")
            textStyle.textAlign: TextAlign.Center
            id: label_pic
        }
        ListView {
            id: listview
            dataModel: ArrayDataModel {
                id: adm
                onItemsChanged: {
                    header_pic.subtitle = adm.size() + qsTr(" results")
                    label_pic.visible = adm.isEmpty();
                }
            }
            scrollIndicatorMode: ScrollIndicatorMode.ProportionalBar
            snapMode: SnapMode.None
            horizontalAlignment: HorizontalAlignment.Fill
            implicitLayoutAnimationsEnabled: false
            function requestView(hid) {
                showHP(hid)
            }
            listItemComponents: [
                ListItemComponent {
                    type: ""
                    SearchPictureTemplate {
                        id: spt
                        onRequestView: {
                            spt.ListItem.view.requestView(hid)
                        }
                        hid: ListItemData.hpcontent_id
                        image_url: ListItemData.hp_img_url
                        author: ListItemData.hp_author
                        hpcontent: ListItemData.hp_content
                    }
                }
            ]
        }
    }
}
