################################################################################
#
# rng-tools
#
################################################################################

RNG_TOOLS_VERSION = 6.9
RNG_TOOLS_SITE = $(call github,nhorman,$(RNG_TOOLS_NAME),v$(RNG_TOOLS_VERSION))
RNG_TOOLS_LICENSE = GPL-2.0
RNG_TOOLS_LICENSE_FILES = COPYING
RNG_TOOLS_DEPENDENCIES = libsysfs jitterentropy-library host-pkgconf
# From git
RNG_TOOLS_AUTORECONF = YES

RNG_TOOLS_CONF_OPTS = \
	--without-nistbeacon \
	--without-pkcs11

# Work around for uClibc or musl toolchains which lack argp_*()
# functions.
ifeq ($(BR2_PACKAGE_ARGP_STANDALONE),y)
RNG_TOOLS_CONF_ENV += LIBS="-largp"
RNG_TOOLS_DEPENDENCIES += argp-standalone
endif

ifeq ($(BR2_PACKAGE_LIBGCRYPT),y)
RNG_TOOLS_DEPENDENCIES += libgcrypt
else
RNG_TOOLS_CONF_OPTS += --without-libgcrypt
endif

define RNG_TOOLS_INSTALL_INIT_SYSV
	$(INSTALL) -D -m 755 package/rng-tools/S21rngd \
		$(TARGET_DIR)/etc/init.d/S21rngd
endef

define RNG_TOOLS_INSTALL_INIT_SYSTEMD
	$(INSTALL) -D -m 644 package/rng-tools/rngd.service \
		$(TARGET_DIR)/usr/lib/systemd/system/rngd.service
endef

$(eval $(autotools-package))
