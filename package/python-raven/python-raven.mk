################################################################################
#
# python-raven
#
################################################################################

PYTHON_RAVEN_VERSION = 6.3.0
PYTHON_RAVEN_SOURCE = raven-$(PYTHON_RAVEN_VERSION).tar.gz
PYTHON_RAVEN_SITE = https://pypi.python.org/packages/e8/b0/27886f69cdb4d9f6265bba1c4973bb5371b060272a5795c511d8839a6028
PYTHON_RAVEN_SETUP_TYPE = setuptools
PYTHON_RAVEN_LICENSE = BSD-3-Clause
PYTHON_RAVEN_LICENSE_FILES = LICENSE

$(eval $(python-package))
