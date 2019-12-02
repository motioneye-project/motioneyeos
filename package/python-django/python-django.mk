################################################################################
#
# python-django
#
################################################################################

PYTHON_DJANGO_VERSION = 2.2.8
PYTHON_DJANGO_SOURCE = Django-$(PYTHON_DJANGO_VERSION).tar.gz
# The official Django site has an unpractical URL
PYTHON_DJANGO_SITE = https://files.pythonhosted.org/packages/1c/aa/f618f346b895123be44739b276099a2b418b45b2b7afb5e1071403e8d2e9
PYTHON_DJANGO_LICENSE = BSD-3-Clause
PYTHON_DJANGO_LICENSE_FILES = LICENSE
PYTHON_DJANGO_SETUP_TYPE = setuptools

$(eval $(python-package))
