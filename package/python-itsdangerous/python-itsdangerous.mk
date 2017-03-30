################################################################################
#
# python-itsdangerous
#
################################################################################

PYTHON_ITSDANGEROUS_VERSION = 0.24
PYTHON_ITSDANGEROUS_SITE = $(call github,mitsuhiko,itsdangerous,$(PYTHON_ITSDANGEROUS_VERSION))
PYTHON_ITSDANGEROUS_SETUP_TYPE = setuptools
PYTHON_ITSDANGEROUS_LICENSE = BSD-3-Clause
PYTHON_ITSDANGEROUS_LICENSE_FILES = LICENSE

$(eval $(python-package))
