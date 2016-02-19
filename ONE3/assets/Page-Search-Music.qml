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
            textField.hintText: qsTr("Search in Musics")
            textField.input.keyLayout: KeyLayout.Text
            textField.input.submitKey: SubmitKey.Search
            textField.input.submitKeyFocusBehavior: SubmitKeyFocusBehavior.Lose
            textField.inputMode: TextFieldInputMode.Text
        }
    }
    function search() {
        var q = titlebar.kindProperties.textField.text;
        search_music(q);
    }
    onCreationCompleted: {
        titlebar.kindProperties.textField.requestFocus()
    }
    property string search_music_url: "http://v3.wufazhuce.com:8000/api/search/music/%1"
    function search_music(q) {
        var endp = search_music_url.arg(encodeURIComponent(q));
        act_music.running = true
        co.ajax("GET", endp, [], function(b, d) {
                act_music.running = false
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
    function showMusic(hid) {
        var hpview = Qt.createComponent("Detail-MusicView.qml").createObject(nav);
        hpview.nav = nav;
        hpview.music_id = hid;
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
            id: header_music
            title: qsTr("Musics")
        }
        ActivityIndicator {
            horizontalAlignment: HorizontalAlignment.Center
            id: act_music
        }
        Label {
            horizontalAlignment: HorizontalAlignment.Fill
            text: qsTr("Nothing Here")
            textStyle.textAlign: TextAlign.Center
            id: label_music
        }
        ListView {
            id: listview
            dataModel: ArrayDataModel {
                id: adm
                onItemsChanged: {
                    header_music.subtitle = adm.size() + qsTr(" results")
                    label_music.visible = adm.isEmpty();
                }
            }
            scrollIndicatorMode: ScrollIndicatorMode.ProportionalBar
            snapMode: SnapMode.None
            horizontalAlignment: HorizontalAlignment.Fill
            implicitLayoutAnimationsEnabled: false
            function requestView(hid) {
                showMusic(hid)
            }
            listItemComponents: [
                ListItemComponent {
                    type: ""
                    SearchPictureTemplate {
                        id: spt
                        onRequestView: {
                            spt.ListItem.view.requestView(hid)
                        }
                        hid: ListItemData.id
                        image_url: ListItemData.cover
                        author: ListItemData.title
                        hpcontent: ListItemData.author.user_name
                    }
                }
            ]
        }
    }
}
