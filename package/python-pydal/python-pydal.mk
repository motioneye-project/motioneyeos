################################################################################
#
# python-pydal
#
################################################################################

PYTHON_PYDAL_VERSION = 17.1
PYTHON_PYDAL_SOURCE = pyDAL-$(PYTHON_PYDAL_VERSION).tar.gz
PYTHON_PYDAL_SITE = https://pypi.python.org/packages/64/9a/4fc08f6078b3a3019a9e33c8383bb023e064405dc5e16c273b8ec6d430cd
PYTHON_PYDAL_LICENSE = BSD-3-Clause
PYTHON_PYDAL_LICENSE_FILES = LICENSE
PYTHON_PYDAL_SETUP_TYPE = setuptools

$(eval $(python-package))
$(eval $(host-python-package))
