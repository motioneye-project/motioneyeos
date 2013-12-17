################################################################################
#
# mdadm
#
################################################################################

MDADM_VERSION = 3.3
MDADM_SOURCE = mdadm-$(MDADM_VERSION).tar.xz
MDADM_SITE = $(BR2_KERNEL_MIRROR)/linux/utils/raid/mdadm
MDADM_LICENSE = GPLv2+
MDADM_LICENSE_FILES = COPYING

MDADM_MAKE_OPT = \
	CFLAGS="$(TARGET_CFLAGS)" CC="$(TARGET_CC)" CHECK_RUN_DIR=0 -C $(MDADM_DIR) mdadm

MDADM_INSTALL_TARGET_OPT = \
	DESTDIR=$(TARGET_DIR)/usr -C $(MDADM_DIR) install-mdadm

define MDADM_CONFIGURE_CMDS
	# Do nothing
endef

$(eval $(autotools-package))
