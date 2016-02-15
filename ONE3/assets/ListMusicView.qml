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
                        }
                    }
                }
                Label {
                    text: qsTr("Music")
                    textStyle.fontSize: FontSize.Large
                    verticalAlignment: VerticalAlignment.Center
                    layoutProperties: StackLayoutProperties {
                        spaceQuota: 1.0

                    }
                    horizontalAlignment: HorizontalAlignment.Fill
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
        id: mlistview
        property string endpoint: "http://v3.wufazhuce.com:8000/api/music/idlist/0"
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
                    var page = adm.data(firstVisibleItem)
                    if (page && page.setActive) {
                        page.setActive();
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
        verticalAlignment: VerticalAlignment.Fill
        property int width: di.pixelSize.width
        listItemComponents: [
            ListItemComponent {
                type: ""
                SingleMusicView {
                    music_id: ListItemData.id
                    id: shv
                    verticalAlignment: VerticalAlignment.Fill
                    preferredWidth: shv.ListItem.view.width
                    onRequestWebView: {
                        shv.ListItem.view.showweb(uri)
                    }
                }
            }
        ]
        function showweb(url) {
            var webpage = Qt.createComponent("WebBrowser.qml").createObject(nav);
            webpage.nav = nav
            webpage.uri = url;
            nav.push(webpage)
        }
        function html2text(story) {
            return _app.html2text(story);
        }
        onCreationCompleted: {
            co.ajax("GET", endpoint, [], function(b, d) {
                    if (b) {
                        d = JSON.parse(d);
                        if (d.data) {
                            for (var i = 0; i < d.data.length; i ++) {
                                adm.append({
                                        "id": d.data[i]
                                    })
                            }
                        }
                    } else {
                        sst.body = d;
                        sst.show();
                    }
                }, [], false)
        }
        scrollRole: ScrollRole.None
        builtInShortcutsEnabled: false
    }

}