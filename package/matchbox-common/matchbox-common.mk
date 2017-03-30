################################################################################
#
# matchbox-common
#
################################################################################

MATCHBOX_COMMON_VERSION_MAJOR = 0.9
MATCHBOX_COMMON_VERSION = $(MATCHBOX_COMMON_VERSION_MAJOR).1
MATCHBOX_COMMON_SOURCE = matchbox-common-$(MATCHBOX_COMMON_VERSION).tar.bz2
MATCHBOX_COMMON_SITE = http://downloads.yoctoproject.org/releases/matchbox/matchbox-common/$(MATCHBOX_COMMON_VERSION_MAJOR)
MATCHBOX_COMMON_LICENSE = GPL-2.0+
MATCHBOX_COMMON_LICENSE_FILES = COPYING
MATCHBOX_COMMON_DEPENDENCIES = matchbox-lib

ifeq ($(strip $(BR2_PACKAGE_MATCHBOX_COMMON_PDA)),y)
MATCHBOX_COMMON_CONF_OPTS += --enable-pda-folders
else
MATCHBOX_COMMON_CONF_OPTS += --disable-pda-folders
endif

$(eval $(autotools-package))
