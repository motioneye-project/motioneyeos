################################################################################
#
# python-django
#
################################################################################

PYTHON_DJANGO_VERSION = 1.11.15
PYTHON_DJANGO_SOURCE = Django-$(PYTHON_DJANGO_VERSION).tar.gz
# The official Django site has an unpractical URL
PYTHON_DJANGO_SITE = https://files.pythonhosted.org/packages/43/b5/b44286e56a5211d37b4058dcd5e62835afa5ce5aa6a38b56bd04c0d01cbc
PYTHON_DJANGO_LICENSE = BSD-3-Clause
PYTHON_DJANGO_LICENSE_FILES = LICENSE
PYTHON_DJANGO_SETUP_TYPE = setuptools

$(eval $(python-package))
