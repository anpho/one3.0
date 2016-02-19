import bb.cascades 1.4
import cn.anpho 1.0

Container {
    signal requestView(string hid)
    gestureHandlers: TapHandler {
        onTapped: {
            requestView(hid)
        }
    }
    property string hid
    property string image_url
    onImage_urlChanged: {
        if (image_url.length > 0) {
            imageview.url = image_url
        }
    }
    property string author
    property string hpcontent

    layout: StackLayout {
        orientation: LayoutOrientation.LeftToRight
    }
    leftPadding: 10.0
    topPadding: 10.0
    bottomPadding: 10.0
    rightPadding: 10.0
    WebImageView {
        id: imageview
        scalingMethod: ScalingMethod.AspectFill
        preferredHeight: ui.du(12)
        preferredWidth: ui.du(12)
        verticalAlignment: VerticalAlignment.Top
        horizontalAlignment: HorizontalAlignment.Left
    }
    Container {
        leftPadding: 20.0
        rightPadding: 10.0
        verticalAlignment: VerticalAlignment.Top
        horizontalAlignment: HorizontalAlignment.Fill
        layoutProperties: StackLayoutProperties {
            spaceQuota: 1.0
        }
        Label {
            text: author
            textStyle.fontSize: FontSize.Medium
        }
        Label {
            multiline: true
            text: hpcontent
            textStyle.fontSize: FontSize.Small
            autoSize.maxLineCount: 2
        }
    }
}
