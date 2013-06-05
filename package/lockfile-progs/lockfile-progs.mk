################################################################################
#
# lockfile-progs
#
################################################################################

LOCKFILE_PROGS_VERSION = 0.1.15
LOCKFILE_PROGS_SOURCE = lockfile-progs_$(LOCKFILE_PROGS_VERSION).tar.gz
LOCKFILE_PROGS_SITE = $(BR2_DEBIAN_MIRROR)/debian/pool/main/l/lockfile-progs/
LOCKFILE_PROGS_DEPENDENCIES = liblockfile
LOCKFILE_PROGS_LICENSE = GPLv2
LOCKFILE_PROGS_LICENSE_FILES = COPYING

LOCKFILE_BINS = \
	$(addprefix lockfile-,check create remove touch) \
	$(addprefix mail-,lock touchlock unlock)

define LOCKFILE_PROGS_BUILD_CMDS
	$(MAKE) $(TARGET_CONFIGURE_OPTS) -C $(@D)
endef

define LOCKFILE_PROGS_INSTALL_TARGET_CMDS
	for i in $(LOCKFILE_BINS); do \
		install -D -m 755 $(@D)/bin/$$i $(TARGET_DIR)/usr/bin/$$i; \
	done
endef

define LOCKFILE_PROGS_UNINSTALL_TARGET_CMDS
	rm -f $(addprefix $(TARGET_DIR)/usr/bin/,$(LOCKFILE_BINS))
endef

define LOCKFILE_PROGS_CLEAN_CMDS
	-$(MAKE) -C $(@D) clean
endef

$(eval $(generic-package))
