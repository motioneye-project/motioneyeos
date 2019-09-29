################################################################################
#
# python-aiohttp-sse
#
################################################################################

PYTHON_AIOHTTP_SSE_VERSION = 2.0.0
PYTHON_AIOHTTP_SSE_SOURCE = aiohttp-sse-$(PYTHON_AIOHTTP_SSE_VERSION).tar.gz
PYTHON_AIOHTTP_SSE_SITE = https://files.pythonhosted.org/packages/2b/50/e127729f7df53c32c96b5c71932a7262cad40c83f1e19c218b068c816d51
PYTHON_AIOHTTP_SSE_SETUP_TYPE = setuptools
PYTHON_AIOHTTP_SSE_LICENSE = Apache-2.0
PYTHON_AIOHTTP_SSE_LICENSE_FILES = LICENSE

$(eval $(python-package))
