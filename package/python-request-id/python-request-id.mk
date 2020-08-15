################################################################################
#
# python-request-id
#
################################################################################

PYTHON_REQUEST_ID_VERSION = 1.0
PYTHON_REQUEST_ID_SOURCE = request-id-$(PYTHON_REQUEST_ID_VERSION).tar.gz
PYTHON_REQUEST_ID_SITE = https://files.pythonhosted.org/packages/bc/b6/ade909d4af3dffe492789d36ea58a0ecbd637f8200bc480b282d455fe497
PYTHON_REQUEST_ID_SETUP_TYPE = setuptools
PYTHON_REQUEST_ID_LICENSE = MIT
PYTHON_REQUEST_ID_LICENSE_FILES = LICENSE.txt

$(eval $(python-package))
