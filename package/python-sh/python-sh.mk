################################################################################
#
# python-sh
#
################################################################################

PYTHON_SH_VERSION = 1.12.9
PYTHON_SH_SOURCE = sh-$(PYTHON_SH_VERSION).tar.gz
PYTHON_SH_SITE = https://pypi.python.org/packages/fd/14/6deb4e89cc237ee4bc1c0b0485c77d7868477f96c47962366bc5fabc31fd
PYTHON_SH_SETUP_TYPE = setuptools
PYTHON_SH_LICENSE = MIT
PYTHON_SH_LICENSE_FILES = LICENSE.txt

$(eval $(python-package))
