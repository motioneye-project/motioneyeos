################################################################################
#
# libuv
#
################################################################################

LIBUV_VERSION = v0.11.26
LIBUV_SITE = $(call github,joyent,libuv,$(LIBUV_VERSION))
LIBUV_DEPENDENCIES = host-pkgconf
LIBUV_INSTALL_STAGING = YES
LIBUV_AUTORECONF = YES
LIBUV_LICENSE = BSD-2c, BSD-3c, ISC, MIT
LIBUV_LICENSE_FILES = LICENSE

# Upstream needs tests to be run sequentially. This is the default in
# automake 1.11 and before, but not starting in 1.12. To maintain
# sequentiality in 1.12 and later, the automake option 'serial-tests'
# must be used, Unfortunately, it is not recognised by 1.11 and
# before. So upstream only adds it conditionally. We use automake
# 1.14, so we need it.
define LIBUV_FIXUP_AUTOGEN
	echo "m4_define([UV_EXTRA_AUTOMAKE_FLAGS], [serial-tests])" \
	        >$(@D)/m4/libuv-extra-automake-flags.m4
endef
LIBUV_POST_PATCH_HOOKS += LIBUV_FIXUP_AUTOGEN

$(eval $(autotools-package))
