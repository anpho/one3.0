import bb.cascades 1.4
import cn.anpho 1.0
ScrollView {
    // =====signals=====
    signal requestEssay(string essayid)
    signal requestSerial(string serialid)
    signal requestQA(string qid)
    signal requestAuthorView(string authorid)
    signal requestWeibo(string weiboid)
    // =====ESSAY=====
    property variant essay
    property string essay_title
    property string essay_author
    property string essay_authorid
    property string essay_imgurl
    property string essay_weibo
    property string essay_intro
    property string essay_id
    // =====SERIAL=====
    property variant serial
    property string serial_title
    property string serial_author
    property string serial_authorid
    property string serial_imgurl
    property string serial_intro
    property string serial_id
    // =====Q&A======
    property variant q
    property string q_title
    property string q_intro
    property string q_id

    Container {
        Container {
            gestureHandlers: TapHandler {
                onTapped: {
                    requestEssay(essay_id)
                }
            }
            layout: StackLayout {
                orientation: LayoutOrientation.LeftToRight
            }
            topPadding: 20.0
            leftPadding: 20.0
            rightPadding: 20.0
            bottomPadding: 20.0
            ImageView {
                verticalAlignment: VerticalAlignment.Top
                imageSource: "asset:///icon/ic_doctype_generic.png"
                filterColor: Color.DarkGray
            }
            Container {
                verticalAlignment: VerticalAlignment.Top
                horizontalAlignment: HorizontalAlignment.Fill
                layoutProperties: StackLayoutProperties {
                    spaceQuota: 1.0
                }
                leftPadding: 10.0
                rightPadding: 10.0
                Label {
                    text: essay_title
                    textStyle.fontSize: FontSize.Large

                    multiline: true
                }
                Divider {

                }
                Container {
                    layout: StackLayout {
                        orientation: LayoutOrientation.LeftToRight

                    }
                    WebImageView {
                        scalingMethod: ScalingMethod.AspectFit
                        url: essay_imgurl
                        preferredWidth: ui.du(7)
                        preferredHeight: ui.du(7)
                        verticalAlignment: VerticalAlignment.Center
                    }
                    Label {
                        text: essay_author
                        textStyle.fontSize: FontSize.XSmall
                        layoutProperties: StackLayoutProperties {
                            spaceQuota: 1.0
                        }
                        opacity: 0.6
                        verticalAlignment: VerticalAlignment.Center
                    }
                    Label {
                        text: essay_weibo
                        textStyle.fontSize: FontSize.XSmall
                        opacity: 0.6
                        verticalAlignment: VerticalAlignment.Center
                        textStyle.color: ui.palette.primary
                        gestureHandlers: TapHandler {
                            onTapped: {
                                if (essay_weibo.length > 0) {
                                    requestWeibo(essay_weibo)
                                }
                            }
                        }
                    }
                }
                Label {
                    multiline: true
                    text: essay_intro

                }
            }
        }
        Container {
            gestureHandlers: TapHandler {
                onTapped: {
                    requestSerial(serial_id)
                }
            }
            layout: StackLayout {
                orientation: LayoutOrientation.LeftToRight
            }
            topPadding: 20.0
            leftPadding: 20.0
            rightPadding: 20.0
            bottomPadding: 20.0
            ImageView {
                verticalAlignment: VerticalAlignment.Top
                imageSource: "asset:///icon/ic_notes.png"
                filterColor: Color.DarkGray
            }
            Container {
                verticalAlignment: VerticalAlignment.Top
                horizontalAlignment: HorizontalAlignment.Fill
                layoutProperties: StackLayoutProperties {
                    spaceQuota: 1.0
                }
                leftPadding: 10.0
                rightPadding: 10.0
                Label {
                    text: serial_title
                    textStyle.fontSize: FontSize.Large

                    multiline: true
                }
                Divider {

                }
                Container {
                    layout: StackLayout {
                        orientation: LayoutOrientation.LeftToRight

                    }
                    WebImageView {
                        scalingMethod: ScalingMethod.AspectFit
                        url: serial_imgurl
                        preferredWidth: ui.du(7)
                        preferredHeight: ui.du(7)
                        verticalAlignment: VerticalAlignment.Center
                    }
                    Label {
                        text: serial_author
                        textStyle.fontSize: FontSize.XSmall
                        layoutProperties: StackLayoutProperties {
                            spaceQuota: 1.0
                        }
                        opacity: 0.6
                        verticalAlignment: VerticalAlignment.Center
                    }
                }
                Label {
                    multiline: true
                    text: serial_intro

                }
            }
        }
        Container {
            gestureHandlers: TapHandler {
                onTapped: {
                    requestQA(q_id)
                }
            }
            layout: StackLayout {
                orientation: LayoutOrientation.LeftToRight
            }
            topPadding: 20.0
            leftPadding: 20.0
            rightPadding: 20.0
            bottomPadding: 20.0
            ImageView {
                verticalAlignment: VerticalAlignment.Top
                imageSource: "asset:///icon/ic_help.png"
                filterColor: Color.DarkGray
            }
            Container {
                verticalAlignment: VerticalAlignment.Top
                horizontalAlignment: HorizontalAlignment.Fill
                layoutProperties: StackLayoutProperties {
                    spaceQuota: 1.0
                }
                leftPadding: 10.0
                rightPadding: 10.0
                Label {
                    text: q_title
                    textStyle.fontSize: FontSize.Large

                    multiline: true
                }
                Divider {

                }
                Label {
                    multiline: true
                    text: q_intro
                    opacity: 0.6
                }
            }
        }
    }
}