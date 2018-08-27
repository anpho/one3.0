import bb.cascades 1.4
import cn.anpho 1.0
import bb.system 1.2
Page {
    property NavigationPane nav
    property variant rawdate
    property string hpmonthview_url: "http://v3.wufazhuce.com:8000/api/hp/bymonth/%1"
    onRawdateChanged: {
        console.log(rawdate)
        if (rawdate) {
            var day = Qt.formatDate(rawdate, "yyyy-MM-dd") + " 00:00:00";
            console.log(day)
            var endp = hpmonthview_url.arg(encodeURIComponent(day));
            adm.clear();
            var d = _app.fetch(endp);
            var b = d.length > 0;
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
            gestureHandlers: PinchHandler {
                onPinchEnded: {
                    if (event.pinchRatio > 1) {
                        if (gll.columnCount < 3) {
                            return;
                        } else {
                            gll.columnCount --;
                        }
                    } else {
                        if (gll.columnCount > 4) {
                            return;
                        } else {
                            gll.columnCount ++;
                        }
                    }
                    _app.setv("columns", gll.columnCount)
                }
            }
            layout: GridListLayout {
                id: gll
                columnCount: parseInt(_app.getv("columns", "2"))
            }
            dataModel: ArrayDataModel {
                id: adm
            }
            onTriggered: {
                var cur = adm.data(indexPath);
                var hpview = Qt.createComponent("Detail-HPView.qml").createObject(nav);
                hpview.nav = nav;
                hpview.hid = cur.hpcontent_id;
                nav.push(hpview)
            }
            listItemComponents: [
                ListItemComponent {
                    type: ""
                    WebImageView {
                        scalingMethod: ScalingMethod.AspectFill
                        property string hpid: ListItemData.hpcontent_id
                        url: ListItemData.hp_img_url
                    }
                }
            ]
            bottomPadding: 80.0
            bufferedScrollingEnabled: true
            scrollRole: ScrollRole.Main
        }
    }

}