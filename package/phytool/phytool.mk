################################################################################
#
# phytool
#
################################################################################

PHYTOOL_VERSION = 1.0.1
PHYTOOL_SOURCE = phytool-$(PHYTOOL_VERSION).tar.xz
PHYTOOL_SITE = https://github.com/wkz/phytool/releases/download/v$(PHYTOOL_VERSION)
PHYTOOL_LICENSE = GPL-2.0+
PHYTOOL_LICENSE_FILES = LICENSE

define PHYTOOL_BUILD_CMDS
	$(TARGET_MAKE_ENV) $(TARGET_CONFIGURE_OPTS) $(MAKE) -C $(@D) \
		LDLIBS="$(TARGET_LDFLAGS)"
endef

define PHYTOOL_INSTALL_TARGET_CMDS
	$(TARGET_MAKE_ENV) $(TARGET_CONFIGURE_OPTS) $(MAKE) -C $(@D) \
		DESTDIR="$(TARGET_DIR)" \
		PREFIX="usr" install
endef

$(eval $(generic-package))
