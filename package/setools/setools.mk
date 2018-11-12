################################################################################
#
# setools
#
################################################################################

SETOOLS_VERSION = 4.1.1
SETOOLS_SITE = $(call github,TresysTechnology,setools,$(SETOOLS_VERSION))
SETOOLS_DEPENDENCIES = libselinux libsepol python-setuptools host-bison host-flex host-swig
SETOOLS_INSTALL_STAGING = YES
SETOOLS_LICENSE = GPL-2.0+, LGPL-2.1+
SETOOLS_LICENSE_FILES = COPYING COPYING.GPL COPYING.LGPL
SETOOLS_SETUP_TYPE = setuptools
HOST_SETOOLS_DEPENDENCIES = host-libselinux host-libsepol host-python-networkx

ifeq ($(BR2_PACKAGE_PYTHON3),y)
SETOOLS_PYLIBVER = python$(PYTHON3_VERSION_MAJOR)
else
SETOOLS_PYLIBVER = python$(PYTHON_VERSION_MAJOR)
SETOOLS_DEPENDENCIES += python-enum34
HOST_SETOOLS_DEPENDENCIES += host-python-enum34
endif

define SETOOLS_FIX_SETUP
	# By default, setup.py will look for libsepol.a in the host machines
	# /usr/lib directory. This needs to be changed to the staging directory.
	$(SED) "s@base_lib_dirs =.*@base_lib_dirs = ['$(STAGING_DIR)/usr/lib']@g" \
		$(@D)/setup.py
endef
SETOOLS_POST_PATCH_HOOKS += SETOOLS_FIX_SETUP

define HOST_SETOOLS_FIX_SETUP
	# By default, setup.py will look for libsepol.a in the host machines
	# /usr/lib directory. This needs to be changed to the host directory.
	$(SED) "s@base_lib_dirs =.*@base_lib_dirs = ['$(HOST_DIR)/lib']@g" \
		$(@D)/setup.py
endef
HOST_SETOOLS_POST_PATCH_HOOKS += HOST_SETOOLS_FIX_SETUP

# apol requires pyqt5. However, the setools installation
# process will install apol even if pyqt5 is missing.
# Remove these scripts from the target it pyqt5 is not selected.
ifeq ($(BR2_PACKAGE_PYTHON_PYQT5),)
define SETOOLS_REMOVE_QT_SCRIPTS
	$(RM) $(TARGET_DIR)/usr/bin/apol
	$(RM) -r $(TARGET_DIR)/lib/$(SETOOLS_PYLIBVER)/site-packages/setoolsgui/
endef
SETOOLS_POST_INSTALL_TARGET_HOOKS += SETOOLS_REMOVE_QT_SCRIPTS
endif

# pyqt5 is not a host-package, remove apol from the host directory.
define HOST_SETOOLS_REMOVE_BROKEN_SCRIPTS
	$(RM) $(HOST_DIR)/bin/apol
endef
HOST_SETOOLS_POST_INSTALL_HOOKS += HOST_SETOOLS_REMOVE_BROKEN_SCRIPTS

$(eval $(python-package))
$(eval $(host-python-package))
