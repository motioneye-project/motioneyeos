################################################################################
#
# alljoyn
#
################################################################################

ALLJOYN_REV = 16.04
ALLJOYN_VERSION = $(ALLJOYN_REV).00a
ALLJOYN_SOURCE = alljoyn-$(ALLJOYN_VERSION)-src.tar.gz
ALLJOYN_SITE = https://mirrors.kernel.org/allseenalliance/alljoyn/$(ALLJOYN_REV)
# See https://allseenalliance.org/alliance/ip-policy
ALLJOYN_LICENSE = ISC

ALLJOYN_DEPENDENCIES = host-scons libcap
ALLJOYN_INSTALL_STAGING = YES

# AllJoyn can be compiled in debug or release mode. By default, AllJoyn is built
# in debug mode.
ALLJOYN_VARIANT = release

ALLJOYN_BINDINGS = c,cpp

# By setting openwrt for OS and CPU, AllJoyn cross-compilation can be finely
# tuned through TARGET_xxx options. All TARGET_xxx variables must be defined
# otherwise compilation will fail.
# CROSS_COMPILE option should not be used as it works only for linux/ARM.
ALLJOYN_OS = openwrt
ALLJOYN_CPU = openwrt

# AllJoyn installs everything in this relative path
ALLJOYN_DISTDIR = build/$(ALLJOYN_OS)/$(ALLJOYN_CPU)/$(ALLJOYN_VARIANT)/dist/

ALLJOYN_SCONS_OPTS = \
	-j$(PARALLEL_JOBS) \
	V=1 \
	OS=$(ALLJOYN_OS) \
	CPU=$(ALLJOYN_CPU) \
	VARIANT=$(ALLJOYN_VARIANT) \
	BR=off \
	CRYPTO=builtin \
	BINDINGS=$(ALLJOYN_BINDINGS) \
	TARGET_CFLAGS="$(TARGET_CFLAGS)" \
	TARGET_CPPFLAGS="$(TARGET_CPPFLAGS)" \
	TARGET_LINKFLAGS="$(TARGET_LINKFLAGS)" \
	TARGET_CC="$(TARGET_CC)" \
	TARGET_CXX="$(TARGET_CXX)" \
	TARGET_LD="$(TARGET_LD)" \
	TARGET_LINK="$(TARGET_CXX)" \
	TARGET_AR="$(TARGET_AR)" \
	TARGET_RANLIB="$(TARGET_RANLIB)" \
	TARGET_PATH="$(BR_PATH)"

define ALLJOYN_BUILD_CMDS
	cd $(@D); $(SCONS) $(ALLJOYN_SCONS_OPTS)
endef

define ALLJOYN_INSTALL_STAGING_CMDS
	cp -a $(@D)/$(ALLJOYN_DISTDIR)/*/lib/lib* $(STAGING_DIR)/usr/lib/
	cp -a $(@D)/$(ALLJOYN_DISTDIR)/*/inc/* $(STAGING_DIR)/usr/include/
endef

# Only install alljoyn dynamic libraries into target directory
define ALLJOYN_INSTALL_TARGET_CMDS
	cp -a $(@D)/$(ALLJOYN_DISTDIR)/*/lib/lib*.so* $(TARGET_DIR)/usr/lib/
endef

$(eval $(generic-package))
