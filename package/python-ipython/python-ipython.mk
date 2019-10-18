################################################################################
#
# python-ipython
#
################################################################################

PYTHON_IPYTHON_VERSION = 7.8.0
PYTHON_IPYTHON_SOURCE = ipython-$(PYTHON_IPYTHON_VERSION).tar.gz
PYTHON_IPYTHON_SITE = https://files.pythonhosted.org/packages/89/60/acb98588d8eba96558e69d90fa54f9908b4e48f6492ff378697f0c2216e2
PYTHON_IPYTHON_LICENSE = BSD-3-Clause
PYTHON_IPYTHON_LICENSE_FILES = COPYING.rst LICENSE
PYTHON_IPYTHON_SETUP_TYPE = distutils

$(eval $(python-package))
