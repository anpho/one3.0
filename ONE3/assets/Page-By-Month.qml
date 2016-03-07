import bb.cascades 1.4

Page {
    property variant nav

    titleBar: TitleBar {
        title: qsTr("Browse By Month")
        dismissAction: ActionItem {
            title: qsTr("Back")
            onTriggered: {
                nav.pop()
            }
        }
        scrollBehavior: TitleBarScrollBehavior.NonSticky

    }
    // override this function
    function viewByMonth(rawdate) {
        console.log(rawdate);
        var monthview = Qt.createComponent("Month-HP-ListView.qml").createObject(nav);
        monthview.nav = nav;
        monthview.rawdate = rawdate;
        nav.push(monthview)
    }
    attachedObjects: [
        Common {
            id: co
        }
    ]
    actionBarVisibility: ChromeVisibility.Compact
    actionBarAutoHideBehavior: ActionBarAutoHideBehavior.HideOnScroll
    ListView {
        dataModel: ArrayDataModel {
            id: adm
        }
        listItemComponents: [
            ListItemComponent {
                type: ""
                StandardListItem {
                    title: ListItemData.month
                    property variant rawdate: ListItemData.datetime
                }
            }
        ]
        onTriggered: {
            var selected = adm.data(indexPath);
            viewByMonth(selected.datetime);
        }

        onCreationCompleted: {
            var curdate = new Date();
            curdate.setDate(1);
            adm.clear();
            adm.append({
                    "month": qsTr("Current Month"),
                    "datetime": curdate
                })
            curdate.setMonth(curdate.getMonth() - 1);
            while (curdate.getTime() > 1349049600000) {
                adm.append({
                        "month": co.genStr(curdate),
                        "datetime": curdate
                    })
                curdate.setMonth(curdate.getMonth() - 1);
            }
        }
        bottomPadding: 100.0
    }
}
