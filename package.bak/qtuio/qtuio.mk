################################################################################
#
# qtuio
#
################################################################################

QTUIO_VERSION = abe4973ff60654aad9df7037c4ca15c45f811d24
QTUIO_SITE = $(call github,x29a,qTUIO,$(QTUIO_VERSION))
QTUIO_INSTALL_STAGING = YES
QTUIO_DEPENDENCIES = qt

QTUIO_LICENSE = GPLv3+
QTUIO_LICENSE_FILES = COPYING

# The pong example needs QtOpenGL support, which might become available
# some time in the future. Then add pong to the list of examples.
QTUIO_EXAMPLES = dials fingerpaint knobs pinchzoom

ifeq ($(BR2_QTUIO_EXAMPLES),y)
define QTUIO_CONFIGURE_EXAMPLES
	for example in $(QTUIO_EXAMPLES) ; do \
		(cd $(@D)/examples/$${example} && $(TARGET_MAKE_ENV) $(QT_QMAKE)) || exit 1; \
	done
endef
endif

define QTUIO_CONFIGURE_CMDS
	cd $(@D)/src && $(TARGET_MAKE_ENV) $(QT_QMAKE)
	$(QTUIO_CONFIGURE_EXAMPLES)
endef

ifeq ($(BR2_QTUIO_EXAMPLES),y)
define QTUIO_BUILD_EXAMPLES
	for example in $(QTUIO_EXAMPLES) ; do \
		$(TARGET_MAKE_ENV) $(MAKE) -C $(@D)/examples/$${example} || exit 1; \
	done
endef
endif

define QTUIO_BUILD_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) -C $(@D)/src
	$(QTUIO_BUILD_EXAMPLES)
endef

# Unfortunately, there is no working "install" target available
ifeq ($(BR2_QTUIO_EXAMPLES),y)
define QTUIO_INSTALL_EXAMPLES
	for example in $(QTUIO_EXAMPLES) ; do \
		$(INSTALL) -D -m 0755 $(@D)/examples/$${example}/$${example} $(TARGET_DIR)/usr/share/qtuio/$${example} || exit 1 ; \
	done
endef
endif

ifeq ($(BR2_PACKAGE_QT_STATIC),y)
QTUIO_LIBRARY = libqTUIO.a
else
QTUIO_LIBRARY = libqTUIO.so*
define QTUIO_INSTALL_TARGET_LIBRARY
	cp -dpf $(@D)/lib/$(QTUIO_LIBRARY) $(TARGET_DIR)/usr/lib
endef
endif

define QTUIO_INSTALL_TARGET_CMDS
	$(QTUIO_INSTALL_TARGET_LIBRARY)
	$(QTUIO_INSTALL_EXAMPLES)
endef

define QTUIO_INSTALL_STAGING_CMDS
	cp -dpf $(@D)/lib/$(QTUIO_LIBRARY) $(STAGING_DIR)/usr/lib
endef

$(eval $(generic-package))
