################################################################################
#
# python-django
#
################################################################################

PYTHON_DJANGO_VERSION = 2.2.3
PYTHON_DJANGO_SOURCE = Django-$(PYTHON_DJANGO_VERSION).tar.gz
# The official Django site has an unpractical URL
PYTHON_DJANGO_SITE = https://files.pythonhosted.org/packages/d3/20/b447eb3d820e0d05fe83cbfb016842bd8da35f4b0f83498dca43d02aebc3
PYTHON_DJANGO_LICENSE = BSD-3-Clause
PYTHON_DJANGO_LICENSE_FILES = LICENSE
PYTHON_DJANGO_SETUP_TYPE = setuptools

$(eval $(python-package))
