################################################################################
#
# paxtest
#
################################################################################

PAXTEST_VERSION = 0.9.15
PAXTEST_SITE = https://www.grsecurity.net/~spender
PAXTEST_LICENSE = GPL-2.0+
PAXTEST_LICENSE_FILES = README

define PAXTEST_BUILD_CMDS
	$(TARGET_MAKE_ENV) $(TARGET_CONFIGURE_OPTS) $(MAKE) -C $(@D) \
		CC="$(TARGET_CC)" LD="$(TARGET_CC)" linux
endef

define PAXTEST_INSTALL_TARGET_CMDS
	$(TARGET_MAKE_ENV) $(TARGET_CONFIGURE_OPTS) $(MAKE) -C $(@D) \
		CC="$(TARGET_CC)" LD="$(TARGET_CC)" \
		DESTDIR=$(TARGET_DIR) \
		BINDIR="usr/bin" \
		RUNDIR="usr/lib" -f Makefile.psm install
endef

$(eval $(generic-package))
