################################################################################
#
# python-django
#
################################################################################

PYTHON_DJANGO_VERSION = 3.0.3
PYTHON_DJANGO_SOURCE = Django-$(PYTHON_DJANGO_VERSION).tar.gz
# The official Django site has an unpractical URL
PYTHON_DJANGO_SITE = https://files.pythonhosted.org/packages/3d/21/316d435bf8bd6f355be6b5765da91394fb38f405e5bea6680e411e4d470c
PYTHON_DJANGO_LICENSE = BSD-3-Clause
PYTHON_DJANGO_LICENSE_FILES = LICENSE
PYTHON_DJANGO_SETUP_TYPE = setuptools

$(eval $(python-package))
