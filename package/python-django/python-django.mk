################################################################################
#
# python-django
#
################################################################################

PYTHON_DJANGO_VERSION = 1.10.2
PYTHON_DJANGO_SOURCE = Django-$(PYTHON_DJANGO_VERSION).tar.gz
# The official Django site has an unpractical URL
PYTHON_DJANGO_SITE = https://pypi.python.org/packages/57/9e/59444485f092b6ed4f1931e7d2e13b67fdab967c041d02f58a0d1dab8c23
PYTHON_DJANGO_LICENSE = BSD-3-Clause
PYTHON_DJANGO_LICENSE_FILES = LICENSE
PYTHON_DJANGO_SETUP_TYPE = setuptools

$(eval $(python-package))
