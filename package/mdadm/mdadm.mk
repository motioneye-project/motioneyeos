#############################################################
#
# mdadm
#
#############################################################
MDADM_VERSION:=2.6.9
MDADM_SOURCE:=mdadm-$(MDADM_VERSION).tar.bz2
MDADM_SITE:=http://www.kernel.org/pub/linux/utils/raid/mdadm

MDADM_MAKE_OPT = \
	CFLAGS="$(TARGET_CFLAGS)" CC="$(TARGET_CC)" -C $(MDADM_DIR) mdadm

MDADM_INSTALL_TARGET_OPT = \
	DESTDIR=$(TARGET_DIR)/usr -C $(MDADM_DIR) install-mdadm

MDADM_UNINSTALL_TARGET_OPT = \
	DESTDIR=$(TARGET_DIR)/usr -C $(MDADM_DIR) uninstall

define MDADM_CONFIGURE_CMDS
	# Do nothing
endef

$(eval $(autotools-package))
