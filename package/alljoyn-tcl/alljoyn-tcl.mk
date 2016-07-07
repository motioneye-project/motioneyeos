################################################################################
#
# alljoyn-tcl
#
################################################################################

ALLJOYN_TCL_REV = 16.04
ALLJOYN_TCL_VERSION = $(ALLJOYN_TCL_REV).00
ALLJOYN_TCL_SOURCE = ajtcl-$(ALLJOYN_TCL_VERSION)-src.tar.gz
ALLJOYN_TCL_SITE = \
	https://mirrors.kernel.org/allseenalliance/alljoyn/$(ALLJOYN_TCL_REV)
# See https://allseenalliance.org/alliance/ip-policy
ALLJOYN_TCL_LICENSE = ISC

ALLJOYN_TCL_DEPENDENCIES = host-scons
ALLJOYN_TCL_INSTALL_STAGING = YES

# AllJoyn Thin Core can be compiled in debug or release mode. By default,
# AllJoyn Thin Core is built in debug mode.
ALLJOYN_TCL_VARIANT = release

ALLJOYN_TCL_SCONS_OPTS = \
	-j$(PARALLEL_JOBS) \
	V=1 \
	VARIANT=$(ALLJOYN_TCL_VARIANT) \
	CC="$(TARGET_CC)" \
	CXX="$(TARGET_CXX)"

define ALLJOYN_TCL_BUILD_CMDS
	cd $(@D); $(SCONS) $(ALLJOYN_TCL_SCONS_OPTS)
endef

define ALLJOYN_TCL_INSTALL_STAGING_CMDS
	cp -a $(@D)/dist/lib/lib* $(STAGING_DIR)/usr/lib/
	cp -a $(@D)/dist/include/* $(STAGING_DIR)/usr/include/
endef

# Only install AllJoyn Thin Core dynamic libraries into target directory
define ALLJOYN_TCL_INSTALL_TARGET_CMDS
	cp -a $(@D)/dist/lib/lib*.so* $(TARGET_DIR)/usr/lib/
endef

$(eval $(generic-package))
