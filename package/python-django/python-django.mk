################################################################################
#
# python-django
#
################################################################################

PYTHON_DJANGO_VERSION = 2.1.2
PYTHON_DJANGO_SOURCE = Django-$(PYTHON_DJANGO_VERSION).tar.gz
# The official Django site has an unpractical URL
PYTHON_DJANGO_SITE = https://files.pythonhosted.org/packages/8b/03/4c74d3712919613f2c611e6689522df507a2753a92049009661a81b4b72f
PYTHON_DJANGO_LICENSE = BSD-3-Clause
PYTHON_DJANGO_LICENSE_FILES = LICENSE
PYTHON_DJANGO_SETUP_TYPE = setuptools

$(eval $(python-package))
