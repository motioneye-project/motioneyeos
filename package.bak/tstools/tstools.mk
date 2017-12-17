################################################################################
#
# tstools
#
################################################################################

# No releases or tags yet. Use the latest commit ID from master branch.
TSTOOLS_VERSION = 08f6be304040e7b84760ac3920bcff4a563b6cd2
TSTOOLS_SITE = $(call github,kynesim,tstools,$(TSTOOLS_VERSION))
# tstools upstream doesn't contain any license file so far. See:
# https://github.com/kynesim/tstools/issues/32
TSTOOLS_LICENSE = MPLv1.1
TSTOOLS_LICENSE_FILES =

define TSTOOLS_BUILD_CMDS
	$(TARGET_CONFIGURE_OPTS) LD="$(TARGET_CC)" $(TARGET_MAKE_ENV) \
		$(MAKE1) -C $(@D)
endef

define TSTOOLS_INSTALL_TARGET_CMDS
	$(TARGET_CONFIGURE_OPTS) $(TARGET_MAKE_ENV) $(MAKE) -C $(@D) \
		DESTDIR=$(TARGET_DIR) install
endef

$(eval $(generic-package))
