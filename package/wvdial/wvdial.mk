################################################################################
#
# wvdial
#
################################################################################

WVDIAL_VERSION = 1.61
WVDIAL_SITE = http://wvdial.googlecode.com/files
WVDIAL_SOURCE = wvdial-$(WVDIAL_VERSION).tar.bz2
WVDIAL_DEPENDENCIES = wvstreams

WVDIAL_LICENSE = LGPLv2
WVDIAL_LICENSE_FILES = COPYING.LIB

# N.B. parallel make fails
WVDIAL_MAKE = $(MAKE1)

WVDIAL_MAKE_ENV += $(TARGET_CONFIGURE_OPTS) \
	WVSTREAMS_INC="$(STAGING_DIR)/usr/include" \
	WVSTREAMS_LIB="$(STAGING_DIR)/usr/lib"

define WVDIAL_BUILD_CMDS
	$(TARGET_MAKE_ENV) $(WVDIAL_MAKE_ENV) $(WVDIAL_MAKE) -C $(@D)
endef

define WVDIAL_INSTALL_TARGET_CMDS
	$(TARGET_MAKE_ENV) $(WVDIAL_MAKE_ENV) $(WVDIAL_MAKE) \
		prefix="$(TARGET_DIR)/usr" PPPDIR="$(TARGET_DIR)/etc/ppp/peers" \
		install -C $(@D)
endef

define WVDIAL_UNINSTALL_TARGET_CMDS
	$(TARGET_MAKE_ENV) $(WVDIAL_MAKE_ENV) $(WVDIAL_MAKE) \
		prefix="$(TARGET_DIR)/usr" PPPDIR="$(TARGET_DIR)/etc/ppp/peers" \
		uninstall -C $(@D)
endef

define WVDIAL_CLEAN_CMDS
	$(TARGET_MAKE_ENV) $(WVDIAL_MAKE_ENV) $(WVDIAL_MAKE) clean -C $(@D)
endef

$(eval $(generic-package))
