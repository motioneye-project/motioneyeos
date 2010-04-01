#############################################################
#
# MatchBox Common
#
#############################################################

MATCHBOX_COMMON_VERSION = 0.9.1
MATCHBOX_COMMON_SOURCE = matchbox-common-$(MATCHBOX_COMMON_VERSION).tar.bz2
MATCHBOX_COMMON_SITE = http://matchbox-project.org/sources/matchbox-common/$(MATCHBOX_COMMON_VERSION)
MATCHBOX_COMMON_DEPENDENCIES = matchbox-lib

#############################################################

$(eval $(call AUTOTARGETS,package/matchbox,matchbox-common))
