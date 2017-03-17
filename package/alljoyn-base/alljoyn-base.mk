################################################################################
#
# alljoyn-base
#
################################################################################

ALLJOYN_BASE_REV = 16.04
ALLJOYN_BASE_VERSION = $(ALLJOYN_BASE_REV).00
ALLJOYN_BASE_SITE = \
	https://mirrors.kernel.org/allseenalliance/alljoyn/$(ALLJOYN_BASE_REV)
# See https://allseenalliance.org/alliance/ip-policy
ALLJOYN_BASE_LICENSE = ISC

ALLJOYN_BASE_DEPENDENCIES = host-scons alljoyn openssl
ALLJOYN_BASE_INSTALL_STAGING = YES

ALLJOYN_BASE_CRYPTO = openssl

# AllJoyn can be compiled in debug or release mode. By default,
# AllJoyn is built in debug mode.
ALLJOYN_BASE_VARIANT = release

ALLJOYN_BASE_BINDINGS = c,cpp

# By setting openwrt for OS and CPU, AllJoyn cross-compilation can be finely
# tuned through TARGET_xxx options. All TARGET_xxx variables must be defined
# otherwise compilation will fail.
# CROSS_COMPILE option should not be used as it works only for linux/ARM.
ALLJOYN_BASE_OS = openwrt
ALLJOYN_BASE_CPU = openwrt

# AllJoyn install everything in this relative path
ALLJOYN_BASE_DISTDIR = \
	build/$(ALLJOYN_OS)/$(ALLJOYN_CPU)/$(ALLJOYN_VARIANT)/dist

ALLJOYN_BASE_SCONS_OPTS = \
	-j$(PARALLEL_JOBS) \
	V=1 \
	OS=$(ALLJOYN_BASE_OS) \
	CPU=$(ALLJOYN_BASE_CPU) \
	VARIANT=$(ALLJOYN_BASE_VARIANT) \
	BR=off \
	CRYPTO=$(ALLJOYN_BASE_CRYPTO) \
	BINDINGS=$(ALLJOYN_BASE_BINDINGS) \
	ALLJOYN_DISTDIR="$(STAGING_DIR)"\
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

ifeq ($(BR2_PACKAGE_ALLJOYN_BASE_CONTROLPANEL), y)
ALLJOYN_BASE_TARGETS += controlpanel
endif

ifeq ($(BR2_PACKAGE_ALLJOYN_BASE_NOTIFICATION), y)
ALLJOYN_BASE_TARGETS += notification
endif

ifeq ($(BR2_PACKAGE_ALLJOYN_BASE_ONBOARDING), y)
ALLJOYN_BASE_TARGETS += onboarding
endif

define ALLJOYN_BASE_BUILD_CMDS
	$(foreach target,$(ALLJOYN_BASE_TARGETS),\
		cd $(@D)/$(target); $(SCONS) $(ALLJOYN_BASE_SCONS_OPTS)
	)
endef

define ALLJOYN_BASE_INSTALL_STAGING_CMDS
	$(foreach target,$(ALLJOYN_BASE_TARGETS),\
		cp -a $(@D)/$(target)/$(ALLJOYN_BASE_DISTDIR)/*/lib/lib* \
			$(STAGING_DIR)/usr/lib/
		cp -a $(@D)/$(target)/$(ALLJOYN_BASE_DISTDIR)/*/inc/* \
			$(STAGING_DIR)/usr/include/
	)
endef

define ALLJOYN_BASE_INSTALL_TARGET_CMDS
	$(foreach target,$(ALLJOYN_BASE_TARGETS),\
		cp -a $(@D)/$(target)/$(ALLJOYN_BASE_DISTDIR)/*/lib/lib* \
			$(TARGET_DIR)/usr/lib/
	)
endef

$(eval $(generic-package))
