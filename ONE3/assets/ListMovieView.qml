import bb.cascades 1.4
import bb.system 1.2
Page {
    property variant nav

    // API
    property string endpoint: "http://v3.wufazhuce.com:8000/api/movie/list/0"
    attachedObjects: [
        Common {
            id: co
        },
        SystemToast {
            id: sst
        }
    ]
    actionBarAutoHideBehavior: ActionBarAutoHideBehavior.HideOnScroll
    actionBarVisibility: ChromeVisibility.Compact
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
                    visible: true
                    opacity: 0.0
                }
                Label {
                    text: qsTr("Movie")
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
                            var searchPanel = Qt.createComponent("Page-Search-Movie.qml").createObject(nav);
                            searchPanel.nav = nav;
                            nav.push(searchPanel)
                        }
                    }
                }
            }

        }
        scrollBehavior: TitleBarScrollBehavior.Sticky

    }
    ListView {
        dataModel: ArrayDataModel {
            id: adm
        }
        scrollIndicatorMode: ScrollIndicatorMode.ProportionalBar
        snapMode: SnapMode.LeadingEdge
        bufferedScrollingEnabled: true
        horizontalAlignment: HorizontalAlignment.Fill
        implicitLayoutAnimationsEnabled: false
        function showMovie(movieID) {
            var movpage = Qt.createComponent("Detail-MovieView.qml").createObject(nav);
            movpage.mid = movieID;
            movpage.nav = nav;
            nav.push(movpage)
        }
        listItemComponents: [
            ListItemComponent {
                type: ""
                SingleMovieEntryView {
                    id: shv
                    onRequestMovieView: {
                        shv.ListItem.view.showMovie(movieid)
                    }
                    m_cover: ListItemData.cover
                    m_id: ListItemData.id
                    m_score: co.valueOrEmpty(ListItemData.score)
                    m_title: ListItemData.title
                }

            }
        ]
        builtInShortcutsEnabled: true
        scrollRole: ScrollRole.Main
        onCreationCompleted: {
            co.ajax("GET", endpoint, [], function(b, d) {
                    if (b) {
                        try {
                            d = JSON.parse(d).data;
                            adm.append(d)
                        } catch (e) {
                            sst.body = qsTr("Error : %1").arg(e)
                            console.log(sst.body)
                            sst.show()
                        }
                    } else {
                        sst.body = qsTr("Error : %1").arg(d)
                        console.log(sst.body)
                        sst.show()
                    }
                }, [], false)
        }
    }
}
