################################################################################
#
# python-django
#
################################################################################

PYTHON_DJANGO_VERSION = 3.0
PYTHON_DJANGO_SOURCE = Django-$(PYTHON_DJANGO_VERSION).tar.gz
# The official Django site has an unpractical URL
PYTHON_DJANGO_SITE = https://files.pythonhosted.org/packages/f8/46/b3b8c61f867827fff2305db40659495dcd64fb35c399e75c53f23c113871
PYTHON_DJANGO_LICENSE = BSD-3-Clause
PYTHON_DJANGO_LICENSE_FILES = LICENSE
PYTHON_DJANGO_SETUP_TYPE = setuptools

$(eval $(python-package))
