################################################################################
#
# python-django-enumfields
#
################################################################################

PYTHON_DJANGO_ENUMFIELDS_VERSION = 1.0.0
PYTHON_DJANGO_ENUMFIELDS_SOURCE = django-enumfields-$(PYTHON_DJANGO_ENUMFIELDS_VERSION).tar.gz
PYTHON_DJANGO_ENUMFIELDS_SITE = https://files.pythonhosted.org/packages/b7/56/3f4e8d8ef6d5577a1b75b3cfae6dff819afd030e3a519a326ec7a7a0b74f
PYTHON_DJANGO_ENUMFIELDS_SETUP_TYPE = setuptools
PYTHON_DJANGO_ENUMFIELDS_LICENSE = MIT
PYTHON_DJANGO_ENUMFIELDS_LICENSE_FILES = LICENSE

$(eval $(python-package))
