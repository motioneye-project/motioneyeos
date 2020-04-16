################################################################################
#
# openrc
#
################################################################################

OPENRC_VERSION = 0.42.1
OPENRC_SITE = $(call github,OpenRC,openrc,$(OPENRC_VERSION))
OPENRC_LICENSE = BSD-2-Clause
OPENRC_LICENSE_FILES = LICENSE

OPENRC_DEPENDENCIES = ncurses

# set LIBNAME so openrc puts files in proper directories and sets proper
# paths in installed files. Since in buildroot /lib64 and /lib32 always
# points to /lib, it's safe to hardcode it to "lib"
OPENRC_MAKE_OPTS = \
	LIBNAME=lib \
	LIBEXECDIR=/usr/libexec/rc \
	MKPKGCONFIG=no \
	MKSYSVINIT=yes \
	BRANDING="Buildroot $(BR2_VERSION_FULL)" \
	CC=$(TARGET_CC)

ifeq ($(BR2_SHARED_LIBS),y)
OPENRC_MAKE_OPTS += MKSTATICLIBS=no
else
OPENRC_MAKE_OPTS += MKSTATICLIBS=yes
endif

ifeq ($(BR2_PACKAGE_LIBSELINUX),y)
OPENRC_MAKE_OPTS += MKSELINUX=yes
OPENRC_DEPENDENCIES += libselinux
else
OPENRC_MAKE_OPTS += MKSELINUX=no
endif

define OPENRC_BUILD_CMDS
	$(MAKE) $(OPENRC_MAKE_OPTS) -C $(@D)
endef

define OPENRC_INSTALL_TARGET_CMDS
	$(MAKE) $(OPENRC_MAKE_OPTS) DESTDIR=$(TARGET_DIR) -C $(@D) install
	$(INSTALL) -D -m 0755 $(OPENRC_PKGDIR)/sysv-rcs \
		$(TARGET_DIR)/etc/init.d/sysv-rcs
endef

ifeq ($(BR2_PACKAGE_KBD),)
# keymaps and save-keymaps require kbd_mode and dumpkeys, respectively, so
# remove them if the kbd package is not selected (e.g. devices with serial
# console, only).
define OPENRC_NO_KBD
	$(RM) $(TARGET_DIR)/etc/runlevels/boot/{keymaps,save-keymaps}
	$(RM) $(TARGET_DIR)/etc/init.d/{keymaps,save-keymaps}
	$(RM) $(TARGET_DIR)/etc/conf.d/keymaps
endef
OPENRC_POST_INSTALL_TARGET_HOOKS += OPENRC_NO_KBD
endif

ifeq ($(BR2_PACKAGE_NETIFRC),y)
# netifrc replaces network, staticroute and loopback services which are
# installed by openrc
define OPENRC_NO_NET
	$(RM) $(TARGET_DIR)/etc/runlevels/boot/{network,staticroute,loopback}
	$(RM) $(TARGET_DIR)/etc/init.d/{network,staticroute,loopback}
	$(RM) $(TARGET_DIR)/etc/conf.d/{network,staticroute,loopback}
endef
OPENRC_POST_INSTALL_TARGET_HOOKS += OPENRC_NO_NET
endif

define OPENRC_REMOVE_UNNEEDED
	$(RM) -r $(TARGET_DIR)/usr/share/openrc
endef
OPENRC_TARGET_FINALIZE_HOOKS += OPENRC_REMOVE_UNNEEDED

ifeq ($(BR2_TARGET_GENERIC_GETTY),y)
OPENRC_GETTY_SVCNAME = agetty.$(SYSTEM_GETTY_PORT)
OPENRC_GETTY_CONF_D = $(TARGET_DIR)/etc/conf.d/$(OPENRC_GETTY_SVCNAME)
define OPENRC_SET_GETTY
	{ \
		echo "baud=\"$(SYSTEM_GETTY_BAUDRATE)\""; \
		echo "term_type=\"$(SYSTEM_GETTY_TERM)\"" ; \
		echo "agetty_options=\"-L $(SYSTEM_GETTY_OPTIONS)\""; \
	} > $(OPENRC_GETTY_CONF_D)
	ln -sf agetty $(TARGET_DIR)/etc/init.d/$(OPENRC_GETTY_SVCNAME)
	ln -sf /etc/init.d/$(OPENRC_GETTY_SVCNAME) \
		$(TARGET_DIR)/etc/runlevels/default/$(OPENRC_GETTY_SVCNAME)
endef
OPENRC_TARGET_FINALIZE_HOOKS += OPENRC_SET_GETTY
endif # BR2_TARGET_GENERIC_GETTY

$(eval $(generic-package))
