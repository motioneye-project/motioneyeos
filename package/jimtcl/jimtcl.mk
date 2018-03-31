################################################################################
#
# jimtcl
#
################################################################################

JIMTCL_VERSION = 0.75
JIMTCL_SITE = http://snapshot.debian.org/archive/debian/20141023T043132Z/pool/main/j/jimtcl
JIMTCL_SOURCE = jimtcl_$(JIMTCL_VERSION).orig.tar.xz
JIMTCL_INSTALL_STAGING = YES
JIMTCL_LICENSE = BSD-2-Clause
JIMTCL_LICENSE_FILES = LICENSE

JIMTCL_HEADERS_TO_INSTALL = \
	jim.h \
	jim-eventloop.h \
	jim-signal.h \
	jim-subcmd.h \
	jim-win32compat.h \
	jim-config.h

ifeq ($(BR2_PACKAGE_TCL),)
define JIMTCL_LINK_TCLSH
	ln -sf jimsh $(TARGET_DIR)/usr/bin/tclsh
endef
endif

ifeq ($(BR2_STATIC_LIBS),y)
define JIMTCL_INSTALL_LIB
	$(INSTALL) -m 0644 -D $(@D)/libjim.a $(1)/usr/lib/libjim.a
endef
else
JIMTCL_SHARED = --shared
define JIMTCL_INSTALL_LIB
	$(INSTALL) -m 0755 -D $(@D)/libjim.so.$(JIMTCL_VERSION) \
		$(1)/usr/lib/libjim.so.$(JIMTCL_VERSION)
	ln -sf libjim.so.$(JIMTCL_VERSION) $(1)/usr/lib/libjim.so
endef
endif

# build system doesn't use autotools, but does use an old version of
# gnuconfig which doesn't know all the architectures supported by
# Buildroot, so update config.guess / config.sub like we do in
# pkg-autotools.mk
JIMTCL_POST_PATCH_HOOKS += UPDATE_CONFIG_HOOK

# jimtcl really wants to find a existing $CXX, so feed it false
# when we do not have one.
define JIMTCL_CONFIGURE_CMDS
	(cd $(@D); \
		$(TARGET_CONFIGURE_OPTS) \
		CCACHE=none \
		$(if $(BR2_INSTALL_LIBSTDCPP),,CXX=false) \
		./configure --prefix=/usr \
		--host=$(GNU_TARGET_NAME) \
		--build=$(GNU_HOST_NAME) \
		$(JIMTCL_SHARED) \
	)
endef

# -fPIC is mandatory to build shared libraries on certain architectures
# (e.g. SPARC) and causes no harm or drawbacks on other architectures
define JIMTCL_BUILD_CMDS
	SH_CFLAGS="-fPIC" \
	SHOBJ_CFLAGS="-fPIC" \
	$(TARGET_MAKE_ENV) $(MAKE) -C $(@D)
endef

define JIMTCL_INSTALL_STAGING_CMDS
	for i in $(JIMTCL_HEADERS_TO_INSTALL); do \
		cp -a $(@D)/$$i $(STAGING_DIR)/usr/include/ || exit 1 ; \
	done; \
	$(call JIMTCL_INSTALL_LIB,$(STAGING_DIR))
endef

define JIMTCL_INSTALL_TARGET_CMDS
	$(INSTALL) -D $(@D)/jimsh $(TARGET_DIR)/usr/bin/jimsh
	$(call JIMTCL_INSTALL_LIB,$(TARGET_DIR))
	$(JIMTCL_LINK_TCLSH)
endef

$(eval $(generic-package))
