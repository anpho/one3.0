import bb.cascades 1.4

Page {
    //版权页，直接显示官网内容
    actionBarAutoHideBehavior: ActionBarAutoHideBehavior.HideOnScroll
    function setActive() {
        about_scrollview.scrollRole = ScrollRole.Main
    }
    property variant nav
    
    actions: [
        ActionItem {
            title: qsTr("Official")
            imageSource: "asset:///icon/ic_open_link.png"
            ActionBar.placement: ActionBarPlacement.OnBar
            onTriggered: {
                var newpage = Qt.createComponent("WebBrowser.qml").createObject(nav);
                newpage.uri = "http://m.wufazhuce.com/about?from=ONEApp"
                nav.push(newpage)
            }
        }
    ]
    ScrollView {
        id: about_scrollview
        horizontalAlignment: HorizontalAlignment.Fill
        Container {

        }
    }
}
