################################################################################
#
# libcap
#
################################################################################

LIBCAP_VERSION = 2.24
LIBCAP_SITE = https://www.kernel.org/pub/linux/libs/security/linux-privs/libcap2
LIBCAP_SOURCE = libcap-$(LIBCAP_VERSION).tar.xz
LIBCAP_LICENSE = GPLv2 or BSD-3c
LIBCAP_LICENSE_FILES = License

LIBCAP_DEPENDENCIES = host-libcap
LIBCAP_INSTALL_STAGING = YES

ifeq ($(BR2_PACKAGE_ATTR),y)
	LIBCAP_DEPENDENCIES += attr
	LIBCAP_HAVE_LIBATTR = yes
else
	LIBCAP_HAVE_LIBATTR = no
endif

# we don't have host-attr
HOST_LIBCAP_DEPENDENCIES =

ifeq ($(BR2_STATIC_LIBS),y)
LIBCAP_MAKE_TARGET = libcap.a
LIBCAP_MAKE_INSTALL_TARGET = install-static
else
LIBCAP_MAKE_TARGET = all
LIBCAP_MAKE_INSTALL_TARGET = install
endif

LIBCAP_MAKE_FLAGS = \
	LIBATTR=$(LIBCAP_HAVE_LIBATTR) \
	BUILD_CC="$(HOSTCC)" \
	BUILD_CFLAGS="$(HOST_CFLAGS)"

ifeq ($(BR2_PACKAGE_LIBCAP_TOOLS),y)
define LIBCAP_BUILD_TOOLS_CMDS
	$(TARGET_MAKE_ENV) $(TARGET_CONFIGURE_OPTS) $(MAKE) -C $(@D)/progs \
		$(LIBCAP_MAKE_FLAGS)
endef

define LIBCAP_INSTALL_TOOLS_CMDS
	$(TARGET_MAKE_ENV) $(TARGET_CONFIGURE_OPTS) $(MAKE) -C $(@D)/progs \
		RAISE_SETFCAP=no prefix=/usr \
		DESTDIR=$(TARGET_DIR) $(LIBCAP_MAKE_FLAGS) install
endef
endif

define LIBCAP_BUILD_CMDS
	$(TARGET_MAKE_ENV) $(TARGET_CONFIGURE_OPTS) $(MAKE) -C $(@D)/libcap \
		$(LIBCAP_MAKE_FLAGS) $(LIBCAP_MAKE_TARGET)
	$(LIBCAP_BUILD_TOOLS_CMDS)
endef

define LIBCAP_INSTALL_STAGING_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) -C $(@D)/libcap $(LIBCAP_MAKE_FLAGS) \
		DESTDIR=$(STAGING_DIR) prefix=/usr lib=lib $(LIBCAP_MAKE_INSTALL_TARGET)
endef

define LIBCAP_INSTALL_TARGET_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) -C $(@D)/libcap $(LIBCAP_MAKE_FLAGS) \
		DESTDIR=$(TARGET_DIR) prefix=/usr lib=lib $(LIBCAP_MAKE_INSTALL_TARGET)
	$(LIBCAP_INSTALL_TOOLS_CMDS)
endef

define HOST_LIBCAP_BUILD_CMDS
	$(HOST_MAKE_ENV) $(HOST_CONFIGURE_OPTS) $(MAKE) -C $(@D) LIBATTR=no
endef

define HOST_LIBCAP_INSTALL_CMDS
	$(HOST_MAKE_ENV) $(MAKE) -C $(@D) LIBATTR=no DESTDIR=$(HOST_DIR) \
		prefix=/usr lib=lib install
endef

$(eval $(generic-package))
$(eval $(host-generic-package))
