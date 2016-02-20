import bb.cascades 1.4
import bb.system 1.2
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

    }
    // override this function
    function viewEssayByMonth(rawdate) {
        console.log(rawdate);
        var monthview = Qt.createComponent("Month-Essay-ListView.qml").createObject(nav);
        monthview.nav = nav;
        monthview.rawdate = rawdate;
        nav.push(monthview)
    }
    function viewQAByMonth(rawdate) {
        console.log(rawdate);
        var monthview = Qt.createComponent("Month-QA-ListView.qml").createObject(nav);
        monthview.nav = nav;
        monthview.rawdate = rawdate;
        nav.push(monthview)
    }
    function viewSerialByMonth(rawdate) {
        console.log(rawdate);
        var monthview = Qt.createComponent("Month-Serials-ListView.qml").createObject(nav);
        monthview.nav = nav;
        monthview.rawdate = rawdate;
        nav.push(monthview)
    }
    attachedObjects: [
        Common {
            id: co
        },
        SystemListDialog {
            id: sld
            property variant rawdate
            title: "Catagory"
            selectionIndicator: ListSelectionIndicator.Highlight
            dismissOnSelection: true
            body: "Choose a catagory to browse"
            onFinished: {
                var selected = parseInt(selectedIndices);
                console.log(selected)
                // 0 : Essay
                // 1 : QA
                // 2 : Serial
                switch (selected) {
                    case 0:
                        viewEssayByMonth(rawdate)
                        break;
                    case 1:
                        viewQAByMonth(rawdate)
                        break;
                    case 2:
                        viewSerialByMonth(rawdate)
                        break;
                }
            }
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
            sld.rawdate = selected.datetime;
            if (selected.datetime.getFullYear() >= 2016) {
                sld.clearList();
                sld.appendItem(qsTr("Essay"))
                sld.appendItem(qsTr("Q&A"))
                sld.appendItem(qsTr("Serials"))
            } else {
                sld.clearList();
                sld.appendItem(qsTr("Essay"))
                sld.appendItem(qsTr("Q&A"))
            }
            sld.show();
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
