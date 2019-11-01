################################################################################
#
# python-asgiref
#
################################################################################

PYTHON_ASGIREF_VERSION = 3.2.3
PYTHON_ASGIREF_SOURCE = asgiref-$(PYTHON_ASGIREF_VERSION).tar.gz
PYTHON_ASGIREF_SITE = https://files.pythonhosted.org/packages/80/c4/83a01607f2d10024c172097126264c8e00c6a4827b35d631ece9625e6ba2
PYTHON_ASGIREF_SETUP_TYPE = setuptools
PYTHON_ASGIREF_LICENSE = BSD-3-Clause
PYTHON_ASGIREF_LICENSE_FILES = LICENSE

$(eval $(python-package))
