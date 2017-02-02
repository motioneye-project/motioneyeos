################################################################################
#
# sepolgen
#
################################################################################

SEPOLGEN_VERSION = 2.6
SEPOLGEN_SITE = https://raw.githubusercontent.com/wiki/SELinuxProject/selinux/files/releases/20161014
SEPOLGEN_LICENSE = GPL-2.0
SEPOLGEN_LICENSE_FILES = COPYING

ifeq ($(BR2_PACKAGE_PYTHON3),y)
SEPOLGEN_DEPENDENCIES = python3
SEPOLGEN_MAKE_CMDS = $(TARGET_CONFIGURE_OPTS) \
	PYTHONLIBDIR=/usr/lib/python$(PYTHON3_VERSION_MAJOR)/site-packages
else
SEPOLGEN_DEPENDENCIES = python
SEPOLGEN_MAKE_CMDS = $(TARGET_CONFIGURE_OPTS) \
	PYTHONLIBDIR=/usr/lib/python$(PYTHON_VERSION_MAJOR)/site-packages
endif

define SEPOLGEN_BUILD_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) -C $(@D) $(TARGET_SEPOLGEN_MAKE_CMDS) DESTDIR=$(TARGET_DIR)
endef

define SEPOLGEN_INSTALL_TARGET_CMDS
	$(MAKE_ENV) $(MAKE) -C $(@D) $(SEPOLGEN_MAKE_CMDS) DESTDIR=$(TARGET_DIR) install
endef

ifeq ($(BR2_PACKAGE_PYTHON3),y)
HOST_SEPOLGEN_DEPENDENCIES = host-python3
HOST_SEPOLGEN_MAKE_CMDS = $(HOST_CONFIGURE_OPTS) \
	PYTHONLIBDIR=/usr/lib/python$(PYTHON3_VERSION_MAJOR)/site-packages
else
HOST_SEPOLGEN_DEPENDENCIES = host-python
HOST_SEPOLGEN_MAKE_CMDS = $(HOST_CONFIGURE_OPTS) \
	PYTHONLIBDIR=/usr/lib/python$(PYTHON_VERSION_MAJOR)/site-packages
endif

define HOST_SEPOLGEN_BUILD_CMDS
	$(HOST_MAKE_ENV) $(MAKE) -C $(@D) $(HOST_SEPOLGEN_MAKE_CMDS) DESTDIR=$(HOST_DIR)
endef

define HOST_SEPOLGEN_INSTALL_CMDS
	$(HOST_MAKE_ENV) $(MAKE) -C $(@D) $(HOST_SEPOLGEN_MAKE_CMDS) DESTDIR=$(HOST_DIR) install
endef

$(eval $(generic-package))
$(eval $(host-generic-package))
