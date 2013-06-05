################################################################################
#
# qtuio
#
################################################################################

QTUIO_VERSION = abe4973ff6
QTUIO_SITE = git://github.com/x29a/qTUIO.git
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
		(cd $(@D)/examples/$${example} && $(QT_QMAKE)) ; \
	done
endef
endif

define QTUIO_CONFIGURE_CMDS
	cd $(@D)/src && $(QT_QMAKE)
	$(QTUIO_CONFIGURE_EXAMPLES)
endef

ifeq ($(BR2_QTUIO_EXAMPLES),y)
define QTUIO_BUILD_EXAMPLES
	for example in $(QTUIO_EXAMPLES) ; do \
		($(MAKE) -C $(@D)/examples/$${example}) ; \
	done
endef
endif

define QTUIO_BUILD_CMDS
	$(MAKE) -C $(@D)/src
	$(QTUIO_BUILD_EXAMPLES)
endef

# Unfortunately, there is no working "install" target available
ifeq ($(BR2_QTUIO_EXAMPLES),y)
define QTUIO_INSTALL_EXAMPLES
	for example in $(QTUIO_EXAMPLES) ; do \
		($(INSTALL) -D -m 0755 $(@D)/examples/$${example}/$${example} $(TARGET_DIR)/usr/share/qtuio/$${example}) ; \
	done
endef
endif

define QTUIO_INSTALL_TARGET_CMDS
	cp -dpf $(@D)/lib/libqTUIO.so* $(TARGET_DIR)/usr/lib
	$(QTUIO_INSTALL_EXAMPLES)
endef

define QTUIO_INSTALL_STAGING_CMDS
	cp -dpf $(@D)/lib/libqTUIO.so* $(STAGING_DIR)/usr/lib
endef

define QTUIO_CLEAN_CMDS
	$(MAKE) -C $(@D)/src clean
	for example in $(QTUIO_EXAMPLES) ; do \
		($(MAKE) -C $(@D)/examples/$${example} clean) ; \
	done
endef

$(eval $(generic-package))
