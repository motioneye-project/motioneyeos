################################################################################
#
# python-scandir
#
################################################################################

PYTHON_SCANDIR_VERSION = 1.9.0
PYTHON_SCANDIR_SOURCE = scandir-$(PYTHON_SCANDIR_VERSION).tar.gz
PYTHON_SCANDIR_SITE = https://files.pythonhosted.org/packages/16/2a/557af1181e6b4e30254d5a6163b18f5053791ca66e251e77ab08887e8fe3
PYTHON_SCANDIR_LICENSE = BSD-3-Clause
PYTHON_SCANDIR_LICENSE_FILES = LICENSE.txt
PYTHON_SCANDIR_SETUP_TYPE = setuptools

$(eval $(python-package))
