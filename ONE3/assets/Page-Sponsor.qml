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
        var data = "[{\"name\":\"<a href='http://dzsf.taobao.com'>斗战胜佛爱黑莓</a>\",\"via\":\"支付宝\"},{\"name\":\"国升\",\"via\":\"支付宝\"},{\"name\":\"foxtear\",\"via\":\"淘宝\"},{\"name\":\"<a href='http://dtblackberry.taobao.com/'>东通黑莓</a>\",\"via\":\"微信\"},{\"name\":\"<a href='http://www.freemanz.me:88/'>西子浪人</a>\",\"via\":\"支付宝\"},{\"name\":\"<a href='http://weibo.com/u/2618102547'>果果Song</a>\",\"via\":\"支付宝\"},{\"name\":\"chenghao199086\",\"via\":\"淘宝\"},{\"name\":\"边缘客\",\"via\":\"微信\"},{\"name\":\"恩康\",\"via\":\"支付宝\"},{\"name\":\"大细菌\",\"via\":\"支付宝\"},{\"name\":\"梁世博\",\"via\":\"支付宝\"},{\"name\":\"我家牛肉汤\",\"via\":\"支付宝\"},{\"name\":\"佰圓_佰圓\",\"via\":\"支付宝\"},{\"name\":\"<a href='http://www.wangcw.cn'>rubygreat9</a>\",\"via\":\"淘宝\"},{\"name\":\"子祁\",\"via\":\"支付宝\"},{\"name\":\"CHAY\",\"via\":\"支付宝\"},{\"name\":\"TRESS\",\"via\":\"支付宝\"},{\"name\":\"杜斌\",\"via\":\"支付宝\"},{\"name\":\"小丁\",\"via\":\"支付宝\"},{\"name\":\"LEIYU\",\"via\":\"支付宝\"},{\"name\":\"suoshijie\",\"via\":\"淘宝\"},{\"name\":\"boydancing\",\"via\":\"淘宝\"},{\"name\":\"王鹏飞kingbed22\",\"via\":\"淘宝\"},{\"name\":\"sjmpengpeng88\",\"via\":\"淘宝\"},{\"name\":\"射雕英雄5\",\"via\":\"淘宝\"},{\"name\":\"karon1147\",\"via\":\"淘宝\"},{\"name\":\"staa7\",\"via\":\"淘宝\"},{\"name\":\"IA·N·SHAW！\",\"via\":\"微信\"},{\"name\":\"BerryMarlin\",\"via\":\"支付宝\"},{\"name\":\"ID12345\",\"via\":\"支付宝\"},{\"name\":\"桂泉\",\"via\":\"支付宝\"},{\"name\":\"李洋\",\"via\":\"支付宝\"},{\"name\":\"立旭\",\"via\":\"支付宝\"},{\"name\":\"猛老板\",\"via\":\"支付宝\"},{\"name\":\"伟伟\",\"via\":\"支付宝\"},{\"name\":\"晓乐\",\"via\":\"支付宝\"},{\"name\":\"霂霂狐\",\"via\":\"支付宝\"},{\"name\":\"BERRY\",\"via\":\"支付宝\"},{\"name\":\"asusgyy\",\"via\":\"淘宝\"},{\"name\":\"曦窗汀雨\",\"via\":\"淘宝\"},{\"name\":\"眼皮\",\"via\":\"支付宝\"},{\"name\":\"LINGJIEHUANG\",\"via\":\"支付宝\"},{\"name\":\"登杰\",\"via\":\"支付宝\"},{\"name\":\"那也不如阿扎尔\",\"via\":\"淘宝\"},{\"name\":\"cristianojack\",\"via\":\"淘宝\"},{\"name\":\"瓜地瓜地\",\"via\":\"淘宝\"},{\"name\":\"fd范大\",\"via\":\"淘宝\"},{\"name\":\"老土摇\",\"via\":\"淘宝\"},{\"name\":\"刘小傻\",\"via\":\"支付宝\"},{\"name\":\"明\",\"via\":\"支付宝\"},{\"name\":\"彬\",\"via\":\"支付宝\"},{\"name\":\"ANDY\",\"via\":\"支付宝\"},{\"name\":\"买板专用\",\"via\":\"淘宝\"},{\"name\":\"tb94293129\",\"via\":\"淘宝\"},{\"name\":\"linshis0\",\"via\":\"淘宝\"},{\"name\":\"qqz12345\",\"via\":\"淘宝\"},{\"name\":\"s邵河\",\"via\":\"淘宝\"},{\"name\":\"huangchenghaoo\",\"via\":\"淘宝\"},{\"name\":\"tb5294417_99\",\"via\":\"淘宝\"}]";
        var d = JSON.parse(data);
        for (var i = 0; i < d.length; i ++) {
            var cur = lbl.createObject()
            cur.text = "%1 (%2)".arg(d[i].name).arg(d[i].via)
            sponsors.add(cur)
        }
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
