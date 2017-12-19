################################################################################
#
# rng-tools
#
################################################################################

RNG_TOOLS_VERSION = 5
RNG_TOOLS_SITE = http://downloads.sourceforge.net/project/gkernel/rng-tools/$(RNG_TOOLS_VERSION)
RNG_TOOLS_LICENSE = GPL-2.0
RNG_TOOLS_LICENSE_FILES = COPYING

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
	mkdir -p $(TARGET_DIR)/etc/systemd/system/multi-user.target.wants
	ln -fs ../../../../usr/lib/systemd/system/rngd.service \
		$(TARGET_DIR)/etc/systemd/system/multi-user.target.wants/rngd.service
endef

$(eval $(autotools-package))
