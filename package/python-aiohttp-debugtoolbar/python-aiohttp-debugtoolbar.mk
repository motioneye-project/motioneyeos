################################################################################
#
# python-aiohttp-debugtoolbar
#
################################################################################

PYTHON_AIOHTTP_DEBUGTOOLBAR_VERSION = 0.6.0
PYTHON_AIOHTTP_DEBUGTOOLBAR_SOURCE = aiohttp-debugtoolbar-$(PYTHON_AIOHTTP_DEBUGTOOLBAR_VERSION).tar.gz
PYTHON_AIOHTTP_DEBUGTOOLBAR_SITE = https://files.pythonhosted.org/packages/3f/dd/5121417dfbeb4661673afa5c8708f1539889d0e54b1509a6fdf66705efc5
PYTHON_AIOHTTP_DEBUGTOOLBAR_SETUP_TYPE = setuptools
PYTHON_AIOHTTP_DEBUGTOOLBAR_LICENSE = Apache-2.0
PYTHON_AIOHTTP_DEBUGTOOLBAR_LICENSE_FILES = LICENSE

$(eval $(python-package))
