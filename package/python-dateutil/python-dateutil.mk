################################################################################
#
# python-dateutil
#
################################################################################

PYTHON_DATEUTIL_VERSION = 2.7.3
PYTHON_DATEUTIL_SITE = https://files.pythonhosted.org/packages/a0/b0/a4e3241d2dee665fea11baec21389aec6886655cd4db7647ddf96c3fad15
PYTHON_DATEUTIL_SETUP_TYPE = setuptools
PYTHON_DATEUTIL_LICENSE = BSD-3-Clause
PYTHON_DATEUTIL_LICENSE_FILES = LICENSE
PYTHON_DATEUTIL_DEPENDENCIES = host-python-setuptools-scm

$(eval $(python-package))
