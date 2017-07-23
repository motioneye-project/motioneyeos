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
		RUNDIR="/usr/lib/paxtest" CC="$(TARGET_CC)" LD="$(TARGET_CC)" linux
endef

# The files installed to RUNDIR include test apps and shared libs.
# Assuming /usr/bin/paxtest script solely uses these libs and apps, the
# genpaxtest script updates LD_LIBRARY_PATH in the paxtest script
# as part of the paxtest's creation to include the RUNDIR path for shared
# library use.
define PAXTEST_INSTALL_TARGET_CMDS
	$(TARGET_MAKE_ENV) $(TARGET_CONFIGURE_OPTS) $(MAKE) -C $(@D) \
		CC="$(TARGET_CC)" LD="$(TARGET_CC)" \
		DESTDIR=$(TARGET_DIR) \
		BINDIR="usr/bin" \
		RUNDIR="/usr/lib/paxtest" -f Makefile.psm install
endef

$(eval $(generic-package))
