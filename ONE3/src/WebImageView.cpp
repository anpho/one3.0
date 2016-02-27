/*
 * This file is forked from https://github.com/RodgerLeblanc/WebImageView , the original repo is too big so I created
 * this tiny repo to save mine.
 * Please keep this comment paragraph.
 *
 * Merrick Zhang ( anphorea@gmail.com ) 2015.5.27
 */
#include "WebImageView.h"
#include <QNetworkReply>
#include <bb/cascades/Image>
#include <QCryptographicHash>
#include <QFile>
#include <QDir>
#include <QFileInfo>

using namespace bb::cascades;

QNetworkAccessManager * WebImageView::mNetManager = new QNetworkAccessManager();
QNetworkDiskCache * WebImageView::mNetworkDiskCache = new QNetworkDiskCache();

WebImageView::WebImageView()
{
    /*
     * Creates a folder, could be used when you want to get an absolute path of the image.
     * @author Merrick Zhang
    */
    QFileInfo imageDir(QDir::homePath() + "/images/");
    if (!imageDir.exists()) {
        QDir().mkdir(imageDir.path());
    }

    /*
     * This is used to fix the ListView Control ReUse problem, sometimes if you flip fingers fast,
     * this control will show mistaken images.
     */
    //connect(this,SIGNAL(creationCompleted()),this,SLOT(resetControl()));

    /*
     * Initialize network cache
     * use QNetworksDiskCache to automatically cache images.
     */
    mNetworkDiskCache->setCacheDirectory(QDir::homePath() + "/cache/");
    mNetworkDiskCache->setMaximumCacheSize(100 * 1024 * 1024);
    // Set cache in manager
    mNetManager->setCache(mNetworkDiskCache);
    // Set defaults
    mLoading = 0;
}

const QUrl& WebImageView::url() const
{
    return mUrl;
}

void WebImageView::setUrl(QUrl url)
{
	/*
	 * bypass null url values.
	 */
    if (url.scheme() == "") {
        return;
    }

    /*
     * deal with "asset://" and relative image path
     */
    if (url.scheme() != "http") {
//        resetImage();
        setImageSource(url);
        return;
    }

    mUrl = url;
    mLoading = 0;

    // Reset the image
//    resetImage();

    // Create request
    QNetworkRequest request;
    request.setAttribute(QNetworkRequest::CacheLoadControlAttribute, QNetworkRequest::PreferCache);
    request.setUrl(url);

    // Create reply
    QNetworkReply * reply = mNetManager->get(request);


    // Connect to signals
    QObject::connect(reply, SIGNAL(finished()), this, SLOT(imageLoaded()));
    QObject::connect(reply, SIGNAL(downloadProgress(qint64, qint64)), this,
            SLOT(dowloadProgressed(qint64,qint64)));

    emit urlChanged();
}
/*
 * I'm using md5(url) to generate a unique filename.
 */
QString WebImageView::md5(const QString key)
{
    QString md5;
    QByteArray ba, bb;
    QCryptographicHash md(QCryptographicHash::Md5);
    ba.append(key);
    md.addData(ba);
    bb = md.result();
    md5.append(bb.toHex());
    return md5;
}


double WebImageView::loading() const
{
    return mLoading;
}

void WebImageView::imageLoaded()
{

    // Get reply
    QNetworkReply * reply = qobject_cast<QNetworkReply*>(sender());
    QVariant fromCache = reply->attribute(QNetworkRequest::SourceIsFromCacheAttribute);
    qDebug() << "page from cache?" << fromCache.toBool();
    if (reply->error() == QNetworkReply::NoError) {
        if (isARedirectedUrl(reply)) {
            setURLToRedirectedUrl(reply);
            return;
        } else {
            imageData = reply->readAll();
            /*
             * since blackberry cascades's Image class doesn't provide any abilities to
             * extract data from it, I'd like to keep imageData in Memory for future use.
             * this is why I use global variant instead of local one.
             */
            resetImage();
            setImage(Image(imageData));
        }
    }
	emit loadComplete();
    // Memory management
    reply->deleteLater();
}

bool WebImageView::isARedirectedUrl(QNetworkReply *reply)
{
    QUrl redirection = reply->attribute(QNetworkRequest::RedirectionTargetAttribute).toUrl();
    return !redirection.isEmpty();
}

void WebImageView::setURLToRedirectedUrl(QNetworkReply *reply)
{
    QUrl redirectionUrl = reply->attribute(QNetworkRequest::RedirectionTargetAttribute).toUrl();
    QUrl baseUrl = reply->url();
    QUrl resolvedUrl = baseUrl.resolved(redirectionUrl);

    setUrl(resolvedUrl.toString());
}

void WebImageView::clearCache()
{
	/*
	 * This is a INVOCABLE function so you can call it from QML.
	 */
    mNetworkDiskCache->clear();

    QDir imageDir(QDir::homePath() + "/images");
    imageDir.setFilter(QDir::NoDotAndDotDot | QDir::Files);
    foreach(const QString& file, imageDir.entryList()){
    imageDir.remove(file);
}
}

QString WebImageView::getCachedPath()
{
	/*
	 * This function will save the image to /images/ folder and return its path.
	 * very useful for invoking system picture viewer.
	 */
    if (imageData.isEmpty()) {
        qDebug()<<"imageData is empty.";
        return "";
    } else {
        QString fileName = md5(mUrl.toString());
        QString filepath = QDir::homePath() + "/images/" + fileName + ".jpg"; //in my app this can only be jpg. you'd change it from mUrl.
        QFile imageFile(filepath);
        if (imageFile.open(QIODevice::WriteOnly)) {
            imageFile.write(imageData);
            imageFile.close();
            return "file://" + filepath;
        } else {
            qDebug()<<"Can't open file to write.";
            return "";
        }
    }
}
void WebImageView::dowloadProgressed(qint64 bytes, qint64 total)
{
    mLoading = double(bytes) / double(total);

    emit loadingChanged();
}

void WebImageView::resetControl()
{
	// reset everything to default.
    resetImage();
    resetImageSource();
    mUrl=NULL;
    mLoading =0;
    imageData.clear();

}
