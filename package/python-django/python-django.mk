################################################################################
#
# python-django
#
################################################################################

PYTHON_DJANGO_VERSION = 1.11.16
PYTHON_DJANGO_SOURCE = Django-$(PYTHON_DJANGO_VERSION).tar.gz
# The official Django site has an unpractical URL
PYTHON_DJANGO_SITE = https://files.pythonhosted.org/packages/35/1d/59836bce4c9cfded261e21c0abd6a4629de6d289522d0fd928117d8eb985
PYTHON_DJANGO_LICENSE = BSD-3-Clause
PYTHON_DJANGO_LICENSE_FILES = LICENSE
PYTHON_DJANGO_SETUP_TYPE = setuptools

$(eval $(python-package))
