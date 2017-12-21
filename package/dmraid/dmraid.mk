################################################################################
#
# dmraid
#
################################################################################

DMRAID_VERSION = 1.0.0.rc16-3
DMRAID_SOURCE = dmraid-$(DMRAID_VERSION).tar.bz2
DMRAID_SITE = http://people.redhat.com/~heinzm/sw/dmraid/src
DMRAID_SUBDIR = $(DMRAID_VERSION)/dmraid
# lib and tools race with parallel make
DMRAID_MAKE = $(MAKE1)
DMRAID_INSTALL_STAGING = YES
DMRAID_LICENSE = GPL-2.0
DMRAID_LICENSE_FILES = $(DMRAID_SUBDIR)/LICENSE_GPL $(DMRAID_SUBDIR)/LICENSE

DMRAID_DEPENDENCIES = lvm2

define DMRAID_INSTALL_INIT_SYSV
	$(INSTALL) -D -m 0755 package/dmraid/S20dmraid \
		$(TARGET_DIR)/etc/init.d/S20dmraid
endef

$(eval $(autotools-package))
