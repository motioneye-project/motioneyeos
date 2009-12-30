#############################################################
#
# expat
#
#############################################################

EXPAT_VERSION = 2.0.1
EXPAT_SOURCE = expat-$(EXPAT_VERSION).tar.gz
EXPAT_SITE = http://$(BR2_SOURCEFORGE_MIRROR).dl.sourceforge.net/sourceforge/expat
EXPAT_LIBTOOL_PATCH = NO
HOST_EXPAT_LIBTOOL_PATCH = NO
EXPAT_INSTALL_STAGING = YES
EXPAT_INSTALL_TARGET = YES
# no install-strip / install-exec
EXPAT_INSTALL_STAGING_OPT = DESTDIR=$(STAGING_DIR) installlib
EXPAT_INSTALL_TARGET_OPT = DESTDIR=$(TARGET_DIR) installlib

EXPAT_CONF_OPT = --enable-shared

EXPAT_DEPENDENCIES = host-pkg-config

$(eval $(call AUTOTARGETS,package,expat))
$(eval $(call AUTOTARGETS,package,expat,host))

$(EXPAT_HOOK_POST_INSTALL): $(EXPAT_TARGET_INSTALL_TARGET)
	$(STRIPCMD) $(STRIP_STRIP_UNNEEDED) $(TARGET_DIR)/usr/lib/libexpat.so.*
	touch $@
