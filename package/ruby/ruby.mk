################################################################################
#
# ruby
#
################################################################################

RUBY_VERSION_MAJOR = 1.9
RUBY_VERSION = $(RUBY_VERSION_MAJOR).3-p484
RUBY_SITE = ftp://ftp.ruby-lang.org/pub/ruby/$(RUBY_VERSION_MAJOR)
RUBY_DEPENDENCIES = host-pkgconf host-ruby
HOST_RUBY_DEPENDENCIES = host-pkgconf
RUBY_MAKE_ENV = $(TARGET_MAKE_ENV)
RUBY_MAKE = $(MAKE1)
RUBY_CONF_OPT = --disable-install-doc --disable-rpath
HOST_RUBY_CONF_OPT = --disable-install-doc --with-out-ext=curses,readline
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

# Force optionals to build before we do
ifeq ($(BR2_PACKAGE_BERKELEYDB),y)
	RUBY_DEPENDENCIES += berkeleydb
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

$(eval $(autotools-package))
$(eval $(host-autotools-package))
