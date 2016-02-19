import bb.cascades 1.4
import cn.anpho 1.0
Container {
    property string tid
    property string ttitle
    property string timgurl
    property string tauthor
    property string tweibo
    property string tintro
    property variant rawdata
    
    signal reqDetail(string tid)
    signal reqWeibo(string weibo)
    
    property string leftImage : "asset:///icon/ic_doctype_generic.png"
    gestureHandlers: TapHandler {
        onTapped: {
            reqDetail(tid)
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
        imageSource: leftImage
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
            text: ttitle
            textStyle.fontSize: FontSize.Large
            
            multiline: true
        }
        Divider {
            visible: tintro.length>0
        }
        Container {
            layout: StackLayout {
                orientation: LayoutOrientation.LeftToRight
            
            }
            WebImageView {
                scalingMethod: ScalingMethod.AspectFit
                url: timgurl
                visible: timgurl.length>0
                preferredWidth: ui.du(7)
                preferredHeight: ui.du(7)
                verticalAlignment: VerticalAlignment.Center
            }
            Label {
                text: tauthor
                textStyle.fontSize: FontSize.XSmall
                layoutProperties: StackLayoutProperties {
                    spaceQuota: 1.0
                }
                visible: text.length>0
                opacity: 0.6
                verticalAlignment: VerticalAlignment.Center
            }
            Label {
                text: tweibo
                visible: text.length>0
                textStyle.fontSize: FontSize.XSmall
                opacity: 0.6
                verticalAlignment: VerticalAlignment.Center
                textStyle.color: ui.palette.primary
                gestureHandlers: TapHandler {
                    onTapped: {
                        if (tweibo.length > 0) {
                            reqWeibo(tweibo)
                        }
                    }
                }
            }
        }
        Label {
            multiline: true
            text: tintro
            visible: text.length>0
        }
    }
}