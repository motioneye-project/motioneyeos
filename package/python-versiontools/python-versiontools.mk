################################################################################
#
# python-versiontools
#
################################################################################

PYTHON_VERSIONTOOLS_VERSION = 1.9.1
PYTHON_VERSIONTOOLS_SOURCE = versiontools-$(PYTHON_VERSIONTOOLS_VERSION).tar.gz
PYTHON_VERSIONTOOLS_SITE = http://pypi.python.org/packages/source/v/versiontools
PYTHON_VERSIONTOOLS_SETUP_TYPE = setuptools
PYTHON_VERSIONTOOLS_LICENSE = LGPL-3.0

$(eval $(python-package))
$(eval $(host-python-package))
