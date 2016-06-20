################################################################################
#
# python-dominate
#
################################################################################

PYTHON_DOMINATE_VERSION = acb02c7c71e353e5dfbc905d506b54908533027e
PYTHON_DOMINATE_SITE = $(call github,Knio,dominate,$(PYTHON_DOMINATE_VERSION))
PYTHON_DOMINATE_SETUP_TYPE = setuptools
PYTHON_DOMINATE_LICENSE = LGPLv3+
PYTHON_DOMINATE_LICENSE_FILES = LICENSE.txt

$(eval $(python-package))
