################################################################################
#
# python-aiohttp-remotes
#
################################################################################

PYTHON_AIOHTTP_REMOTES_VERSION = 0.1.2
PYTHON_AIOHTTP_REMOTES_SOURCE = aiohttp_remotes-$(PYTHON_AIOHTTP_REMOTES_VERSION).tar.gz
PYTHON_AIOHTTP_REMOTES_SITE = https://files.pythonhosted.org/packages/cd/2f/93e9198a01485f588d12e19c87cd277542dc28d8b31dc8e1c09fa1c75548
PYTHON_AIOHTTP_REMOTES_SETUP_TYPE = distutils
PYTHON_AIOHTTP_REMOTES_LICENSE = MIT
PYTHON_AIOHTTP_REMOTES_LICENSE_FILES = LICENSE

$(eval $(python-package))
