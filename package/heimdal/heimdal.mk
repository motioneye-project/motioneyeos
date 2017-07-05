################################################################################
#
# heimdal
#
################################################################################

HEIMDAL_VERSION = 7.1.0
HEIMDAL_SITE = http://www.h5l.org/dist/src
HOST_HEIMDAL_DEPENDENCIES = host-e2fsprogs host-ncurses host-pkgconf
HEIMDAL_INSTALL_STAGING = YES
HEIMDAL_MAKE = $(MAKE1)
# static because of -fPIC issues with e2fsprogs on x86_64 host
HOST_HEIMDAL_CONF_OPTS = \
	--disable-shared \
	--enable-static \
	--without-openldap \
	--without-capng \
	--without-sqlite3 \
	--without-libintl \
	--without-openssl \
	--without-berkeley-db \
	--without-readline \
	--without-libedit \
	--without-hesiod \
	--without-x \
	--disable-heimdal-documentation
HOST_HEIMDAL_CONF_ENV = MAKEINFO=true
HEIMDAL_LICENSE = BSD-3-Clause
HEIMDAL_LICENSE_FILES = LICENSE

# We need asn1_compile in the PATH for samba4
define HOST_HEIMDAL_MAKE_SYMLINK
	ln -sf $(HOST_DIR)/libexec/heimdal/asn1_compile \
		$(HOST_DIR)/bin/asn1_compile
	ln -sf $(HOST_DIR)/bin/compile_et \
		$(HOST_DIR)/libexec/heimdal/compile_et
endef

HOST_HEIMDAL_POST_INSTALL_HOOKS += HOST_HEIMDAL_MAKE_SYMLINK

$(eval $(host-autotools-package))
