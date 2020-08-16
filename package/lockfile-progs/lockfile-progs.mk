################################################################################
#
# lockfile-progs
#
################################################################################

LOCKFILE_PROGS_VERSION = 0.1.18
LOCKFILE_PROGS_SOURCE = lockfile-progs_$(LOCKFILE_PROGS_VERSION).tar.gz
LOCKFILE_PROGS_SITE = http://snapshot.debian.org/archive/debian/20180903T205652Z/pool/main/l/lockfile-progs
LOCKFILE_PROGS_DEPENDENCIES = liblockfile
LOCKFILE_PROGS_LICENSE = GPL-2.0
LOCKFILE_PROGS_LICENSE_FILES = COPYING

LOCKFILE_PROGS_BINS = \
	$(addprefix lockfile-,check create remove touch) \
	$(addprefix mail-,lock touchlock unlock)

define LOCKFILE_PROGS_BUILD_CMDS
	$(MAKE) $(TARGET_CONFIGURE_OPTS) -C $(@D)
endef

define LOCKFILE_PROGS_INSTALL_TARGET_CMDS
	for i in $(LOCKFILE_PROGS_BINS); do \
		$(INSTALL) -D -m 755 $(@D)/bin/$$i $(TARGET_DIR)/usr/bin/$$i || exit 1; \
	done
endef

$(eval $(generic-package))
