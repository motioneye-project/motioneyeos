################################################################################
#
# python-markupsafe
#
################################################################################

PYTHON_MARKUPSAFE_VERSION = 0.23
PYTHON_MARKUPSAFE_SOURCE = MarkupSafe-$(PYTHON_MARKUPSAFE_VERSION).tar.gz
PYTHON_MARKUPSAFE_SITE = http://pypi.python.org/packages/source/M/MarkupSafe
PYTHON_MARKUPSAFE_SETUP_TYPE = setuptools
PYTHON_MARKUPSAFE_LICENSE = BSD-3c
PYTHON_MARKUPSAFE_LICENSE_FILES = LICENSE

$(eval $(python-package))
$(eval $(host-python-package))
