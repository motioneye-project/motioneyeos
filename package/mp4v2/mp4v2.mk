################################################################################
#
# mp4v2
#
################################################################################

MP4V2_VERSION = 2.0.0
MP4V2_SOURCE = mp4v2-$(MP4V2_VERSION).tar.bz2
MP4V2_SITE = https://mp4v2.googlecode.com/files
MP4V2_INSTALL_STAGING = YES
MP4V2_LICENSE = MPLv1.1
MP4V2_LICENSE_FILES = COPYING

# help2man expects to be able to run utilities on the build machine to
# grab --help output which doesn't work when cross compiling, so
# disable it
MP4V2_CONF_ENV = ac_cv_prog_FOUND_HELP2MAN=no

# infrastructure passes --disable-debug if !BR2_ENABLE_DEBUG. With
# mpv42 the only thing this option does is that it tries to strip any
# -g* options from CFLAGS/CXXFLAGS. The logic to do so is
# unfortunately buggy, so just pass --enable-debug to disable this
MP4V2_CONF_OPTS = --enable-debug

ifeq ($(BR2_LARGEFILE),y)
MP4V2_CONF_OPTS += --enable-largefile
else
MP4V2_CONF_OPTS += --disable-largefile
endif

ifeq ($(BR2_PACKAGE_MP4V2_UTIL),y)
MP4V2_CONF_OPTS += --enable-util
else
MP4V2_CONF_OPTS += --disable-util
endif

$(eval $(autotools-package))
