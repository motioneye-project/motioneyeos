############################################################
#
# libsvgtiny
#
############################################################

LIBSVGTINY_SITE = svn://svn.netsurf-browser.org/trunk/libsvgtiny
LIBSVGTINY_VERSION = 9800
LIBSVGTINY_SVNDIR = libsvgtiny-svn-r$(LIBSVGTINY_VERSION)
LIBSVGTINY_SOURCE = $(LIBSVGTINY_SVNDIR).tar.bz2
LIBSVGTINY_INSTALL_STAGING = YES
LIBSVGTINY_INSTALL_TARGET = YES
LIBSVGTINY_DEPENDENCIES = libxml2 host-gperf host-pkg-config

$(DL_DIR)/$(LIBSVGTINY_SOURCE):
	$(SVN_CO) -r $(LIBSVGTINY_VERSION) $(LIBSVGTINY_SITE) $(BUILD_DIR)/$(LIBSVGTINY_SVNDIR)
	tar -cv -C $(BUILD_DIR) $(LIBSVGTINY_SVNDIR) | bzip2 - -c > $@
	rm -rf $(BUILD_DIR)/$(LIBSVGTINY_SVNDIR)

# use custom download step
LIBSVGTINY_TARGET_SOURCE := $(DL_DIR)/$(LIBSVGTINY_SOURCE)

define LIBSVGTINY_BUILD_CMDS
	$(TARGET_CONFIGURE_OPTS) $(MAKE) -C $(@D) PREFIX=/usr
endef

define LIBSVGTINY_INSTALL_STAGING_CMDS
	$(TARGET_CONFIGURE_OPTS) \
		$(MAKE) -C $(@D) PREFIX=/usr DESTDIR=$(STAGING_DIR) install
endef

define LIBSVGTINY_UNINSTALL_STAGING_CMDS
	$(TARGET_CONFIGURE_OPTS) \
		$(MAKE) -C $(@D) PREFIX=/usr DESTDIR=$(STAGING_DIR) uninstall
endef

define LIBSVGTINY_INSTALL_TARGET_CMDS
	$(TARGET_CONFIGURE_OPTS) \
		$(MAKE) -C $(@D) PREFIX=/usr DESTDIR=$(TARGET_DIR) install
endef

define LIBSVGTINY_UNINSTALL_TARGET_CMDS
	$(TARGET_CONFIGURE_OPTS) \
		$(MAKE) -C $(@D) PREFIX=/usr DESTDIR=$(TARGET_DIR) uninstall
endef

define LIBSVGTINY_CLEAN_CMDS
	$(TARGET_CONFIGURE_OPTS) $(MAKE) -C $(@D) clean
endef

$(eval $(call GENTARGETS,package,libsvgtiny))
