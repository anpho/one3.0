import bb.cascades 1.4
import bb.device 1.4
import cn.anpho 1.0
Container {
    signal requestMovieView(string movieid)
    gestureHandlers: TapHandler {
        onTapped: {
            requestMovieView(m_id)
        }
    }
    property string m_id
    property string m_title: ""
    property string m_cover
    property string m_score: ""

    onM_coverChanged: {
        if (m_cover.length > 0) {
            movie_cover.url = m_cover
        }
    }
    attachedObjects: [
        DisplayInfo {
            id: di
        }
    ]
    preferredWidth: di.pixelSize.width
    preferredHeight: di.pixelSize.width / 2.3
    layout: DockLayout {

    }
    topMargin: 10.0
    WebImageView {
        scalingMethod: ScalingMethod.AspectFill
        horizontalAlignment: HorizontalAlignment.Fill
        id: movie_cover
    }
    Container {
        verticalAlignment: VerticalAlignment.Bottom
        horizontalAlignment: HorizontalAlignment.Fill
        implicitLayoutAnimationsEnabled: false
        topPadding: 30.0
        bottomPadding: 30.0
        leftPadding: 30.0
        rightPadding: 30.0
        background: Color.create("#15000000")
        Label {
            text: m_title
            textStyle.color: Color.Black
        }
    }
    Label {
        text: m_score
        textStyle.fontSize: FontSize.XLarge
        rotationZ: -20.0
        translationY: -70.0
        horizontalAlignment: HorizontalAlignment.Right
        verticalAlignment: VerticalAlignment.Bottom
        translationX: -70.0
        textStyle.color: Color.Red
        textStyle.rules: [
            FontFaceRule {
                source: "asset:///font/BradleyHandITCTTBold.ttf"
                fontFamily: "bradley"
            }
        ]
        textStyle.fontFamily: "bradley"
        textStyle.fontWeight: FontWeight.W900
    }
}
