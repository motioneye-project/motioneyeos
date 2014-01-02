################################################################################
#
# thrift
#
################################################################################

THRIFT_VERSION = 0.9.1
THRIFT_SITE = http://www.us.apache.org/dist/thrift/$(THRIFT_VERSION)
THRIFT_DEPENDENCIES = host-pkgconf host-thrift boost libevent openssl zlib
THRIFT_INSTALL_STAGING = YES
HOST_THRIFT_DEPENDENCIES = host-boost host-libevent host-openssl host-pkgconf \
	host-zlib
THRIFT_CONF_OPT = --with-sysroot=$(STAGING_DIR) --with-tests=no \
	--with-boost=$(STAGING_DIR)
HOST_THRIFT_CONF_OPT = --with-sysroot=$(HOST_DIR) --with-tests=no
THRIFT_AUTORECONF = YES
THRIFT_LICENSE = Apache-2.0
THRIFT_LICENSE_FILES = LICENSE

ifeq ($(BR2_PREFER_STATIC_LIB),y)
# openssl uses zlib, so we need to explicitly link with it when static
THRIFT_CONF_ENV += LIBS=-lz
endif

# Language selection
# The generator (host tool) works with all of them regardless
# This is just for the libraries / bindings
THRIFT_LANG_CONF_OPT += --without-csharp --without-java --without-erlang \
	--without-python --without-perl --without-php --without-php_extension \
	--without-ruby --without-haskell --without-go --without-d --without-qt4
HOST_THRIFT_CONF_OPT += $(THRIFT_LANG_CONF_OPT) --without-c_glib
THRIFT_CONF_OPT += $(THRIFT_LANG_CONF_OPT)

# C bindings
ifeq ($(BR2_PACKAGE_LIBGLIB2),y)
THRIFT_DEPENDENCIES += libglib2
else
THRIFT_CONF_OPT += --without-c_glib
endif

# De-hardcode THRIFT for cross compiling
define THRIFT_TOOL_NO_HARDCODE
	for f in `find $(@D) -name Makefile.am -type f`; do \
		$(SED) "/^THRIFT =/d" $$f; \
	done
	$(SED) "s:top_builddir)/compiler/cpp/thrift:THRIFT):" $(@D)/tutorial/Makefile.am
endef

THRIFT_POST_PATCH_HOOKS += THRIFT_TOOL_NO_HARDCODE

define THRIFT_BUILD_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) THRIFT=$(HOST_DIR)/usr/bin/thrift -C $(@D)
endef

# Install runtime only
define THRIFT_INSTALL_TARGET_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) -C $(@D)/lib DESTDIR=$(TARGET_DIR) install
endef

$(eval $(autotools-package))
$(eval $(host-autotools-package))

# to be used by other packages
THRIFT = $(HOST_DIR)/usr/bin/thrift
