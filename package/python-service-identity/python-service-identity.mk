################################################################################
#
# python-service-identity
#
################################################################################

PYTHON_SERVICE_IDENTITY_VERSION = 17.0.0
PYTHON_SERVICE_IDENTITY_SOURCE = service_identity-$(PYTHON_SERVICE_IDENTITY_VERSION).tar.gz
PYTHON_SERVICE_IDENTITY_SITE = https://pypi.python.org/packages/de/2a/cab6e30be82c8fcd2339ef618036720eda954cf05daef514e386661c9221
PYTHON_SERVICE_IDENTITY_LICENSE = MIT
PYTHON_SERVICE_IDENTITY_LICENSE_FILES = LICENSE
PYTHON_SERVICE_IDENTITY_SETUP_TYPE = setuptools

$(eval $(python-package))
