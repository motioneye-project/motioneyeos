################################################################################
#
# python-fastentrypoints
#
################################################################################

PYTHON_FASTENTRYPOINTS_VERSION = 0.12
PYTHON_FASTENTRYPOINTS_SOURCE = fastentrypoints-$(PYTHON_FASTENTRYPOINTS_VERSION).tar.gz
PYTHON_FASTENTRYPOINTS_SITE = https://files.pythonhosted.org/packages/56/59/69d9ae590ca39435d409651314ec13b2abe8127c1db0231c01d034ebb6b0
PYTHON_FASTENTRYPOINTS_SETUP_TYPE = setuptools
PYTHON_FASTENTRYPOINTS_LICENSE = BSD-2-Clause
PYTHON_FASTENTRYPOINTS_LICENSE_FILES = fastentrypoints.py

$(eval $(host-python-package))
