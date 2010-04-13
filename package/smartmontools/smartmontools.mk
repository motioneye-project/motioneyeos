#############################################################
#
# smartmontools
#
#############################################################
SMARTMONTOOLS_VERSION:=5.33
SMARTMONTOOLS_SOURCE:=smartmontools-$(SMARTMONTOOLS_VERSION).tar.gz
SMARTMONTOOLS_SITE:=http://$(BR2_SOURCEFORGE_MIRROR).dl.sourceforge.net/sourceforge/smartmontools
SMARTMONTOOLS_DIR:=$(BUILD_DIR)/smartmontools-$(SMARTMONTOOLS_VERSION)

$(eval $(call AUTOTARGETS,package,smartmontools))
