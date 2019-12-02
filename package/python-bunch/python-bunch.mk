################################################################################
#
# python-bunch
#
################################################################################

PYTHON_BUNCH_VERSION = 1.0.1
PYTHON_BUNCH_SOURCE = bunch-$(PYTHON_BUNCH_VERSION).tar.gz
PYTHON_BUNCH_SITE = https://files.pythonhosted.org/packages/ef/bf/a4cf1779a4ffb4f610903fa08e15d1f4a8a2f4e3353a02afbe097c5bf4a8
PYTHON_BUNCH_SETUP_TYPE = setuptools
PYTHON_BUNCH_LICENSE = MIT
PYTHON_BUNCH_LICENSE_FILES = LICENSE.txt

$(eval $(python-package))
