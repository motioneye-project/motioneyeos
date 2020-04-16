################################################################################
#
# python-treq
#
################################################################################

PYTHON_TREQ_VERSION = 20.3.0
PYTHON_TREQ_SOURCE = treq-$(PYTHON_TREQ_VERSION).tar.gz
PYTHON_TREQ_SITE = https://files.pythonhosted.org/packages/98/09/25064d7224efde9fd51e8865353d516c53306e476eab27ab21fb258cf7d4
PYTHON_TREQ_LICENSE = MIT
PYTHON_TREQ_LICENSE_FILES = LICENSE
PYTHON_TREQ_SETUP_TYPE = setuptools
PYTHON_TREQ_DEPENDENCIES = host-python-incremental

$(eval $(python-package))
