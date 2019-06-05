################################################################################
#
# python-django
#
################################################################################

PYTHON_DJANGO_VERSION = 2.1.9
PYTHON_DJANGO_SOURCE = Django-$(PYTHON_DJANGO_VERSION).tar.gz
# The official Django site has an unpractical URL
PYTHON_DJANGO_SITE = https://files.pythonhosted.org/packages/c1/b3/3cdc60dc2e3c11236539f9470e42c5075a2e9c9f4885f5b4b912e9f19992
PYTHON_DJANGO_LICENSE = BSD-3-Clause
PYTHON_DJANGO_LICENSE_FILES = LICENSE
PYTHON_DJANGO_SETUP_TYPE = setuptools

$(eval $(python-package))
