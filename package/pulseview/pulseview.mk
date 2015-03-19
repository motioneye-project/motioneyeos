################################################################################
#
# pulseview
#
################################################################################

# TODO Pulseview can be built and linked against Qt4 as well.

# No https access on upstream git
PULSEVIEW_SITE = git://sigrok.org/pulseview
PULSEVIEW_VERSION = 19be0af16af83ca10f7ce69cb64f0b0c6f6a0d81
PULSEVIEW_LICENSE = GPLv3+
PULSEVIEW_LICENSE_FILES = COPYING
PULSEVIEW_DEPENDENCIES = libsigrok qt5base qt5svg boost
PULSEVIEW_CONF_OPTS = -DDISABLE_WERROR=TRUE

ifeq ($(BR2_PACKAGE_LIBSIGROKDECODE),y)
PULSEVIEW_CONF_OPTS += -DENABLE_DECODE=TRUE
PULSEVIEW_DEPENDENCIES += libsigrokdecode
else
PULSEVIEW_CONF_OPTS += -DENABLE_DECODE=FALSE
endif

$(eval $(cmake-package))
