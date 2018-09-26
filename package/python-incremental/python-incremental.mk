################################################################################
#
# python-incremental
#
################################################################################

PYTHON_INCREMENTAL_VERSION = 17.5.0
PYTHON_INCREMENTAL_SOURCE = incremental-$(PYTHON_INCREMENTAL_VERSION).tar.gz
PYTHON_INCREMENTAL_SITE = https://files.pythonhosted.org/packages/8f/26/02c4016aa95f45479eea37c90c34f8fab6775732ae62587a874b619ca097
PYTHON_INCREMENTAL_SETUP_TYPE = setuptools
PYTHON_INCREMENTAL_LICENSE = MIT
PYTHON_INCREMENTAL_LICENSE_FILES = LICENSE

$(eval $(python-package))
$(eval $(host-python-package))
