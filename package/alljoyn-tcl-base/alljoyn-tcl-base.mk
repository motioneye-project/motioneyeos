################################################################################
#
# alljoyn-tcl-base
#
################################################################################

ALLJOYN_TCL_BASE_REV = 16.04
ALLJOYN_TCL_BASE_VERSION = $(ALLJOYN_TCL_BASE_REV).00
ALLJOYN_TCL_BASE_SOURCE = alljoyn-base_tcl-$(ALLJOYN_TCL_BASE_VERSION).tar.gz
ALLJOYN_TCL_BASE_SITE = \
	https://mirrors.kernel.org/allseenalliance/alljoyn/$(ALLJOYN_TCL_BASE_REV)
# See https://allseenalliance.org/alliance/ip-policy
ALLJOYN_TCL_BASE_LICENSE = ISC

ALLJOYN_TCL_BASE_DEPENDENCIES = host-scons alljoyn-tcl
ALLJOYN_TCL_BASE_INSTALL_STAGING = YES

# AllJoyn Base Thin Core can be compiled in debug or release mode. By default,
# AllJoyn Base Thin Core is built in debug mode.
ALLJOYN_TCL_BASE_VARIANT = release

ALLJOYN_TCL_BASE_SCONS_OPTS = \
	-j$(PARALLEL_JOBS) \
	V=1 \
	VARIANT=$(ALLJOYN_TCL_BASE_VARIANT) \
	CC="$(TARGET_CC)" \
	CXX="$(TARGET_CXX)" \
	AJTCL_DIST=$(STAGING_DIR) \
	WS=off

define ALLJOYN_TCL_BASE_BUILD_CMDS
	cd $(@D); $(SCONS) $(ALLJOYN_TCL_BASE_SCONS_OPTS)
endef

define ALLJOYN_TCL_BASE_INSTALL_STAGING_CMDS
	cp -a $(@D)/dist/lib/lib* $(STAGING_DIR)/usr/lib/
	cp -a $(@D)/dist/include/* $(STAGING_DIR)/usr/include/
endef

# Only install AllJoyn Base Thin Core dynamic libraries into target directory
define ALLJOYN_TCL_BASE_INSTALL_TARGET_CMDS
	cp -a $(@D)/dist/lib/lib*.so* $(TARGET_DIR)/usr/lib/
endef

$(eval $(generic-package))
