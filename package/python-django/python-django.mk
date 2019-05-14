################################################################################
#
# python-django
#
################################################################################

PYTHON_DJANGO_VERSION = 2.1.7
PYTHON_DJANGO_SOURCE = Django-$(PYTHON_DJANGO_VERSION).tar.gz
# The official Django site has an unpractical URL
PYTHON_DJANGO_SITE = https://files.pythonhosted.org/packages/7e/ae/29c28f6afddae0e305326078f31372f03d7f2e6d6210c9963843196ce67e
PYTHON_DJANGO_LICENSE = BSD-3-Clause
PYTHON_DJANGO_LICENSE_FILES = LICENSE
PYTHON_DJANGO_SETUP_TYPE = setuptools

$(eval $(python-package))
