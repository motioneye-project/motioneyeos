################################################################################
#
# faifa
#
################################################################################

FAIFA_VERSION = v0.1
FAIFA_SITE = $(call github,ffainelli,faifa,$(FAIFA_VERSION))
FAIFA_INSTALL_STAGING = YES
FAIFA_DEPENDENCIES = libpcap host-autoconf
FAIFA_LICENSE = BSD-3c
FAIFA_LICENSE_FILES = COPYING

FAIFA_MAKE_OPT += GIT_REV=$(FAIFA_VERSION)

# This package uses autoconf, but not automake, so we need to call
# their special autogen.sh script, and have custom target and staging
# installation commands.

define FAIFA_RUN_AUTOGEN
	cd $(@D) && PATH=$(BR_PATH) ./autogen.sh
endef
FAIFA_PRE_CONFIGURE_HOOKS += FAIFA_RUN_AUTOGEN

define FAIFA_INSTALL_TARGET_CMDS
	$(TARGET_CONFIGURE_OPTS) $(MAKE) -C $(@D) \
		PREFIX=/usr \
		STRIP=/bin/true \
		DESTDIR=$(TARGET_DIR) \
		install
endef

define FAIFA_INSTALL_STAGING_CMDS
	$(TARGET_CONFIGURE_OPTS) $(MAKE) -C $(@D) \
		PREFIX=/usr \
		STRIP=/bin/true \
		DESTDIR=$(STAGING_DIR) \
		install
endef

$(eval $(autotools-package))
