################################################################################
#
# sepolgen
#
################################################################################

SEPOLGEN_VERSION = 1.1.9
SEPOLGEN_SITE = https://raw.githubusercontent.com/wiki/SELinuxProject/selinux/files/releases/20130423
SEPOLGEN_LICENSE = GPLv2
SEPOLGEN_LICENSE_FILES = COPYING

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
	$(MAKE) -C $(@D) $(HOST_SEPOLGEN_MAKE_CMDS) DESTDIR=$(HOST_DIR)
endef

define HOST_SEPOLGEN_INSTALL_CMDS
	$(MAKE) -C $(@D) $(HOST_SEPOLGEN_MAKE_CMDS) DESTDIR=$(HOST_DIR) install
endef

$(eval $(host-generic-package))
