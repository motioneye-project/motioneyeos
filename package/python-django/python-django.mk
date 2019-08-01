################################################################################
#
# python-django
#
################################################################################

PYTHON_DJANGO_VERSION = 2.2.4
PYTHON_DJANGO_SOURCE = Django-$(PYTHON_DJANGO_VERSION).tar.gz
# The official Django site has an unpractical URL
PYTHON_DJANGO_SITE = https://files.pythonhosted.org/packages/19/11/3449a2071df9427e7a5c4dddee2462e88840dd968a9b0c161097154fcb0c
PYTHON_DJANGO_LICENSE = BSD-3-Clause
PYTHON_DJANGO_LICENSE_FILES = LICENSE
PYTHON_DJANGO_SETUP_TYPE = setuptools

$(eval $(python-package))
