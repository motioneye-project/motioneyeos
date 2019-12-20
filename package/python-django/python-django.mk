################################################################################
#
# python-django
#
################################################################################

PYTHON_DJANGO_VERSION = 3.0.1
PYTHON_DJANGO_SOURCE = Django-$(PYTHON_DJANGO_VERSION).tar.gz
# The official Django site has an unpractical URL
PYTHON_DJANGO_SITE = https://files.pythonhosted.org/packages/44/e8/4ae9ef3d455f4ce5aa22259cb6e40c69b29ef6b02d49c5cdfa265f7fc821
PYTHON_DJANGO_LICENSE = BSD-3-Clause
PYTHON_DJANGO_LICENSE_FILES = LICENSE
PYTHON_DJANGO_SETUP_TYPE = setuptools

$(eval $(python-package))
