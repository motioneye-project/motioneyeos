################################################################################
#
# python-cached-property
#
################################################################################

PYTHON_CACHED_PROPERTY_VERSION = 1.5.1
PYTHON_CACHED_PROPERTY_SOURCE = cached-property-$(PYTHON_CACHED_PROPERTY_VERSION).tar.gz
PYTHON_CACHED_PROPERTY_SITE = https://files.pythonhosted.org/packages/57/8e/0698e10350a57d46b3bcfe8eff1d4181642fd1724073336079cb13c5cf7f
PYTHON_CACHED_PROPERTY_SETUP_TYPE = setuptools
PYTHON_CACHED_PROPERTY_LICENSE = BSD-3-Clause
PYTHON_CACHED_PROPERTY_LICENSE_FILES = LICENSE

$(eval $(python-package))
