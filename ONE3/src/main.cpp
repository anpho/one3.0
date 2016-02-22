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

#include <QLocale>
#include <QTranslator>
#include "WebImageView.h"
#include <Qt/qdeclarativedebug.h>
#include <unistd.h>
using namespace bb::cascades;

Q_DECL_EXPORT int main(int argc, char **argv)
{
    QSettings settings;
    if (!settings.value("use_dark_theme").isNull()) {
        qputenv("CASCADES_THEME", (settings.value("use_dark_theme").toString()+"?primaryColor=0x6A6D90&amp;primaryBase=0xB8BECA").toUtf8());
    }
    qmlRegisterType<WebImageView>("cn.anpho", 1, 0, "WebImageView");

    Application app(argc, argv);

    // Create the Application UI object, this is where the main.qml file
    // is loaded and the application scene is set.
    ApplicationUI appui;

    // Enter the application main event loop.
    return Application::exec();
}
