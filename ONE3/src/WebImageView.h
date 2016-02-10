#ifndef WEBIMAGEVIEW_H_
#define WEBIMAGEVIEW_H_


#include <bb/cascades/ImageView>
#include <QNetworkAccessManager>
#include <QNetworkDiskCache>
#include <QUrl>

using namespace bb::cascades;

class WebImageView: public bb::cascades::ImageView {
	Q_OBJECT
	Q_PROPERTY (QUrl url READ url WRITE setUrl NOTIFY urlChanged)
	Q_PROPERTY (float loading READ loading NOTIFY loadingChanged)

public:
	WebImageView();
    virtual ~WebImageView() {}

	const QUrl& url() const;
	double loading() const;

    Q_INVOKABLE void clearCache();
    Q_INVOKABLE QString getCachedPath();

public Q_SLOTS:
	void setUrl(QUrl url);

private Q_SLOTS:
	void imageLoaded();
	void dowloadProgressed(qint64,qint64);
	void resetControl();

private:
	static QNetworkAccessManager * mNetManager;
	static QNetworkDiskCache * mNetworkDiskCache;
	QString md5(const QString key);
    QUrl mUrl;
	float mLoading;
	QByteArray imageData ;
	bool isARedirectedUrl(QNetworkReply *reply);
	void setURLToRedirectedUrl(QNetworkReply *reply);

signals:
    void urlChanged();
    void loadingChanged();
    void loadComplete();
};

#endif /* WEBIMAGEVIEW_H_ */
