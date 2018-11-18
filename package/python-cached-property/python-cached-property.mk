################################################################################
#
# python-cached-property
#
################################################################################

PYTHON_CACHED_PROPERTY_VERSION = 1.4.0
PYTHON_CACHED_PROPERTY_SOURCE = cached-property-$(PYTHON_CACHED_PROPERTY_VERSION).tar.gz
PYTHON_CACHED_PROPERTY_SITE = https://pypi.python.org/packages/ce/87/72b7a5a0504ad8d5d5ea6804ac5b24ce4f07869f61c47ea00cd4382320ba
PYTHON_CACHED_PROPERTY_SETUP_TYPE = setuptools
PYTHON_CACHED_PROPERTY_LICENSE = BSD-3-Clause
PYTHON_CACHED_PROPERTY_LICENSE_FILES = LICENSE

$(eval $(python-package))
