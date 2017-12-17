################################################################################
#
# python-pytablereader
#
################################################################################

PYTHON_PYTABLEREADER_VERSION = 0.13.3
PYTHON_PYTABLEREADER_SOURCE = pytablereader-$(PYTHON_PYTABLEREADER_VERSION).tar.gz
PYTHON_PYTABLEREADER_SITE = https://pypi.python.org/packages/c3/47/550949034950f43d3db3b60b94aa8ee60d548d9f657612d816ad4420f24b
PYTHON_PYTABLEREADER_SETUP_TYPE = setuptools
PYTHON_PYTABLEREADER_LICENSE = MIT
PYTHON_PYTABLEREADER_LICENSE_FILES = LICENSE

$(eval $(python-package))
