import bb.cascades 1.4
import cn.anpho 1.0
import bb.multimedia 1.4
import bb.system 1.2
import bb.device 1.3
Page {
    property variant nav

    property string mid
    property string endpoint: "http://v3.wufazhuce.com:8000/api/movie/detail/%1"
    property string story_endpoint: "http://v3.wufazhuce.com:8000/api/movie/%1/story/1/0"
    onMidChanged: {
        if (mid.trim().length > 0) {
            load();
        }
    }

    property string cover //detailcover
    onCoverChanged: {
        if (cover.length > 0) {
            coverimage.url = cover
        }
    }
    id: pageroot
    property string video_url //video
    property string title // title
    property string info // info
    property string officialstory // officialstory
    property string charge_edt // charge_edt
    property variant photos //photo[]
    property string score // score

    // ajax story
    property string s_title
    property string s_author
    property string s_content

    titleBar: TitleBar {
        title: pageroot.title
        dismissAction: ActionItem {
            onTriggered: {
                nav.pop();
            }
            title: qsTr("Back")
        }

    }
    attachedObjects: [
        Common {
            id: co
        },
        SystemToast {
            id: sst
        },
        DisplayInfo {
            id: di
        }
    ]
    actionBarVisibility: ChromeVisibility.Compact
    actionBarAutoHideBehavior: ActionBarAutoHideBehavior.HideOnScroll
    function showvideo(vurl) {
        _app.invokeVideo(title, vurl)
    }
    function load() {
        var endp = endpoint.arg(mid);
        co.ajax("GET", endp, [], function(b, d) {
                if (b) {
                    try {
                        d = JSON.parse(d).data;
                        title = d.title
                        cover = d.detailcover
                        video_url = co.valueOrEmpty(d.video)
                        score = co.valueOrEmpty(d.score)
                        info = co.valueOrEmpty(d.info)
                        officialstory = co.valueOrEmpty(d.officialstory)
                        charge_edt = co.valueOrEmpty(d.charge_edt)
                        photos = d.photo ? d.photo : []
                    } catch (e) {
                        sst.body = qsTr("Error: %1").arg(JSON.stringify(e))
                        console.log(sst.body)
                        sst.show();
                    }

                } else {
                    sst.body = qsTr("Error : %1").arg(d)
                    console.log(sst.body)
                    sst.show();
                }
                var sendp = story_endpoint.arg(mid);
                co.ajax("GET", sendp, [], function(b, d) {
                        if (b) {
                            try {
                                d = JSON.parse(d);
                                d = d.data.data[0];
                                s_author = d.user.user_name
                                s_content = d.content
                                s_title = d.title
                            } catch (e) {
                                sst.body = qsTr("Error: %1").arg(JSON.stringify(e))
                                sst.show();
                            }

                        } else {
                            sst.body = qsTr("Error : %1").arg(d)
                            sst.show();
                        }
                    }, [], false)
            }, [], false)

    }
    ScrollView {
        Container {
            horizontalAlignment: HorizontalAlignment.Fill
            WebImageView {
                horizontalAlignment: HorizontalAlignment.Fill
                scalingMethod: ScalingMethod.AspectFill
                implicitLayoutAnimationsEnabled: false
                id: coverimage
                preferredWidth: di.pixelSize.width
                preferredHeight: di.pixelSize.width / 2.3
            }
            Container {
                layout: StackLayout {
                    orientation: LayoutOrientation.LeftToRight

                }
                background: Color.create("#57bfbfbf")
                topPadding: 20.0
                bottomPadding: 20.0
                leftPadding: 20.0
                rightPadding: 20.0
                horizontalAlignment: HorizontalAlignment.Fill
                ImageView {
                    preferredHeight: ui.du(4)
                    preferredWidth: ui.du(4)
                    imageSource: "asset:///res/movie_play.png"
                    scalingMethod: ScalingMethod.AspectFit
                    filterColor: Color.create("#ff008dff")
                    verticalAlignment: VerticalAlignment.Center
                    gestureHandlers: TapHandler {
                        onTapped: {
                            showvideo(video_url);
                        }
                    }
                    visible: video_url.length>0
                }
                Label {
                    text: qsTr("Trailer")
                    verticalAlignment: VerticalAlignment.Center
                    layoutProperties: StackLayoutProperties {
                        spaceQuota: 1.0
                    }
                    visible: video_url.length>0
                    gestureHandlers: TapHandler {
                        onTapped: {
                            showvideo(video_url);
                        }
                    }
                }
                Label {
                    text: score
                    textStyle.fontSize: FontSize.Medium
                    visible: score.length>0
                    textStyle.fontWeight: FontWeight.Default
                    textStyle.textAlign: TextAlign.Center
                    textStyle.color: Color.Red
                    verticalAlignment: VerticalAlignment.Center
                    textStyle.rules: [
                        FontFaceRule {
                            source: "asset:///font/BradleyHandITCTTBold.ttf"
                            fontFamily: "bradley"
                        }
                    ]
                    textStyle.fontFamily: "bradley"
                }
            }
            Header {
                title: qsTr("Intro")
                visible: officialstory.length>0
            }
            Container {
                visible: officialstory.length>0
                leftPadding: 20.0
                topPadding: 20.0
                bottomPadding: 20.0
                rightPadding: 20.0
                Label {
                    text: officialstory
                    multiline: true
                    textStyle.fontSize: FontSize.Medium
                    textFit.mode: LabelTextFitMode.FitToBounds
                }
            }
            Header {
                title: qsTr("Staff")
                visible: info.length>0
            }
            Container {
                visible: info.length>0
                leftPadding: 20.0
                topPadding: 20.0
                bottomPadding: 20.0
                rightPadding: 20.0
                Label {
                    text: info
                    multiline: true
                    textStyle.fontSize: FontSize.Medium
                    textFit.mode: LabelTextFitMode.FitToBounds
                    textFormat: TextFormat.Html
                }
            }
            Header {
                title: qsTr("Story")
                subtitle: s_author
                visible: s_author && s_author.length > 0
            }
            Container {
                leftPadding: 20.0
                topPadding: 20.0
                bottomPadding: 20.0
                rightPadding: 20.0
                Label {
                    text: s_title
                    multiline: true
                    textFormat: TextFormat.Plain
                    textStyle.fontSize: FontSize.Large
                }
                Label {
                    text: s_content
                    multiline: true
                    textStyle.fontSize: FontSize.Medium
                    textFit.mode: LabelTextFitMode.FitToBounds
                    textFormat: TextFormat.Html
                }
                Label {
                    text: charge_edt
                    textStyle.fontSize: FontSize.XSmall
                    textFit.mode: LabelTextFitMode.FitToBounds
                    textFormat: TextFormat.Html
                    textStyle.fontStyle: FontStyle.Italic
                    textStyle.textAlign: TextAlign.Right
                    horizontalAlignment: HorizontalAlignment.Fill
                }
            }
        }
    }
}