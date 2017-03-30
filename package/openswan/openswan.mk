################################################################################
#
# openswan
#
################################################################################

OPENSWAN_VERSION = 2.6.46
OPENSWAN_SITE = http://download.openswan.org/openswan
OPENSWAN_LICENSE = GPL-2.0+, BSD-3-Clause
OPENSWAN_LICENSE_FILES = COPYING LICENSE

OPENSWAN_DEPENDENCIES = host-bison host-flex gmp iproute2
OPENSWAN_MAKE_OPTS = ARCH=$(BR2_ARCH) CC="$(TARGET_CC)" \
	USERCOMPILE="$(TARGET_CFLAGS) $(if $(BR2_TOOLCHAIN_SUPPORTS_PIE),-fPIE)" \
	USERLINK="$(TARGET_LDFLAGS) $(if $(BR2_TOOLCHAIN_SUPPORTS_PIE),-fPIE)" \
	INC_USRLOCAL=/usr USE_KLIPS=false USE_MAST=false USE_NM=false

ifeq ($(BR2_PACKAGE_LIBCURL),y)
OPENSWAN_DEPENDENCIES += libcurl
OPENSWAN_MAKE_OPTS += USE_LIBCURL=true
endif

ifeq ($(BR2_PACKAGE_OPENSSL),y)
OPENSWAN_DEPENDENCIES += openssl
OPENSWAN_MAKE_OPTS += HAVE_OPENSSL=true
ifeq ($(BR2_PACKAGE_OCF_LINUX),y)
OPENSWAN_MAKE_OPTS += HAVE_OCF=true
endif
endif

define OPENSWAN_BUILD_CMDS
	$(TARGET_MAKE_ENV) $(MAKE1) -C $(@D) \
		$(OPENSWAN_MAKE_OPTS) programs
endef

define OPENSWAN_INSTALL_TARGET_CMDS
	$(TARGET_MAKE_ENV) $(MAKE1) -C $(@D) \
		$(OPENSWAN_MAKE_OPTS) DESTDIR=$(TARGET_DIR) install
endef

$(eval $(generic-package))
