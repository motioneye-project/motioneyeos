#############################################################
#
# expat
#
#############################################################

EXPAT_VERSION = 2.1.0
EXPAT_SITE = http://$(BR2_SOURCEFORGE_MIRROR).dl.sourceforge.net/project/expat/expat/$(EXPAT_VERSION)
EXPAT_INSTALL_STAGING = YES
EXPAT_INSTALL_STAGING_OPT = DESTDIR=$(STAGING_DIR) installlib
EXPAT_INSTALL_TARGET_OPT = DESTDIR=$(TARGET_DIR) installlib
EXPAT_DEPENDENCIES = host-pkg-config

$(eval $(call AUTOTARGETS))
$(eval $(call AUTOTARGETS,host))
