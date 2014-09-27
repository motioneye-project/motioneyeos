################################################################################
#
# heimdal
#
################################################################################

HEIMDAL_VERSION = 1.5.3
HEIMDAL_SITE = http://www.h5l.org/dist/src
HEIMDAL_DEPENDENCIES = host-e2fsprogs host-pkgconf
HEIMDAL_INSTALL_STAGING = YES
# static because of -fPIC issues with e2fsprogs on x86_64 host
HOST_HEIMDAL_CONF_OPTS = --with-x=no --disable-shared --enable-static
HOST_HEIMDAL_CONF_ENV = MAKEINFO=true
HEIMDAL_MAKE = $(MAKE1)
# For heimdal-0004-compile_et.patch
HEIMDAL_AUTORECONF = YES
HEIMDAL_LICENSE = BSD-3c
HEIMDAL_LICENSE_FILES = LICENSE

# We need asn1_compile in the PATH for samba4
define HOST_HEIMDAL_MAKE_SYMLINK
	ln -sf $(HOST_DIR)/usr/libexec/heimdal/asn1_compile \
		$(HOST_DIR)/usr/bin/asn1_compile
	ln -sf $(HOST_DIR)/usr/bin/compile_et \
		$(HOST_DIR)/usr/libexec/heimdal/compile_et
endef

HOST_HEIMDAL_POST_INSTALL_HOOKS += HOST_HEIMDAL_MAKE_SYMLINK

$(eval $(host-autotools-package))
