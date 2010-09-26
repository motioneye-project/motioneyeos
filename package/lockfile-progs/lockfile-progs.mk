#############################################################
#
# lockfile-progs
#
#############################################################
LOCKFILE_PROGS_VERSION = 0.1.15
LOCKFILE_PROGS_SOURCE = lockfile-progs_$(LOCKFILE_PROGS_VERSION).tar.gz
LOCKFILE_PROGS_SITE = $(BR2_DEBIAN_MIRROR)/debian/pool/main/l/lockfile-progs/

define LOCKFILE_PROGS_BUILD_CMDS
	$(MAKE) $(TARGET_CONFIGURE_OPTS) -C $(@D)
endef

define LOCKFILE_PROGS_INSTALL_TARGET_CMDS
	cp -a $(@D)/bin/lockfile* $(TARGET_DIR)/usr/bin
endef

define LOCKFILE_PROGS_CLEAN_CMDS
	-rm -f $(TARGET_DIR)/usr/bin/lockfile-*
	-$(MAKE) -C $(@D) clean
endef

$(eval $(call GENTARGETS,package,lockfile-progs))
