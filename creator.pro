################################################################################
#      This file is part of LibreELEC - http://www.libreelec.tv
#      Copyright (C) 2013-2015 RasPlex project
#      Copyright (C) 2016 Team LibreELEC
#
#  LibreELEC is free software: you can redistribute it and/or modify
#  it under the terms of the GNU General Public License as published by
#  the Free Software Foundation, either version 2 of the License, or
#  (at your option) any later version.
#
#  LibreELEC is distributed in the hope that it will be useful,
#  but WITHOUT ANY WARRANTY; without even the implied warranty of
#  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#  GNU General Public License for more details.
#
#  You should have received a copy of the GNU General Public License
#  along with LibreELEC.  If not, see <http://www.gnu.org/licenses/>.
################################################################################

#-------------------------------------------------
#
# Project created by QtCreator 2013-03-14T18:13:26
#
#-------------------------------------------------

QT += core gui network widgets

TARGET = LibreELEC.USB-SD.Creator
TEMPLATE = app

SOURCES += main.cpp \
           creator.cpp \
           diskwriter.cpp \
           jsonparser.cpp \
           movingaverage.cpp \
           downloadmanager.cpp \
           translator.cpp

HEADERS += creator.h \
           diskwriter.h \
           jsonparser.h \
           movingaverage.h \
           downloadmanager.h  \
           deviceenumerator.h \
           translator.h

MOC_DIR     = .generated_files
OBJECTS_DIR = .generated_files

# hide the full g++ command line and print only filename
CONFIG += silent

TRANSLATIONS += lang/lang-en_GB.ts \
                lang/lang-de_DE.ts \
                lang/lang-nl_NL.ts

static { # everything below takes effect with CONFIG += static
    CONFIG += static
    CONFIG += staticlib # this is needed if you create a static library, not a static executable
    DEFINES += STATIC
    message("~~~ static build ~~~") # this is for information, that the static build is done
}

win32 {
    # add suffix
    TARGET = LibreELEC.USB-SD.Creator.Win32

    SOURCES += diskwriter_windows.cpp \
               deviceenumerator_windows.cpp

    HEADERS += diskwriter_windows.h \
               deviceenumerator_windows.h \
               privileges.h

    CONFIG += rtti
    QMAKE_LFLAGS = -static -static-libgcc
    RC_FILE = winapp.rc

    # remove possible other optimization flags
    QMAKE_CXXFLAGS_RELEASE -= -O
    QMAKE_CXXFLAGS_RELEASE -= -O1
    QMAKE_CXXFLAGS_RELEASE -= -O2
    QMAKE_CXXFLAGS_RELEASE -= -O3
    # Optimize for size
    QMAKE_CXXFLAGS_RELEASE += -Os

    QMAKE_CXXFLAGS = -Ic:\Qt\Qt5.6.1\Tools\mingw492_32\i686-w64-mingw32\include

    # write image to local file named 'dummy_image_file'
    # instead to real device (for testing)
    #DEFINES += WINDOWS_DUMMY_WRITE
}

unix {
    # remove possible other optimization flags
    QMAKE_CFLAGS_RELEASE -= -O
    QMAKE_CFLAGS_RELEASE -= -O1
    QMAKE_CFLAGS_RELEASE -= -O2
    QMAKE_CFLAGS_RELEASE -= -O3
    # Optimize for size
    QMAKE_CFLAGS_RELEASE += -Os

    QMAKE_CXXFLAGS += -fPIC

    contains(QT_ARCH, i386) {
        # link with i386 library manualy unpacked
        QMAKE_LFLAGS += -L$(HOME)/Qt5.6.1/ubuntu-i386-lib/usr/lib/i386-linux-gnu
        QMAKE_RPATHLINKDIR += $$(HOME)/Qt5.6.1/ubuntu-i386-lib/lib/i386-linux-gnu
    }

    SOURCES += diskwriter_unix.cpp \
               deviceenumerator_unix.cpp

    HEADERS += diskwriter_unix.h \
               deviceenumerator_unix.h
}

macx {
    # use spaces on macOS
    TARGET = "LibreELEC USB-SD Creator"

    SOURCES += privileges_unix.cpp
    HEADERS += privileges_unix.h
}

linux* {
    # manually add suffix 32/64
    TARGET = LibreELEC.USB-SD.Creator.Linux-bit.bin

    SOURCES += privileges_unix.cpp
    HEADERS += privileges_unix.h

    QMAKE_CXXFLAGS += -std=c++11

    LIBS += -lblkid
}

FORMS += creator.ui

LIBS += -lz

OTHER_FILES +=

RESOURCES += resources.qrc
