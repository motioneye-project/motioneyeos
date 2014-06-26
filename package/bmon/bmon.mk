################################################################################
#
# bmon
#
################################################################################

BMON_VERSION = 3.2
BMON_SITE = $(call github,tgraf,bmon,v$(BMON_VERSION))
# configure not shipped
BMON_AUTORECONF = YES
BMON_DEPENDENCIES = host-pkgconf libconfuse libnl ncurses
BMON_LICENSE = BSD-2c
BMON_LICENSE_FILES = LICENSE

# link dynamically unless explicitly requested otherwise
ifeq ($(BR2_PREFER_STATIC_LIB),)
BMON_CONF_OPT += --disable-static
else
# forgets to explicitly link with pthread for libnl
BMON_CONF_OPT += LIBS=-lpthread
endif

$(eval $(autotools-package))
