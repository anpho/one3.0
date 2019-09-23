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
import bb.multimedia 1.4
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
        actions: [
            ActionItem {
                title: qsTr("Sponsors")
                imageSource: "asset:///icon/ic_info.png"
                onTriggered: {
                    onTriggered:
                    {
                        var aboutpage = Qt.createComponent("Page-Sponsor.qml").createObject(currentNav);
                        aboutpage.nav = currentNav;
                        currentNav.push(aboutpage)
                    }
                }
                
            },
            ActionItem {
                title: qsTr("Review")
                imageSource: "asset:///icon/ic_edit_bookmarks.png"
                onTriggered: {
                    Qt.openUrlExternally("appworld://content/59939466")
                }
            }
        ]
    }
    onCreationCompleted: {
        if (_app.getv("showwelcome", "true") == "true") {
            var welcomesheet = Qt.createComponent("Readme.qml").createObject(tabroot)
            welcomesheet.open();
        }
    }
    id: tabroot
    property variant currentNav: activeTab.nav
    property bool showBackButton: _app.getv("backbutton", "true") == "true"
    property int fontsize: parseInt(_app.getv("fontsize", "100"))
    showTabsOnActionBar: false
    Tab { //主页
        title: qsTr("Home") + Retranslate.onLocaleOrLanguageChanged
        imageSource: "asset:///icon/ic_home.png"
        property alias nav: nav_hp
        NavigationPane {
            id: nav_hp
            property variant audiomgr: mpcontroller
            onPopTransitionEnded: co.onPopTransitionEnded(page, nav_hp)
            onPushTransitionEnded: co.onPushTransitionEnded(page, nav_hp)
            backButtonsVisible: tabroot.showBackButton
            property alias fontsize: tabroot.fontsize
            function notifySettingsReload() {
                tabroot.showBackButton = _app.getv("backbutton", "true") == "true"
                tabroot.fontsize = parseInt(_app.getv("fontsize", "100"))
            }
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
            property variant audiomgr: mpcontroller
            onPopTransitionEnded: co.onPopTransitionEnded(page, nav_essay)
            onPushTransitionEnded: co.onPushTransitionEnded(page, nav_essay)
            backButtonsVisible: tabroot.showBackButton
            property alias fontsize: tabroot.fontsize
            function notifySettingsReload() {
                tabroot.showBackButton = _app.getv("backbutton", "true") == "true"
                tabroot.fontsize = parseInt(_app.getv("fontsize", "100"))
            }
            ListEssayView {
                nav: nav_essay
            }
        }
    }
    /*    Tab { //音乐 tab
        title: qsTr("Music") + Retranslate.onLocaleOrLanguageChanged
        imageSource: "asset:///icon/ic_doctype_music.png"
        property alias nav: nav_music
        NavigationPane {
            id: nav_music
            onPopTransitionEnded: co.onPopTransitionEnded(page, nav_music)
            onPushTransitionEnded: co.onPushTransitionEnded(page, nav_music)
            backButtonsVisible: tabroot.showBackButton
            property alias fontsize: tabroot.fontsize
            function notifySettingsReload() {
                tabroot.showBackButton = _app.getv("backbutton", "true") == "true"
                tabroot.fontsize = parseInt(_app.getv("fontsize", "100"))
            }
            ListMusicView {
                nav: nav_music
            }
            property variant audiomgr: mpcontroller
        }
    }
    Tab { //电影 tab
        title: qsTr("Movie") + Retranslate.onLocaleOrLanguageChanged
        imageSource: "asset:///icon/ic_doctype_video.png"
        property alias nav: nav_movie
        NavigationPane {
            id: nav_movie
            property variant audiomgr: mpcontroller
            onPopTransitionEnded: co.onPopTransitionEnded(page, nav_movie)
            onPushTransitionEnded: co.onPushTransitionEnded(page, nav_movie)
            backButtonsVisible: tabroot.showBackButton
            property alias fontsize: tabroot.fontsize
            function notifySettingsReload() {
                tabroot.showBackButton = _app.getv("backbutton", "true") == "true"
                tabroot.fontsize = parseInt(_app.getv("fontsize", "100"))
            }
            ListMovieView {
                nav: nav_movie
            }
        }
    }
*/
    attachedObjects: [
        Common {
            id: co
        },
        MediaPlayer {
            id: mp
            onMediaStateChanged: {
                if (mediaState == MediaState.Started) {
                    npc.acquire()
                    npc.mediaState = MediaState.Started
                } else if (mediaState == MediaState.Stopped) {
                    npc.mediaState = MediaState.Stopped
                    npc.revoke();
                } else if (mediaState == MediaState.Paused) {
                    npc.mediaState = MediaState.Paused
                }
            }
            onMetaDataChanged: {
                console.log(JSON.stringify(metaData))
            }
        },
        NowPlayingConnection {
            id: npc
            repeatMode: RepeatMode.Unsupported
            shuffleMode: ShuffleMode.Unsupported
            connectionName: "onenpc"
            iconUrl: "asset:///res/nav_title.png"
            nextEnabled: false
            previousEnabled: false
            onPlay: {
                mp.play()
            }
            onPause: {
                mp.pause()
            }
            onAcquired: {

            }
            overlayStyle: OverlayStyle.Fancy
        },
        QtObject {
            id: mpcontroller
            property string cur: ""
            function play(uri, meta) {
                cur = uri; //MARK CURRENT URL
                mp.sourceUrl = uri;
                mp.play();
                var metadata = {
                    "track": meta.title,
                    "artist": meta.author
                };
                npc.setMetaData(metadata)
            }
            function pause() {
                mp.pause()
            }
            function stop() {
                mp.stop()
            }
            function reset() {
                mp.reset();
            }
            property variant mediaState: mp.mediaState
            property variant mplayer: mp
            property variant nowplayconnection: npc
        }
    ]
}
