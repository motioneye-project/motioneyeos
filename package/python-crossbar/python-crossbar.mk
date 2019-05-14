################################################################################
#
# python-crossbar
#
################################################################################

PYTHON_CROSSBAR_VERSION = 19.1.2
PYTHON_CROSSBAR_SOURCE = crossbar-$(PYTHON_CROSSBAR_VERSION).tar.gz
PYTHON_CROSSBAR_SITE = https://files.pythonhosted.org/packages/86/19/54c7bd9da1ac70643b9ae7d3d4592a73391f62fcb376fcd30f8328c1c5ce
PYTHON_CROSSBAR_LICENSE = AGPL-3.0
PYTHON_CROSSBAR_LICENSE_FILES = LICENSE
PYTHON_CROSSBAR_SETUP_TYPE = setuptools

$(eval $(python-package))
