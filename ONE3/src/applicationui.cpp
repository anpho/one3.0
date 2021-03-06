/*
 * Copyright (c) 2011-2015 BlackBerry Limited.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

#include "applicationui.hpp"

#include <bb/cascades/Application>
#include <bb/cascades/QmlDocument>
#include <bb/cascades/AbstractPane>
#include <bb/cascades/LocaleHandler>
#include <qt4/QtGui/qtextdocument.h>
#include <QNetworkReply>
#include <QSsl>
using namespace bb::cascades;
using namespace bb::system;

ApplicationUI::ApplicationUI() :
        QObject()
{
    // prepare the localization
    m_pTranslator = new QTranslator(this);
    m_pLocaleHandler = new LocaleHandler(this);
    m_pInvokeManager = new InvokeManager(this);
    m_qnam = new QNetworkAccessManager(this);

    bool res = QObject::connect(m_pLocaleHandler, SIGNAL(systemLanguageChanged()), this,
            SLOT(onSystemLanguageChanged()));
    // This is only available in Debug builds
    Q_ASSERT(res);
    // Since the variable is not used in the app, this is added to avoid a
    // compiler warning
    Q_UNUSED(res);

    // initial load
    onSystemLanguageChanged();

    // Create scene document from main.qml asset, the parent is set
    // to ensure the document gets destroyed properly at shut down.
    QmlDocument *qml = QmlDocument::create("asset:///main.qml").parent(this);
    qml->setContextProperty("_app", this);
    // Create root object for the UI
    AbstractPane *root = qml->createRootObject<AbstractPane>();

    // Set created root object as the application scene
    Application::instance()->setScene(root);
}

void ApplicationUI::onSystemLanguageChanged()
{
    QCoreApplication::instance()->removeTranslator(m_pTranslator);
    // Initiate, load and install the application translation files.
    QString locale_string = QLocale().name();
    QString file_name = QString("ONE3_%1").arg(locale_string);
    if (m_pTranslator->load(file_name, "app/native/qm")) {
        QCoreApplication::instance()->installTranslator(m_pTranslator);
    }
}
QString ApplicationUI::getv(const QString &objectName, const QString &defaultValue)
{
    QSettings settings;
    if (settings.value(objectName).isNull()) {
        return defaultValue;
    }
    qDebug() << "[SETTINGS]" << objectName << " is " << settings.value(objectName).toString();
    return settings.value(objectName).toString();
}

void ApplicationUI::setv(const QString &objectName, const QString &inputValue)
{
    QSettings settings;
    settings.setValue(objectName, QVariant(inputValue));
    qDebug() << "[SETTINGS]" << objectName << " set to " << inputValue;
}

void ApplicationUI::reset()
{
    QSettings settings;
    settings.clear();
    qDebug() << "[SETTINGS]ALL SETTINGS RESETED";
}

void ApplicationUI::invokeVideo(const QString &title, const QString &url)
{
    // invoke a video card to play video.
    InvokeRequest cardRequest;
    cardRequest.setTarget("sys.mediaplayer.previewer");
    cardRequest.setAction("bb.action.VIEW");

    QVariantMap map;
    map.insert("contentTitle", title);
    map.insert("imageUri", "asset:///res/default_no_content_grey.png");
    QByteArray requestData = bb::PpsObject::encode(map, NULL);

    cardRequest.setData(requestData);
    cardRequest.setUri(url);

    m_pInvokeManager->invoke(cardRequest);
}
void ApplicationUI::viewimage(QString path)
{
    // invoke the system image viewer
    InvokeRequest request;
    // Set the URI
    request.setUri(path);
    request.setTarget("sys.pictures.card.previewer");
    request.setAction("bb.action.VIEW");
    // Send the invocation request
    InvokeTargetReply *cardreply = m_pInvokeManager->invoke(request);
    Q_UNUSED(cardreply);
}
QString ApplicationUI::html2text(QString htmlString)
{
    QTextDocument doc;
    doc.setHtml(htmlString);

    return doc.toPlainText();
}

int ApplicationUI::setTextToClipboard(QString text)
{
    QByteArray ba = text.toLocal8Bit();

    if (get_clipboard_can_write() == 0) {
        empty_clipboard();
        int ret = set_clipboard_data("text/plain", ba.length(), ba.data());
        return ret;
    } else {
        return -1;
    }
}

void ApplicationUI::shareText(QString text)
{
    InvokeQuery *query = InvokeQuery::create().data(text.toUtf8()).mimeType("text/plain");
    Invocation *invocation = Invocation::create(query);
    query->setParent(invocation); // destroy query with invocation
    invocation->setParent(this); // app can be destroyed before onFinished() is called
    connect(invocation, SIGNAL(armed()), this, SLOT(onArmed()));
    connect(invocation, SIGNAL(finished()), this, SLOT(onFinished()));
}
void ApplicationUI::remember(QString uri, QString title, QString text)
{
    InvokeQuery *query = InvokeQuery::create();
    query->setInvokeTargetId("sys.pim.remember.composer");
    query->setUri(uri);

    QVariantMap qm;
    qm["subject"] = title;
    qm["description"] = text;
    query->setMetadata(qm);

    Invocation *invocation = Invocation::create(query);
    query->setParent(invocation); // destroy query with invocation
    invocation->setParent(this); // app can be destroyed before onFinished() is called

    connect(invocation, SIGNAL(armed()), this, SLOT(onArmed()));
    connect(invocation, SIGNAL(finished()), this, SLOT(onFinished()));
}
void ApplicationUI::onArmed()
{
    Invocation *invocation = qobject_cast<Invocation *>(sender());
    invocation->trigger("bb.action.SHARE");
}
void ApplicationUI::onFinished()
{
    Invocation *invocation = qobject_cast<Invocation *>(sender());
    invocation->deleteLater();
}

QString ApplicationUI::fetch(QString uri)
{

    const QUrl url = QUrl::fromUserInput(uri);
    QNetworkRequest qnr(url);

    if (uri.toLower().startsWith("https")) {
        qDebug() << "HTTPS";
        QSslConfiguration config = QSslConfiguration::defaultConfiguration();
        config.setProtocol(QSsl::AnyProtocol);
        qnr.setSslConfiguration(config);
    }

    qnr.setRawHeader(QString("User-Agent").toLatin1(), QString("curl/7").toLatin1());
    QNetworkReply* reply = m_qnam->get(qnr);

    QEventLoop eventLoop;
    connect(reply, SIGNAL(finished()), &eventLoop, SLOT(quit()));
    eventLoop.exec(QEventLoop::ExcludeUserInputEvents);

    QString data = QString::fromLocal8Bit(reply->readAll());
    qDebug() << data;

    reply->deleteLater();
    return data;
}
