################################################################################
#
# python-django
#
################################################################################

PYTHON_DJANGO_VERSION = 2.2.6
PYTHON_DJANGO_SOURCE = Django-$(PYTHON_DJANGO_VERSION).tar.gz
# The official Django site has an unpractical URL
PYTHON_DJANGO_SITE = https://files.pythonhosted.org/packages/c7/2c/bbd0fddf6a08456c3100b8e8b230f3288d4511985aa4e2368b0d115b5aae
PYTHON_DJANGO_LICENSE = BSD-3-Clause
PYTHON_DJANGO_LICENSE_FILES = LICENSE
PYTHON_DJANGO_SETUP_TYPE = setuptools

$(eval $(python-package))
