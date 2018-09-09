################################################################################
#
# python-pyroute2
#
################################################################################

PYTHON_PYROUTE2_VERSION = 0.5.2
PYTHON_PYROUTE2_SOURCE = pyroute2-$(PYTHON_PYROUTE2_VERSION).tar.gz
PYTHON_PYROUTE2_SITE = https://files.pythonhosted.org/packages/18/64/33858f79b0f2b44a0af7bb42eda3d477253de5311dae1eb12b966085909f
PYTHON_PYROUTE2_LICENSE = Apache-2.0 or GPL-2.0+
PYTHON_PYROUTE2_LICENSE_FILES = LICENSE.Apache.v2 LICENSE.GPL.v2 README.license.md
PYTHON_PYROUTE2_SETUP_TYPE = distutils

$(eval $(python-package))
