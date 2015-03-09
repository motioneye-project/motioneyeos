################################################################################
#
# python-django
#
################################################################################

PYTHON_DJANGO_VERSION = 1.7.3
PYTHON_DJANGO_SOURCE = Django-$(PYTHON_DJANGO_VERSION).tar.gz
# The official Django site has an unpractical URL
PYTHON_DJANGO_SITE = https://pypi.python.org/packages/source/D/Django
PYTHON_DJANGO_LICENSE = BSD-3c
PYTHON_DJANGO_LICENSE_FILES = LICENSE
PYTHON_DJANGO_SETUP_TYPE = setuptools

$(eval $(python-package))
