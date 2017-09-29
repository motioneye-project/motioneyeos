################################################################################
#
# lbase64
#
################################################################################

LBASE64_VERSION = 20120820
LBASE64_SITE = http://webserver2.tecgraf.puc-rio.br/~lhf/ftp/lua/5.3
LBASE64_SOURCE = lbase64.tar.gz
LBASE64_LICENSE = Public domain
LBASE64_LICENSE_FILES = README
LBASE64_DEPENDENCIES = luainterpreter

define LBASE64_BUILD_CMDS
	$(MAKE1) $(TARGET_CONFIGURE_OPTS) \
		CFLAGS="$(TARGET_CFLAGS) -fPIC" -C $(@D) so
endef

define LBASE64_INSTALL_TARGET_CMDS
	$(INSTALL) -D -m 0755 $(@D)/base64.so \
		$(TARGET_DIR)/usr/lib/lua/$(LUAINTERPRETER_ABIVER)/base64.so
endef

$(eval $(generic-package))
