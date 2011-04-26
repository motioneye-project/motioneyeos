#############################################################
#
# libcap
#
#############################################################

LIBCAP_VERSION = 2.20
LIBCAP_SITE = http://www.kernel.org/pub/linux/libs/security/linux-privs/libcap2
LIBCAP_DEPENDENCIES = host-libcap
LIBCAP_INSTALL_STAGING = YES

define LIBCAP_BUILD_CMDS
	$(TARGET_MAKE_ENV) $(TARGET_CONFIGURE_OPTS) $(MAKE) -C $(@D) \
		LIBATTR=no BUILD_CC="$(HOSTCC)" BUILD_CFLAGS="$(HOST_CFLAGS)"
endef

define LIBCAP_INSTALL_STAGING_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) -C $(@D) LIBATTR=no DESTDIR=$(STAGING_DIR) \
		prefix=/usr lib=lib install
endef

define LIBCAP_INSTALL_TARGET_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) -C $(@D) LIBATTR=no DESTDIR=$(TARGET_DIR) \
		prefix=/usr lib=lib install
	rm -f $(addprefix $(TARGET_DIR)/usr/sbin/,capsh getpcaps)
endef

define HOST_LIBCAP_BUILD_CMDS
	$(HOST_MAKE_ENV) $(HOST_CONFIGURE_OPTS) $(MAKE) -C $(@D) LIBATTR=no
endef

define HOST_LIBCAP_INSTALL_CMDS
	$(HOST_MAKE_ENV) $(MAKE) -C $(@D) LIBATTR=no DESTDIR=$(HOST_DIR) \
		prefix=/usr lib=lib install
endef

$(eval $(call GENTARGETS,package,libcap))
$(eval $(call GENTARGETS,package,libcap,host))
