################################################################################
#
# znc
#
################################################################################

ZNC_VERSION = b396cafdb249544164ed02942a5babba59e519a3
ZNC_SITE = $(call github,znc,znc,$(ZNC_VERSION))
ZNC_LICENSE = Apache-2.0
ZNC_LICENSE_FILES = LICENSE
ZNC_DEPENDENCIES = host-pkgconf host-autoconf host-automake
ZNC_CONF_OPTS = --disable-perl

# The standard <pkg>_AUTORECONF = YES invocation doesn't work for this
# package, because it does not use automake in a normal way.
define ZNC_RUN_AUTOGEN
	cd $(@D) && PATH=$(BR_PATH) ./autogen.sh
endef
ZNC_PRE_CONFIGURE_HOOKS += ZNC_RUN_AUTOGEN

ifeq ($(BR2_PACKAGE_ICU),y)
ZNC_DEPENDENCIES += icu
ZNC_CONF_OPTS += --enable-icu
else
ZNC_CONF_OPTS += --disable-icu
endif

ifeq ($(BR2_PACKAGE_OPENSSL),y)
ZNC_DEPENDENCIES += openssl
ZNC_CONF_OPTS += --enable-openssl
else
ZNC_CONF_OPTS += --disable-openssl
endif

ifeq ($(BR2_PACKAGE_ZLIB),y)
ZNC_DEPENDENCIES += zlib
ZNC_CONF_OPTS += --enable-zlib
else
ZNC_CONF_OPTS += --disable-zlib
endif

ifeq ($(BR2_PACKAGE_PYTHON3),y)
ZNC_DEPENDENCIES += python3 host-swig
ZNC_CONF_OPTS += --enable-python=python3
else
ZNC_CONF_OPTS += --disable-python
endif

$(eval $(autotools-package))
