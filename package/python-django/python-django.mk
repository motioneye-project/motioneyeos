################################################################################
#
# python-django
#
################################################################################

PYTHON_DJANGO_VERSION = 3.0.4
PYTHON_DJANGO_SOURCE = Django-$(PYTHON_DJANGO_VERSION).tar.gz
# The official Django site has an unpractical URL
PYTHON_DJANGO_SITE = https://files.pythonhosted.org/packages/1d/38/89ea18b5aeb9b56fff7430388946e8e9dfd7a451f3e6ddb8a9b637f442c1
PYTHON_DJANGO_LICENSE = BSD-3-Clause
PYTHON_DJANGO_LICENSE_FILES = LICENSE
PYTHON_DJANGO_SETUP_TYPE = setuptools

$(eval $(python-package))
