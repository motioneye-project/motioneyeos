################################################################################
#
# canfestival
#
################################################################################

# Revision 791:
CANFESTIVAL_VERSION = 7740ac6fdedc
CANFESTIVAL_SOURCE = $(CANFESTIVAL_VERSION).tar.bz2
CANFESTIVAL_SITE = http://dev.automforge.net/CanFestival-3/archive
CANFESTIVAL_LICENSE = LGPLv2.1+
CANFESTIVAL_LICENSE_FILES = COPYING LICENCE
CANFESTIVAL_INSTALL_STAGING = YES
CANFESTIVAL_INSTALLED-y = src drivers
CANFESTIVAL_INSTALLED-$(BR2_PACKAGE_CANFESTIVAL_INSTALL_EXAMPLES) += examples

# Canfestival provides and used some python modules and scripts only compliant
# with python2.
CANFESTIVAL_DEPENDENCIES = host-python

# canfestival uses its own hand-written build-system. Though there is
# a configure script, it does not use the autotools, so, we use the
# generic-package infrastructure.
define CANFESTIVAL_CONFIGURE_CMDS
	cd $(@D) && \
		$(TARGET_CONFIGURE_OPTS) ./configure \
		--target=unix \
		--arch=$(BR2_ARCH) \
		--timers=unix \
		--binutils=$(TARGET_CROSS) \
		--cc="$(TARGET_CC)" \
		--cxx="$(TARGET_CC)" \
		--ld="$(TARGET_CC)" \
		--prefix=/usr \
		--can=$(BR2_PACKAGE_CANFESTIVAL_DRIVER) \
		$(call qstrip,$(BR2_PACKAGE_CANFESTIVAL_ADDITIONAL_OPTIONS))
endef

define CANFESTIVAL_BUILD_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) -C $(@D) all \
		PYTHON=$(HOST_DIR)/usr/bin/python2
endef

define CANFESTIVAL_INSTALL_TARGET_CMDS
	for d in $(CANFESTIVAL_INSTALLED-y) ; do \
		$(TARGET_MAKE_ENV) $(MAKE) -C $(@D)/$$d install \
			PYTHON=$(HOST_DIR)/usr/bin/python2 \
			DESTDIR=$(TARGET_DIR) || exit 1 ; \
	done
endef

define CANFESTIVAL_INSTALL_STAGING_CMDS
	for d in $(CANFESTIVAL_INSTALLED-y) ; do \
		$(TARGET_MAKE_ENV) $(MAKE) -C $(@D)/$$d install \
			PYTHON=$(HOST_DIR)/usr/bin/python2 \
			DESTDIR=$(STAGING_DIR) || exit 1 ; \
	done
endef

$(eval $(generic-package))
