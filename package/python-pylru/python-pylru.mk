################################################################################
#
# python-pylru
#
################################################################################

PYTHON_PYLRU_VERSION = 1.2.0
PYTHON_PYLRU_SOURCE = pylru-$(PYTHON_PYLRU_VERSION).tar.gz
PYTHON_PYLRU_SITE = https://files.pythonhosted.org/packages/9c/88/30972cd0518452563221c80bffc2a5832499d736648ef8fe492affae15c5
PYTHON_PYLRU_SETUP_TYPE = setuptools
PYTHON_PYLRU_LICENSE = GPL-2.0
PYTHON_PYLRU_LICENSE_FILES = LICENSE.txt

$(eval $(python-package))
