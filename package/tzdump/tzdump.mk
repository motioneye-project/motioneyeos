################################################################################
#
# tzdump
#
################################################################################

TZDUMP_VERSION = e1a52ce12a701b8ea4163d6719713e38c0e53d35
TZDUMP_SITE = $(call github,alexandrebelloni,tzdump,$(TZDUMP_VERSION))
HOST_TZDUMP_DEPENDENCIES = host-zic

define HOST_TZDUMP_BUILD_CMDS
	cd $(@D) && $(HOSTCC) $(HOST_CFLAGS) $(HOST_LDFLAGS) -o tzdump tzdump.c
endef

define HOST_TZDUMP_INSTALL_CMDS
	$(INSTALL) -m 0755 -D $(@D)/tzdump $(HOST_DIR)/sbin/tzdump
endef

$(eval $(host-generic-package))

TZDUMP = $(HOST_DIR)/sbin/tzdump
