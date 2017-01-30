################################################################################
#
# git-crypt
#
################################################################################

GIT_CRYPT_VERSION = 0.5.0
GIT_CRYPT_SITE = https://www.agwa.name/projects/git-crypt/downloads
GIT_CRYPT_DEPENDENCIES = host-pkgconf openssl
GIT_CRYPT_LICENSE = GPLv3+, MIT
GIT_CRYPT_LICENSE_FILES = COPYING parse_options.hpp

GIT_CRYPT_LIBS = `$(PKG_CONFIG_HOST_BINARY) --libs openssl`

define GIT_CRYPT_BUILD_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) -C $(@D) $(TARGET_CONFIGURE_OPTS) \
		LDFLAGS="$(TARGET_LDFLAGS) $(GIT_CRYPT_LIBS)" PREFIX=/usr
endef

define GIT_CRYPT_INSTALL_TARGET_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) -C $(@D) DESTDIR=$(TARGET_DIR) \
		PREFIX=/usr install
endef

$(eval $(generic-package))
