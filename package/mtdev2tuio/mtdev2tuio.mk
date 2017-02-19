################################################################################
#
# mtdev2tuio
#
################################################################################

MTDEV2TUIO_VERSION = e1e7378d86abe751158e743586133022f32fa4d1
MTDEV2TUIO_SITE = $(call github,olivopaolo,mtdev2tuio,$(MTDEV2TUIO_VERSION))
MTDEV2TUIO_DEPENDENCIES = mtdev liblo
MTDEV2TUIO_LICENSE = GPLv3+
MTDEV2TUIO_LICENSE_FILES = COPYING

# mtdev2tuio Makefile misuses $(LD) as gcc, so we need to override LD
# here. Liblo uses log(3), so we need to link with -lm
define MTDEV2TUIO_BUILD_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) \
		$(TARGET_CONFIGURE_OPTS) \
		LD="$(TARGET_CC)" \
		LIBS="-lmtdev -llo -lm" \
		-C $(@D)
endef

define MTDEV2TUIO_INSTALL_TARGET_CMDS
	$(INSTALL) -D -m 0755 $(@D)/mtdev2tuio $(TARGET_DIR)/usr/bin/mtdev2tuio
endef

$(eval $(generic-package))
