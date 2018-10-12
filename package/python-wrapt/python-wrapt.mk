################################################################################
#
# python-wrapt
#
################################################################################

PYTHON_WRAPT_VERSION = 1.10.11
PYTHON_WRAPT_SOURCE = wrapt-$(PYTHON_WRAPT_VERSION).tar.gz
PYTHON_WRAPT_SITE = https://files.pythonhosted.org/packages/a0/47/66897906448185fcb77fc3c2b1bc20ed0ecca81a0f2f88eda3fc5a34fc3d
PYTHON_WRAPT_SETUP_TYPE = distutils
PYTHON_WRAPT_LICENSE = BSD-2-Clause
PYTHON_WRAPT_LICENSE_FILES = LICENSE

$(eval $(python-package))
