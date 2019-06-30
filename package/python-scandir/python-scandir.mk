################################################################################
#
# python-scandir
#
################################################################################

PYTHON_SCANDIR_VERSION = 1.10.0
PYTHON_SCANDIR_SOURCE = scandir-$(PYTHON_SCANDIR_VERSION).tar.gz
PYTHON_SCANDIR_SITE = https://files.pythonhosted.org/packages/df/f5/9c052db7bd54d0cbf1bc0bb6554362bba1012d03e5888950a4f5c5dadc4e
PYTHON_SCANDIR_LICENSE = BSD-3-Clause
PYTHON_SCANDIR_LICENSE_FILES = LICENSE.txt
PYTHON_SCANDIR_SETUP_TYPE = setuptools

$(eval $(python-package))
