################################################################################
#
# ddrescue
#
################################################################################

DDRESCUE_VERSION = 1.25
DDRESCUE_SOURCE = ddrescue-$(DDRESCUE_VERSION).tar.lz
DDRESCUE_SITE = http://download.savannah.gnu.org/releases/ddrescue
DDRESCUE_LICENSE = GPL-2.0+
DDRESCUE_LICENSE_FILES = COPYING

define DDRESCUE_CONFIGURE_CMDS
	(cd $(@D); \
		$(TARGET_MAKE_ENV) ./configure \
		--prefix=/usr \
		$(TARGET_CONFIGURE_OPTS) \
	)
endef

DDRESCUE_CXXFLAGS = $(TARGET_CXXFLAGS)

ifeq ($(BR2_TOOLCHAIN_HAS_GCC_BUG_85180),y)
DDRESCUE_CXXFLAGS += -O0
endif

define DDRESCUE_BUILD_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) CXXFLAGS="$(DDRESCUE_CXXFLAGS)" -C $(@D)
endef

define DDRESCUE_INSTALL_TARGET_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) -C $(@D) DESTDIR="$(TARGET_DIR)" install
endef

$(eval $(generic-package))
