################################################################################
#
# python-django
#
################################################################################

PYTHON_DJANGO_VERSION = 2.1.10
PYTHON_DJANGO_SOURCE = Django-$(PYTHON_DJANGO_VERSION).tar.gz
# The official Django site has an unpractical URL
PYTHON_DJANGO_SITE = https://files.pythonhosted.org/packages/be/1b/009ec818adf51c7641f3bd9dae778e8b28291b3ceedb352317b0eeafd7ff
PYTHON_DJANGO_LICENSE = BSD-3-Clause
PYTHON_DJANGO_LICENSE_FILES = LICENSE
PYTHON_DJANGO_SETUP_TYPE = setuptools

$(eval $(python-package))
