################################################################################
#
# pulseview
#
################################################################################

# TODO Pulseview can be built and linked against Qt4 as well.

PULSEVIEW_VERSION = 0.3.0
PULSEVIEW_SITE = http://sigrok.org/download/source/pulseview
# bug fixed upstream
# http://article.gmane.org/gmane.comp.debugging.sigrok.devel/1950
PULSEVIEW_PATCH = \
	https://github.com/abraxa/pulseview/commit/dcfe0a01f72021aab961245d0ebcc9f8d4504b40.patch
PULSEVIEW_LICENSE = GPLv3+
PULSEVIEW_LICENSE_FILES = COPYING
PULSEVIEW_DEPENDENCIES = libsigrok qt5base qt5svg boost
PULSEVIEW_CONF_OPTS = -DDISABLE_WERROR=TRUE

ifeq ($(BR2_PACKAGE_BOOST_TEST),y)
PULSEVIEW_CONF_OPTS += -DENABLE_TESTS=TRUE
else
PULSEVIEW_CONF_OPTS += -DENABLE_TESTS=FALSE
endif

ifeq ($(BR2_PACKAGE_LIBSIGROKDECODE),y)
PULSEVIEW_CONF_OPTS += -DENABLE_DECODE=TRUE
PULSEVIEW_DEPENDENCIES += libsigrokdecode
else
PULSEVIEW_CONF_OPTS += -DENABLE_DECODE=FALSE
endif

$(eval $(cmake-package))
