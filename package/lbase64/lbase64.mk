################################################################################
#
# lbase64
#
################################################################################

LBASE64_VERSION = 20100323
LBASE64_SITE = http://www.tecgraf.puc-rio.br/~lhf/ftp/lua/5.1
LBASE64_SOURCE = lbase64.tar.gz
LBASE64_LICENSE = Public domain
LBASE64_LICENSE_FILES = README
LBASE64_DEPENDENCIES = lua

define LBASE64_BUILD_CMDS
       $(MAKE) -C $(@D) $(TARGET_CONFIGURE_OPTS) \
		CFLAGS="$(TARGET_CFLAGS) -fPIC" so
endef

define LBASE64_INSTALL_TARGET_CMDS
       $(INSTALL) -D -m 0755 $(@D)/base64.so \
		$(TARGET_DIR)/usr/lib/lua/base64.so
endef

define LBASE64_UNINSTALL_TARGET_CMDS
       rm -f $(TARGET_DIR)/usr/lib/lua/base64.so
endef

define LBASE64_CLEAN_CMDS
       $(MAKE) -C $(@D) clean
endef

$(eval $(generic-package))
