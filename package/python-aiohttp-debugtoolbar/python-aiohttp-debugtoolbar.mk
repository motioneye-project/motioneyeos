################################################################################
#
# python-aiohttp-debugtoolbar
#
################################################################################

PYTHON_AIOHTTP_DEBUGTOOLBAR_VERSION = 0.5.0
PYTHON_AIOHTTP_DEBUGTOOLBAR_SOURCE = aiohttp-debugtoolbar-$(PYTHON_AIOHTTP_DEBUGTOOLBAR_VERSION).tar.gz
PYTHON_AIOHTTP_DEBUGTOOLBAR_SITE = https://files.pythonhosted.org/packages/08/b1/b629499450a84e68b53d000e6150ae4dace68ae589c5ac36b6541777c8d3
PYTHON_AIOHTTP_DEBUGTOOLBAR_SETUP_TYPE = setuptools
PYTHON_AIOHTTP_DEBUGTOOLBAR_LICENSE = Apache-2.0
PYTHON_AIOHTTP_DEBUGTOOLBAR_LICENSE_FILES = LICENSE

$(eval $(python-package))
