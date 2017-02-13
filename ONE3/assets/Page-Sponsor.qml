import bb.cascades 1.4

Page {
    property NavigationPane nav
    titleBar: TitleBar {
        title: qsTr("Sponsors")
        dismissAction: ActionItem {
            title: qsTr("Back")
            onTriggered: {
                nav.pop();
            }
        }

    }
    attachedObjects: [
        Common {
            id: co
        },
        ComponentDefinition {
            id: lbl
            Label {
                textStyle.fontWeight: FontWeight.W100
                textStyle.fontSize: FontSize.Medium
                textStyle.textAlign: TextAlign.Center
                textFormat: TextFormat.Html
                horizontalAlignment: HorizontalAlignment.Fill
                textStyle.fontStyle: FontStyle.Default
                textFit.mode: LabelTextFitMode.Standard
                multiline: true
            }
        }
    ]
    onCreationCompleted: {
        sponsors.removeAll();
        co.ajax("GET", "https://anpho.github.io/conf/one/one3.spon", [], function(b, d) {
                if (b) {
                    try {
                        d = JSON.parse(d).data;
                        for (var i = 0; i < d.length; i ++) {
                            var cur = lbl.createObject()
                            cur.text = "%1 (%2)".arg(d[i].name).arg(d[i].via)
                            sponsors.add(cur)
                        }
                    } catch (e) {

                    }
                }
            }, [], false, false);
    }
    actionBarAutoHideBehavior: ActionBarAutoHideBehavior.HideOnScroll
    actionBarVisibility: ChromeVisibility.Compact
    ScrollView {
        Container {
            Header {
                title: qsTr("Thanks!")
            }
            Container {
                topPadding: 20.0
                leftPadding: 20.0
                bottomPadding: 20.0
                rightPadding: 20.0
                horizontalAlignment: HorizontalAlignment.Fill
                Label {
                    text: qsTr("I've received many donations during development, thank you all for your support ! ")
                    multiline: true
                    textStyle.fontWeight: FontWeight.W100
                    textStyle.textAlign: TextAlign.Center
                    textFit.mode: LabelTextFitMode.FitToBounds
                    horizontalAlignment: HorizontalAlignment.Fill
                }
                Divider {

                }
                Container {
                    id: sponsors
                    horizontalAlignment: HorizontalAlignment.Fill
                    Label {
                        text: qsTr("Loading")
                        horizontalAlignment: HorizontalAlignment.Fill
                        textStyle.textAlign: TextAlign.Center
                    }
                }
            }
        }
    }
}
