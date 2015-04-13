################################################################################
#
# ruby
#
################################################################################

RUBY_VERSION_MAJOR = 2.2
RUBY_VERSION = $(RUBY_VERSION_MAJOR).2
RUBY_VERSION_EXT = 2.2.0
RUBY_SITE = http://cache.ruby-lang.org/pub/ruby/$(RUBY_VERSION_MAJOR)
RUBY_SOURCE = ruby-$(RUBY_VERSION).tar.xz
RUBY_DEPENDENCIES = host-pkgconf host-ruby
HOST_RUBY_DEPENDENCIES = host-pkgconf
RUBY_MAKE_ENV = $(TARGET_MAKE_ENV)
RUBY_MAKE = $(MAKE1)
RUBY_CONF_OPTS = --disable-install-doc --disable-rpath --disable-rubygems
HOST_RUBY_CONF_OPTS = \
	--disable-install-doc \
	--with-out-ext=curses,openssl,readline \
	--without-gmp
RUBY_LICENSE = Ruby or BSD-2c, BSD-3c, others
RUBY_LICENSE_FILES = LEGAL COPYING BSDL

RUBY_CFLAGS = $(TARGET_CFLAGS)
# With some SuperH toolchains (like Sourcery CodeBench 2012.09), ruby fails to
# build with 'pcrel too far'. This seems to be caused by the -Os option we pass
# by default. To fix the problem, use standard -O2 optimization instead.
ifeq ($(BR2_sh)$(BR2_sh64),y)
RUBY_CFLAGS += -O2
endif
RUBY_CONF_ENV = CFLAGS="$(RUBY_CFLAGS)"

ifeq ($(BR2_bfin),y)
RUBY_CONF_ENV = ac_cv_func_dl_iterate_phdr=no
# Blackfin doesn't have FFI closure support, needed by the fiddle
# extension.
RUBY_CONF_OPTS += --with-out-ext=fiddle
endif

# Force optionals to build before we do
ifeq ($(BR2_PACKAGE_BERKELEYDB),y)
RUBY_DEPENDENCIES += berkeleydb
endif
ifeq ($(BR2_PACKAGE_GDBM),y)
RUBY_DEPENDENCIES += gdbm
endif
ifeq ($(BR2_PACKAGE_LIBYAML),y)
RUBY_DEPENDENCIES += libyaml
endif
ifeq ($(BR2_PACKAGE_NCURSES),y)
RUBY_DEPENDENCIES += ncurses
endif
ifeq ($(BR2_PACKAGE_OPENSSL),y)
RUBY_DEPENDENCIES += openssl
endif
ifeq ($(BR2_PACKAGE_READLINE),y)
RUBY_DEPENDENCIES += readline
endif
ifeq ($(BR2_PACKAGE_ZLIB),y)
RUBY_DEPENDENCIES += zlib
endif
ifeq ($(BR2_PACKAGE_GMP),y)
RUBY_DEPENDENCIES += gmp
RUBY_CONF_OPTS += --with-gmp
else
RUBY_CONF_OPTS += --without-gmp
endif

# workaround for amazing build failure, see
# http://lists.busybox.net/pipermail/buildroot/2014-December/114273.html
define RUBY_REMOVE_VERCONF_H
	rm -f $(@D)/verconf.h
endef
RUBY_POST_CONFIGURE_HOOKS += RUBY_REMOVE_VERCONF_H

# Remove rubygems and friends, as they need extensions that aren't
# built and a target compiler.
RUBY_EXTENSIONS_REMOVE = rake* rdoc* rubygems*
define RUBY_REMOVE_RUBYGEMS
	rm -f $(addprefix $(TARGET_DIR)/usr/bin/, gem rdoc ri rake)
	rm -rf $(TARGET_DIR)/usr/lib/ruby/gems
	rm -rf $(addprefix $(TARGET_DIR)/usr/lib/ruby/$(RUBY_VERSION_EXT)/, \
		$(RUBY_EXTENSIONS_REMOVE))
endef
RUBY_POST_INSTALL_TARGET_HOOKS += RUBY_REMOVE_RUBYGEMS

$(eval $(autotools-package))
$(eval $(host-autotools-package))
