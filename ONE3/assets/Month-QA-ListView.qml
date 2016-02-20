import bb.cascades 1.4
import cn.anpho 1.0
import bb.system 1.2
Page {
    property NavigationPane nav
    property variant rawdate
    property string api_url: "http://v3.wufazhuce.com:8000/api/question/bymonth/%1"
    onRawdateChanged: {
        console.log(rawdate)
        if (rawdate) {
            var day = Qt.formatDate(rawdate, "yyyy-MM-dd") + " 00:00:00";
            var endp = api_url.arg(encodeURIComponent(day));

            adm.clear();
            co.ajax("GET", endp, [], function(b, d) {
                    if (b) {
                        try {
                            d = JSON.parse(d).data;
                            adm.append(d);
                        } catch (e) {
                            sst.body = JSON.stringify(e);
                            sst.show();
                        }
                    } else {
                        sst.body = d;
                        sst.show();
                    }
                }, [], false)
        }
    }
    titleBar: TitleBar {
        dismissAction: ActionItem {
            title: qsTr("Back")
            onTriggered: {
                nav.pop()
            }
        }
        title: rawdate ? co.genStr(rawdate) : qsTr("Month View")
    }
    attachedObjects: [
        Common {
            id: co
        },
        SystemToast {
            id: sst
        }
    ]
    actionBarVisibility: ChromeVisibility.Compact
    actionBarAutoHideBehavior: ActionBarAutoHideBehavior.HideOnScroll
    Container {
        ListView {
            dataModel: ArrayDataModel {
                id: adm
            }
            onTriggered: {
                var cur = adm.data(indexPath);
                var hpview = Qt.createComponent("Detail-QAView.qml").createObject(nav);
                hpview.nav = nav;
                hpview.qid = cur.question_id;
                nav.push(hpview)
            }
            listItemComponents: [
                ListItemComponent {
                    type: ""
                    ArticleItemTemplate {
                        tid: ListItemData.question_id
                        ttitle: ListItemData.question_title
                        tintro: ListItemData.answer_title
                        leftImage: "asset:///icon/ic_help.png"
                    }
                }
            ]
            bottomPadding: 80.0
            bufferedScrollingEnabled: true
            scrollRole: ScrollRole.Main
        }
    }

}