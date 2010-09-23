#############################################################
#
# iproute2
#
#############################################################

IPROUTE2_VERSION = 2.6.35
IPROUTE2_SOURCE = iproute2-$(IPROUTE2_VERSION).tar.bz2
IPROUTE2_SITE = http://devresources.linuxfoundation.org/dev/iproute2/download
IPROUTE2_TARGET_SBINS = ctstat genl ifstat ip lnstat nstat routef routel rtacct rtmon rtpr rtstat ss tc

define IPROUTE2_CONFIGURE_CMDS
	# Use kernel headers
	rm -r $(IPROUTE2_DIR)/include/netinet
	# arpd needs berkeleydb
	$(SED) "/^TARGETS=/s: arpd : :" $(IPROUTE2_DIR)/misc/Makefile
	$(SED) "s:-O2:$(TARGET_CFLAGS):" $(IPROUTE2_DIR)/Makefile
	( cd $(@D); ./configure )
	echo "IPT_LIB_DIR=/usr/lib/xtables" >>$(IPROUTE2_DIR)/Config
endef

define IPROUTE2_BUILD_CMDS
	$(MAKE) CC="$(TARGET_CC)" -C $(@D)
endef

define IPROUTE2_INSTALL_TARGET_CMDS
	$(MAKE) -C $(@D) DESTDIR="$(TARGET_DIR)" SBINDIR=/sbin \
		DOCDIR=/usr/share/doc/iproute2-$(IPROUTE2_VERSION) \
		MANDIR=/usr/share/man install
	# Wants bash
	rm -f $(TARGET_DIR)/sbin/ifcfg
endef

define IPROUTE2_UNINSTALL_TARGET_CMDS
	rm -rf $(TARGET_DIR)/lib/tc
	rm -rf $(TARGET_DIR)/usr/lib/tc
	rm -rf $(TARGET_DIR)/etc/iproute2
	rm -rf $(TARGET_DIR)/var/lib/arpd
	rm -f $(addprefix $(TARGET_DIR)/sbin/, $(IPROUTE2_TARGET_SBINS))
endef

$(eval $(call GENTARGETS,package,iproute2))
