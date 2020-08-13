################################################################################
#
# python-aiohttp-mako
#
################################################################################

PYTHON_AIOHTTP_MAKO_VERSION = 0.4.0
PYTHON_AIOHTTP_MAKO_SOURCE = aiohttp-mako-$(PYTHON_AIOHTTP_MAKO_VERSION).tar.gz
PYTHON_AIOHTTP_MAKO_SITE = https://files.pythonhosted.org/packages/f9/8e/d7c0ea2c74e8102a94021e150b622d274fdef22ebd1f0c9a546b21458931
PYTHON_AIOHTTP_MAKO_SETUP_TYPE = setuptools
PYTHON_AIOHTTP_MAKO_LICENSE = Apache-2.0
PYTHON_AIOHTTP_MAKO_LICENSE_FILES = LICENSE

$(eval $(python-package))
