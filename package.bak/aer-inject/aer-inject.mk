################################################################################
#
# aer-inject
#
################################################################################

AER_INJECT_VERSION = 9bd5e2c7886fca72f139cd8402488a2235957d41
AER_INJECT_SITE = git://git.kernel.org/pub/scm/linux/kernel/git/gong.chen/aer-inject.git
AER_INJECT_LICENSE = GPL-2.0
AER_INJECT_LICENSE_FILES = README
AER_INJECT_DEPENDENCIES = host-flex host-bison

define AER_INJECT_BUILD_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) -C $(@D) $(TARGET_CONFIGURE_OPTS)
endef

define AER_INJECT_INSTALL_TARGET_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) -C $(@D) $(TARGET_CONFIGURE_OPTS) \
		DESTDIR=$(TARGET_DIR) PREFIX=/usr/bin install
endef

$(eval $(generic-package))
