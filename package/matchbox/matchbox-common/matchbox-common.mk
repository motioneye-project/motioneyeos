#############################################################
#
# MatchBox Common
#
#############################################################

MATCHBOX_COMMON_VERSION = 0.9.1
MATCHBOX_COMMON_SOURCE = matchbox-common-$(MATCHBOX_COMMON_VERSION).tar.bz2
MATCHBOX_COMMON_SITE = http://matchbox-project.org/sources/matchbox-common/$(MATCHBOX_COMMON_VERSION)
MATCHBOX_COMMON_DEPENDENCIES = matchbox-lib

ifeq ($(strip $(BR2_PACKAGE_MATCHBOX_COMMON_PDA)),y)
	MATCHBOX_COMMON_CONF_OPT += --enable-pda-folders
endif

#############################################################

$(eval $(autotools-package))
