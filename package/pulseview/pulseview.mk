################################################################################
#
# pulseview
#
################################################################################

# TODO Pulseview can be built and linked against Qt4 as well.

PULSEVIEW_VERSION = 0.3.0
PULSEVIEW_SITE = http://sigrok.org/download/source/pulseview
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
