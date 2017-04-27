################################################################################
#
# python-django
#
################################################################################

PYTHON_DJANGO_VERSION = 1.10.7
PYTHON_DJANGO_SOURCE = Django-$(PYTHON_DJANGO_VERSION).tar.gz
# The official Django site has an unpractical URL
PYTHON_DJANGO_SITE = https://pypi.python.org/packages/15/b4/d4bb7313e02386bd23a60e1eb5670321313fb67289c6f36ec43bce747aff
PYTHON_DJANGO_LICENSE = BSD-3-Clause
PYTHON_DJANGO_LICENSE_FILES = LICENSE
PYTHON_DJANGO_SETUP_TYPE = setuptools

$(eval $(python-package))
