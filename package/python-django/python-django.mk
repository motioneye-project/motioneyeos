################################################################################
#
# python-django
#
################################################################################

PYTHON_DJANGO_VERSION = 1.7.2
PYTHON_DJANGO_SOURCE = Django-$(PYTHON_DJANGO_VERSION).tar.gz
# The official Django site has an unpractical URL
PYTHON_DJANGO_SITE = https://pypi.python.org/packages/source/D/Django/
PYTHON_DJANGO_LICENSE = BSD
PYTHON_DJANGO_LICENSE_FILES = LICENSE
PYTHON_DJANGO_SETUP_TYPE = setuptools

$(eval $(python-package))
