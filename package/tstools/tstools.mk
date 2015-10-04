################################################################################
#
# tstools
#
################################################################################

TSTOOLS_VERSION = 1_11
TSTOOLS_SITE = https://tstools.googlecode.com/files
TSTOOLS_SOURCE = tstools-$(TSTOOLS_VERSION).tgz
TSTOOLS_LICENSE = MPL v1.1

define TSTOOLS_BUILD_CMDS
	$(TARGET_CONFIGURE_OPTS) LD="$(TARGET_CC)" $(TARGET_MAKE_ENV) \
		$(MAKE1) -C $(@D)
endef

define TSTOOLS_INSTALL_TARGET_CMDS
	$(TARGET_CONFIGURE_OPTS) $(TARGET_MAKE_ENV) $(MAKE) -C $(@D) \
		DESTDIR=$(TARGET_DIR) install
endef

$(eval $(generic-package))
