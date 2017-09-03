################################################################################
#
# stella
#
################################################################################

STELLA_VERSION = 5.0.2
STELLA_SOURCE = stella-$(STELLA_VERSION)-src.tar.xz
STELLA_SITE = https://github.com/stella-emu/stella/releases/download/$(STELLA_VERSION)
STELLA_LICENSE = GPL-2.0+
STELLA_LICENSE_FILES = Copyright.txt License.txt

STELLA_DEPENDENCIES = sdl2 libpng zlib

STELLA_CONF_OPTS = \
	--host=$(GNU_TARGET_NAME) \
	--prefix=/usr \
	--with-sdl-prefix=$(STAGING_DIR)/usr

# The configure script is not autoconf based, so we use the
# generic-package infrastructure
define STELLA_CONFIGURE_CMDS
	(cd $(@D); \
		$(TARGET_CONFIGURE_OPTS) \
		$(TARGET_CONFIGURE_ARGS) \
		./configure $(STELLA_CONF_OPTS) \
	)
endef

define STELLA_BUILD_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) -C $(@D)
endef

define STELLA_INSTALL_TARGET_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) DESTDIR="$(TARGET_DIR)" -C $(@D) install
endef

$(eval $(generic-package))
