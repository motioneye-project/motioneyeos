################################################################################
#
# python-aiohttp-session
#
################################################################################

PYTHON_AIOHTTP_SESSION_VERSION = 2.8.0
PYTHON_AIOHTTP_SESSION_SOURCE = aiohttp-session-$(PYTHON_AIOHTTP_SESSION_VERSION).tar.gz
PYTHON_AIOHTTP_SESSION_SITE = https://files.pythonhosted.org/packages/a1/da/d49d017faadb5e2c754fce83e1bd3fbcea9d10bc970bc8df9471880463f0
PYTHON_AIOHTTP_SESSION_SETUP_TYPE = setuptools
PYTHON_AIOHTTP_SESSION_LICENSE = Apache-2.0
PYTHON_AIOHTTP_SESSION_LICENSE_FILES = LICENSE

$(eval $(python-package))
