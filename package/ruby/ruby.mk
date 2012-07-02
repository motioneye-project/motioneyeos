#############################################################
#
# ruby
#
#############################################################

RUBY_VERSION = 1.9.2-p320
RUBY_SITE = ftp://ftp.ruby-lang.org/pub/ruby/1.9
RUBY_AUTORECONF = YES
HOST_RUBY_AUTORECONF = YES
RUBY_DEPENDENCIES = host-ruby
HOST_RUBY_DEPENDENCIES =
RUBY_MAKE_ENV = $(TARGET_MAKE_ENV)
RUBY_CONF_OPT = --disable-install-doc --disable-rpath
HOST_RUBY_CONF_OPT = --disable-install-doc --with-out-ext=curses,readline

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
