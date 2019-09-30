################################################################################
#
# python-yieldfrom
#
################################################################################

PYTHON_YIELDFROM_VERSION = 1.0.4
PYTHON_YIELDFROM_SOURCE = yieldfrom-$(PYTHON_YIELDFROM_VERSION).tar.gz
PYTHON_YIELDFROM_SITE = https://files.pythonhosted.org/packages/6e/d2/dc48e4cc6bbe48afd022da745f981cf0437ab7e658de9078bf56747b1d73
PYTHON_YIELDFROM_SETUP_TYPE = setuptools
PYTHON_YIELDFROM_LICENSE = MIT
PYTHON_YIELDFROM_LICENSE_FILES = LICENSE

$(eval $(python-package))
$(eval $(host-python-package))
