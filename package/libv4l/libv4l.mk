################################################################################
#
# libv4l
#
################################################################################

LIBV4L_VERSION = 1.12.5
LIBV4L_SOURCE = v4l-utils-$(LIBV4L_VERSION).tar.bz2
LIBV4L_SITE = http://linuxtv.org/downloads/v4l-utils
LIBV4L_INSTALL_STAGING = YES
LIBV4L_DEPENDENCIES = host-pkgconf
LIBV4L_CONF_OPTS = --disable-doxygen-doc

# 0003-utils-qv4l2-Makefile.am-link-with-librt.patch, host-gettext
# needed for autoreconf to work
LIBV4L_AUTORECONF = YES
LIBV4L_DEPENDENCIES += host-gettext

# fix uclibc-ng configure/compile
LIBV4L_CONF_ENV = ac_cv_prog_cc_c99='-std=gnu99'

# v4l-utils components have different licences, see v4l-utils.spec for details
LIBV4L_LICENSE = GPL-2.0+ (utilities), LGPL-2.1+ (libraries)
LIBV4L_LICENSE_FILES = COPYING COPYING.libv4l lib/libv4l1/libv4l1-kernelcode-license.txt

ifeq ($(BR2_PACKAGE_ALSA_LIB),y)
LIBV4L_DEPENDENCIES += alsa-lib
endif

ifeq ($(BR2_PACKAGE_ARGP_STANDALONE),y)
LIBV4L_DEPENDENCIES += argp-standalone
LIBV4L_LIBS += -largp
endif

LIBV4L_DEPENDENCIES += $(if $(BR2_PACKAGE_LIBICONV),libiconv)

ifeq ($(BR2_PACKAGE_JPEG),y)
LIBV4L_DEPENDENCIES += jpeg
LIBV4L_CONF_OPTS += --with-jpeg
else
LIBV4L_CONF_OPTS += --without-jpeg
endif

ifeq ($(BR2_PACKAGE_HAS_LIBGL),y)
LIBV4L_DEPENDENCIES += libgl
endif

ifeq ($(BR2_PACKAGE_HAS_UDEV),y)
LIBV4L_DEPENDENCIES += udev
endif

ifeq ($(BR2_PACKAGE_LIBGLU),y)
LIBV4L_DEPENDENCIES += libglu
endif

ifeq ($(BR2_PACKAGE_LIBV4L_UTILS),y)
LIBV4L_CONF_OPTS += --enable-v4l-utils
ifeq ($(BR2_NEEDS_GETTEXT_IF_LOCALE),y)
LIBV4L_DEPENDENCIES += gettext
endif
ifeq ($(BR2_PACKAGE_QT5BASE)$(BR2_PACKAGE_QT5BASE_GUI)$(BR2_PACKAGE_QT5BASE_WIDGETS),yyy)
LIBV4L_CONF_OPTS += --enable-qv4l2
LIBV4L_DEPENDENCIES += qt5base
# protect against host version detection of moc-qt5/rcc-qt5/uic-qt5
LIBV4L_CONF_ENV += \
	ac_cv_prog_MOC=$(HOST_DIR)/usr/bin/moc \
	ac_cv_prog_RCC=$(HOST_DIR)/usr/bin/rcc \
	ac_cv_prog_UIC=$(HOST_DIR)/usr/bin/uic
# qt5 needs c++11 (since qt-5.7)
ifeq ($(BR2_PACKAGE_QT5_VERSION_LATEST),y)
LIBV4L_CONF_ENV += CXXFLAGS="$(TARGET_CXXFLAGS) -std=c++11"
endif
else ifeq ($(BR2_PACKAGE_QT_OPENGL_GL_DESKTOP),y)
LIBV4L_CONF_OPTS += --enable-qv4l2
LIBV4L_DEPENDENCIES += qt
else
LIBV4L_CONF_OPTS += --disable-qv4l2
endif
else
LIBV4L_CONF_OPTS += --disable-v4l-utils
endif

LIBV4L_CONF_ENV += LIBS="$(LIBV4L_LIBS)"

$(eval $(autotools-package))
