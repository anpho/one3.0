APP_NAME = ONE3

CONFIG += qt warn_on cascades10
QT += network
LIBS += -lclipboard
LIBS += -lbbsystem -lbb 
LIBS += -lbbdata
LIBS += -lbbmultimedia
QT += gui
include(config.pri)
