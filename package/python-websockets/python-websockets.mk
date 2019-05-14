################################################################################
#
# python-websockets
#
################################################################################

PYTHON_WEBSOCKETS_VERSION = 6.0
PYTHON_WEBSOCKETS_SOURCE = websockets-$(PYTHON_WEBSOCKETS_VERSION).tar.gz
PYTHON_WEBSOCKETS_SITE = https://files.pythonhosted.org/packages/4e/2a/56e60bb4c3696bc736998cc13c3fa1a36210609d7e1a3f2519857b420245
PYTHON_WEBSOCKETS_SETUP_TYPE = setuptools
PYTHON_WEBSOCKETS_LICENSE = BSD-3-Clause
PYTHON_WEBSOCKETS_LICENSE_FILES = LICENSE

$(eval $(python-package))
