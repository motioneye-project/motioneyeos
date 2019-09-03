################################################################################
#
# python-aiohttp-jinja2
#
################################################################################

PYTHON_AIOHTTP_JINJA2_VERSION = 1.1.2
PYTHON_AIOHTTP_JINJA2_SOURCE = aiohttp-jinja2-$(PYTHON_AIOHTTP_JINJA2_VERSION).tar.gz
PYTHON_AIOHTTP_JINJA2_SITE = https://files.pythonhosted.org/packages/65/ff/60a0fc663cb0410f33c2822c274ddb0cdb43985066498aef1b39126f26d2
PYTHON_AIOHTTP_JINJA2_SETUP_TYPE = setuptools
PYTHON_AIOHTTP_JINJA2_LICENSE = Apache-2.0
PYTHON_AIOHTTP_JINJA2_LICENSE_FILES = LICENSE

$(eval $(python-package))
