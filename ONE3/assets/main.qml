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

import bb.cascades 1.4
TabbedPane {
    Menu.definition: MenuDefinition {
        helpAction: HelpActionItem {
            // 帮助
            onTriggered: {
                var aboutpage = Qt.createComponent("Page-About.qml").createObject(currentNav);
                aboutpage.nav = currentNav;
                currentNav.push(aboutpage)
            }
        }
        settingsAction: SettingsActionItem {
            // 设置
            onTriggered: {
                var aboutpage = Qt.createComponent("Page-Settings.qml").createObject(currentNav);
                aboutpage.nav = currentNav;
                currentNav.push(aboutpage)
            }
        }
    }
    onCreationCompleted: {
        if (_app.getv("showwelcome", "true") == "true") {
            var welcomesheet = Qt.createComponent("Readme.qml").createObject(tabroot)
            welcomesheet.open();
        }
    }
    id: tabroot
    property variant currentNav: activeTab.nav
    showTabsOnActionBar: false
    Tab { //主页
        title: qsTr("Home") + Retranslate.onLocaleOrLanguageChanged
        imageSource: "asset:///icon/ic_home.png"
        property alias nav: nav_hp
        NavigationPane {
            id: nav_hp
            onPopTransitionEnded: co.onPopTransitionEnded(page, nav_hp)
            onPushTransitionEnded: co.onPushTransitionEnded(page, nav_hp)
            ListHomepageView {
                nav: nav_hp
            }
        }
    }
    Tab { //阅读
        title: qsTr("Articles") + Retranslate.onLocaleOrLanguageChanged
        imageSource: "asset:///icon/ic_doctype_generic.png"
        property alias nav: nav_essay
        NavigationPane {
            id: nav_essay
            onPopTransitionEnded: co.onPopTransitionEnded(page, nav_essay)
            onPushTransitionEnded: co.onPushTransitionEnded(page, nav_essay)
            ListEssayView {
                nav: nav_essay
            }
        }
    }
    Tab { //音乐 tab
        title: qsTr("Music") + Retranslate.onLocaleOrLanguageChanged
        imageSource: "asset:///icon/ic_doctype_music.png"
        property alias nav: nav_music
        NavigationPane {
            id: nav_music
            onPopTransitionEnded: co.onPopTransitionEnded(page, nav_music)
            onPushTransitionEnded: co.onPushTransitionEnded(page, nav_music)
            ListMusicView {
                nav: nav_music
            }
        }
    }
    Tab { //电影 tab
        title: qsTr("Movie") + Retranslate.onLocaleOrLanguageChanged
        imageSource: "asset:///icon/ic_doctype_video.png"
        property alias nav: nav_movie
        NavigationPane {
            id: nav_movie
            onPopTransitionEnded: co.onPopTransitionEnded(page, nav_movie)
            onPushTransitionEnded: co.onPushTransitionEnded(page, nav_movie)
            ListMovieView {
                nav: nav_movie
            }
        }
    }
    attachedObjects: [
        Common {
            id: co
        }
    ]
}
