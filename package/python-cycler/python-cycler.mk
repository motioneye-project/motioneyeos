################################################################################
#
# python-cycler
#
################################################################################

PYTHON_CYCLER_VERSION = 0.10.0
PYTHON_CYCLER_SOURCE = cycler-$(PYTHON_CYCLER_VERSION).tar.gz
PYTHON_CYCLER_SITE = https://files.pythonhosted.org/packages/c2/4b/137dea450d6e1e3d474e1d873cd1d4f7d3beed7e0dc973b06e8e10d32488
PYTHON_CYCLER_LICENSE = BSD
PYTHON_CYCLER_LICENSE_FILES = LICENSE
PYTHON_CYCLER_SETUP_TYPE = setuptools

$(eval $(python-package))
