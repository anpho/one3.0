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
        ArticleItemTemplate {
            leftImage: "asset:///icon/ic_doctype_generic.png"
            onReqDetail: {
                requestEssay(essay_id)
            }
            onReqWeibo: {
                requestWeibo(weibo)
            }
            tid: essay_id
            tauthor: essay_author
            timgurl: essay_imgurl
            tintro: essay_intro
            ttitle: essay_title
            tweibo: essay_weibo
        }
        ArticleItemTemplate {
            onReqDetail: {
                requestSerial(serial_id)
            }
            tid: serial_id
            leftImage: "asset:///icon/ic_notes.png"
            ttitle: serial_title
            timgurl: serial_imgurl
            tauthor: serial_author
            tintro: serial_intro
        }
        ArticleItemTemplate {
            onReqDetail: {
                requestQA(q_id)
            }
            leftImage: "asset:///icon/ic_help.png"
            ttitle: q_title
            tintro: q_intro
        }

    }
}