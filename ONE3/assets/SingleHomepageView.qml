import bb.cascades 1.4
import cn.anpho 1.0

ScrollView {
    signal requestImageView(string src)
    signal requestAuthorView(string authorid)
    signal requestCopyText(string text)
    signal requestShareText(string text)

    function setActive() {
        scrollRole = ScrollRole.Main
    }
    //用于显示一幅题图
    property string endpoint: "http://v3.wufazhuce.com:8000/api/hp/detail/%1"
    property string errmsg: qsTr("Error : %1")

    property variant nest
    property string hpid
    property string hid

    onHidChanged: {
        if (hid.trim().length > 0)
            loadByID(hid);
    }
    function loadByID(_id) {
        hpid = _id;
        var endp = endpoint.arg(hpid);
        co.ajax("GET", endp, [], function(b, d) {
                if (b) {
                    d = JSON.parse(d);
                    if (d.data) {
                        nest = d.data;
                        imageurl = nest.hp_img_original_url;
                        vol = nest.hp_title;
                        author = nest.hp_author;
                        hpcontent = nest.hp_content;
                        datestring = nest.hp_makettime;
                        ipadimage = co.valueOrEmpty(nest.ipad_url);
                        authorid = nest.author_id;
                    }
                } else {
                    hpcontent = errmsg.arg(d)
                }
            }, [], false, true);
    }
    property string imageurl
    property string vol
    property string author
    property string authorid
    property string hpcontent
    property string datestring
    property string ipadimage
    onImageurlChanged: {
        //设置题图
        if (imageurl.trim().length > 0) {
            webimage.url = imageurl
        }
    }
    attachedObjects: [
        Common {
            id: co
        }
    ]
    id: hpscrollview
    Container {
        horizontalAlignment: HorizontalAlignment.Fill
        leftPadding: 20.0
        rightPadding: 20.0
        topPadding: 20.0
        bottomPadding: 100.0
        implicitLayoutAnimationsEnabled: false
        WebImageView {
            id: webimage
            horizontalAlignment: HorizontalAlignment.Fill
            scalingMethod: ScalingMethod.AspectFit
            implicitLayoutAnimationsEnabled: false
            gestureHandlers: [
                TapHandler {
                    onTapped: {
                        var bigimage = webimage.getCachedPath();
                        requestImageView(bigimage);
                    }
                }
            ]
        }
        Container {
            layout: StackLayout {
                orientation: LayoutOrientation.LeftToRight

            }
            implicitLayoutAnimationsEnabled: false
            Label {
                textStyle.fontSize: FontSize.XSmall
                textStyle.fontWeight: FontWeight.W100
                opacity: 0.6
                text: vol
                textStyle.textAlign: TextAlign.Left
                layoutProperties: StackLayoutProperties {
                    spaceQuota: 1.0
                }
                implicitLayoutAnimationsEnabled: false
            }
            Label {
                textStyle.fontSize: FontSize.XSmall
                textStyle.fontWeight: FontWeight.W100
                opacity: 0.6
                text: author
                textStyle.textAlign: TextAlign.Right
                layoutProperties: StackLayoutProperties {
                    spaceQuota: 1.0
                }
                gestureHandlers: TapHandler {
                    onTapped: {
                        if (authorid != "-1") {
                            requestAuthorView(authorid)
                        }
                    }
                }
                implicitLayoutAnimationsEnabled: false
            }
        }
        Label {
            multiline: true
            text: hpcontent
            topMargin: 50.0
            bottomMargin: 50.0
            implicitLayoutAnimationsEnabled: false
            contextActions: [
                ActionSet {
                    title: qsTr("Share")
                    actions: [
                        ActionItem {
                            title: qsTr("Copy")
                            imageSource: "asset:///icon/ic_copy.png"
                            onTriggered: {
                                requestCopyText(hpcontent)
                            }
                            accessibility.name: "Copy"
                        },
                        ActionItem {
                            title: qsTr("Share")
                            imageSource: "asset:///icon/ic_share.png"
                            accessibility.name: "Share"
                            onTriggered: {
                                requestShareText(hpcontent)
                            }
                        }
                    ]
                }
            ]
            textStyle.fontSize: FontSize.Medium
        }
        Label {
            horizontalAlignment: HorizontalAlignment.Fill
            textStyle.textAlign: TextAlign.Right
            text: datestring
            textStyle.fontSize: FontSize.XSmall
            opacity: 0.6
            implicitLayoutAnimationsEnabled: false
        }
    }
}
