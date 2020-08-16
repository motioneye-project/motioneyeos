################################################################################
#
# python-pytablereader
#
################################################################################

PYTHON_PYTABLEREADER_VERSION = 0.26.1
PYTHON_PYTABLEREADER_SOURCE = pytablereader-$(PYTHON_PYTABLEREADER_VERSION).tar.gz
PYTHON_PYTABLEREADER_SITE = https://files.pythonhosted.org/packages/1e/bc/f60da8a733cd87215d8533f28536f8149eca3b898bbca346b37b6c915d8d
PYTHON_PYTABLEREADER_SETUP_TYPE = setuptools
PYTHON_PYTABLEREADER_LICENSE = MIT
PYTHON_PYTABLEREADER_LICENSE_FILES = LICENSE

$(eval $(python-package))
