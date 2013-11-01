################################################################################
#
# libcap
#
################################################################################

LIBCAP_VERSION = 2.22
# Until kernel.org is completely back up use debian mirror
#LIBCAP_SITE = http://www.kernel.org/pub/linux/libs/security/linux-privs/libcap2
LIBCAP_SITE = $(BR2_DEBIAN_MIRROR)/debian/pool/main/libc/libcap2
LIBCAP_SOURCE = libcap2_$(LIBCAP_VERSION).orig.tar.gz
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

ifeq ($(BR2_PREFER_STATIC_LIB),y)
LIBCAP_MAKE_TARGET = libcap.a
LIBCAP_MAKE_INSTALL_TARGET = install-static
else
LIBCAP_MAKE_TARGET = all
LIBCAP_MAKE_INSTALL_TARGET = install
endif

define LIBCAP_BUILD_CMDS
	$(TARGET_MAKE_ENV) $(TARGET_CONFIGURE_OPTS) $(MAKE) -C $(@D)/libcap \
		LIBATTR=$(LIBCAP_HAVE_LIBATTR) BUILD_CC="$(HOSTCC)" \
		BUILD_CFLAGS="$(HOST_CFLAGS)" $(LIBCAP_MAKE_TARGET)
endef

define LIBCAP_INSTALL_STAGING_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) -C $(@D)/libcap LIBATTR=$(LIBCAP_HAVE_LIBATTR) \
		DESTDIR=$(STAGING_DIR) prefix=/usr lib=lib $(LIBCAP_MAKE_INSTALL_TARGET)
endef

define LIBCAP_INSTALL_TARGET_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) -C $(@D)/libcap LIBATTR=$(LIBCAP_HAVE_LIBATTR) \
		DESTDIR=$(TARGET_DIR) prefix=/usr lib=lib $(LIBCAP_MAKE_INSTALL_TARGET)
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
