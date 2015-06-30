################################################################################
#
# pulseview
#
################################################################################

# TODO Pulseview can be built and linked against Qt4 as well.

# No https access on upstream git
PULSEVIEW_SITE = git://sigrok.org/pulseview
PULSEVIEW_VERSION = ec6cc07fed12f5070eee6b8cb11343e83d42533c
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
