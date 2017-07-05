################################################################################
#
# python-setuptools
#
################################################################################

PYTHON_SETUPTOOLS_VERSION = v36.0.1
PYTHON_SETUPTOOLS_SITE = $(call github,pypa,setuptools,$(PYTHON_SETUPTOOLS_VERSION))
PYTHON_SETUPTOOLS_LICENSE = MIT
PYTHON_SETUPTOOLS_LICENSE_FILES = LICENSE
PYTHON_SETUPTOOLS_SETUP_TYPE = setuptools

# recent setuptools versions require bootstrap.py to be invoked
# before the standard setup process.
define PYTHON_SETUPTOOLS_RUN_BOOTSTRAP
	cd  $(@D) && $(HOST_DIR)/bin/python ./bootstrap.py
endef

PYTHON_SETUPTOOLS_PRE_CONFIGURE_HOOKS = PYTHON_SETUPTOOLS_RUN_BOOTSTRAP
HOST_PYTHON_SETUPTOOLS_PRE_CONFIGURE_HOOKS = PYTHON_SETUPTOOLS_RUN_BOOTSTRAP

$(eval $(python-package))
$(eval $(host-python-package))
