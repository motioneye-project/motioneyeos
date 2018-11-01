################################################################################
#
# python-django
#
################################################################################

PYTHON_DJANGO_VERSION = 2.1.3
PYTHON_DJANGO_SOURCE = Django-$(PYTHON_DJANGO_VERSION).tar.gz
# The official Django site has an unpractical URL
PYTHON_DJANGO_SITE = https://files.pythonhosted.org/packages/93/b1/0d6febb88712c39aced7df232d432fa22f5613c4bff246a1f4841248a60d
PYTHON_DJANGO_LICENSE = BSD-3-Clause
PYTHON_DJANGO_LICENSE_FILES = LICENSE
PYTHON_DJANGO_SETUP_TYPE = setuptools

$(eval $(python-package))
