################################################################################
#
# jimtcl
#
################################################################################

JIMTCL_VERSION = 0.75
JIMTCL_SITE = http://snapshot.debian.org/archive/debian/20141023T043132Z/pool/main/j/jimtcl
JIMTCL_SOURCE = jimtcl_$(JIMTCL_VERSION).orig.tar.xz
JIMTCL_INSTALL_STAGING = YES
JIMTCL_LICENSE = BSD-2c
JIMTCL_LICENSE_FILES = LICENSE

JIMTCL_HEADERS_TO_INSTALL = \
	jim.h \
	jim-eventloop.h \
	jim-signal.h \
	jim-subcmd.h \
	jim-win32compat.h \
	jim-config.h \

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

define JIMTCL_CONFIGURE_CMDS
	(cd $(@D); \
		$(TARGET_CONFIGURE_OPTS) CCACHE=none \
		./configure --prefix=/usr \
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
