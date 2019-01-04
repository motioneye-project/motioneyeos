################################################################################
#
# python-django
#
################################################################################

PYTHON_DJANGO_VERSION = 2.1.5
PYTHON_DJANGO_SOURCE = Django-$(PYTHON_DJANGO_VERSION).tar.gz
# The official Django site has an unpractical URL
PYTHON_DJANGO_SITE = https://files.pythonhosted.org/packages/5c/7f/4c750e09b246621e5e90fa08f93dec1b991f5c203b0ff615d62a891c8f41
PYTHON_DJANGO_LICENSE = BSD-3-Clause
PYTHON_DJANGO_LICENSE_FILES = LICENSE
PYTHON_DJANGO_SETUP_TYPE = setuptools

$(eval $(python-package))
