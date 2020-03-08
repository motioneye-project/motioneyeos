################################################################################
#
# spidermonkey
#
################################################################################

# Use a tarball with only the spidermonkey source code and a pre-setup
# old-configure in src/js.This prevents having to use autoconf 2.13 and
# makes the package much 31M instead of 257M
SPIDERMONKEY_VERSION = 60.5.2
SPIDERMONKEY_SOURCE = mozjs-$(SPIDERMONKEY_VERSION).tar.bz2
SPIDERMONKEY_SITE = https://gentoo.osuosl.org/distfiles/9a
SPIDERMONKEY_SUBDIR = js/src
SPIDERMONKEY_LICENSE = MPL-2.0
SPIDERMONKEY_LICENSE_FILES = moz.configure
SPIDERMONKEY_INSTALL_STAGING = YES

SPIDERMONKEY_DEPENDENCIES = \
	host-python \
	libnspr \
	zlib

SPIDERMONKEY_CONF_ENV = \
	PYTHON="$(HOST_DIR)/bin/python2"

# spidermonkey mixes up target and host.
# spidermonkey does not allow building against a system jemalloc,
# as it causes a conflict with glibc.
SPIDERMONKEY_CONF_OPTS = \
	--host=$(GNU_HOST_NAME) \
	--target=$(GNU_TARGET_NAME) \
	--disable-jemalloc \
	--enable-shared-js \
	--with-system-zlib \
	--with-system-nspr \
	--with-nspr-exec-prefix="$(STAGING_DIR)/usr"

ifeq ($(BR2_PACKAGE_SPIDERMONKEY_JIT_ARCH_SUPPORTS),y)
SPIDERMONKEY_CONF_OPTS += --enable-ion
else
SPIDERMONKEY_CONF_OPTS += --disable-ion
endif

ifeq ($(BR2_PACKAGE_SPIDERMONKEY_JS_SHELL),y)
SPIDERMONKEY_CONF_OPTS += --enable-js-shell
else
SPIDERMONKEY_CONF_OPTS += --disable-js-shell
endif

ifeq ($(BR2_PACKAGE_READLINE),y)
SPIDERMONKEY_CONF_OPTS += --enable-readline
SPIDERMONKEY_DEPENDENCIES += readline
else
SPIDERMONKEY_CONF_OPTS += --disable-readline
endif

# Remove unneeded files
define SPIDERMONKEY_CLEANUP
	rm -rf $(TARGET_DIR)/usr/lib/libjs_static.ajs
	rm -rf $(TARGET_DIR)/usr/bin/js60-config
endef
SPIDERMONKEY_POST_INSTALL_TARGET_HOOKS += SPIDERMONKEY_CLEANUP

$(eval $(autotools-package))
