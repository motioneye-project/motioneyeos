################################################################################
#
# python-aiohttp-jinja2
#
################################################################################

PYTHON_AIOHTTP_JINJA2_VERSION = 1.1.0
PYTHON_AIOHTTP_JINJA2_SOURCE = aiohttp-jinja2-$(PYTHON_AIOHTTP_JINJA2_VERSION).tar.gz
PYTHON_AIOHTTP_JINJA2_SITE = https://files.pythonhosted.org/packages/76/9d/68fa1e9ec3bafba572772eb385023de54096663bd6e302a24d7344c6a711
PYTHON_AIOHTTP_JINJA2_SETUP_TYPE = setuptools
PYTHON_AIOHTTP_JINJA2_LICENSE = Apache-2.0
PYTHON_AIOHTTP_JINJA2_LICENSE_FILES = LICENSE

$(eval $(python-package))
