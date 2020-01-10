################################################################################
#
# python-django
#
################################################################################

PYTHON_DJANGO_VERSION = 3.0.2
PYTHON_DJANGO_SOURCE = Django-$(PYTHON_DJANGO_VERSION).tar.gz
# The official Django site has an unpractical URL
PYTHON_DJANGO_SITE = https://files.pythonhosted.org/packages/c5/c1/5b901e21114b5dd9233726c2975c0aa7e9f48f63e41ec95d8777721d8aff
PYTHON_DJANGO_LICENSE = BSD-3-Clause
PYTHON_DJANGO_LICENSE_FILES = LICENSE
PYTHON_DJANGO_SETUP_TYPE = setuptools

$(eval $(python-package))
