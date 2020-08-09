################################################################################
#
# python-entrypoints
#
################################################################################

PYTHON_ENTRYPOINTS_VERSION = 0.3
PYTHON_ENTRYPOINTS_SOURCE = entrypoints-$(PYTHON_ENTRYPOINTS_VERSION).tar.gz
PYTHON_ENTRYPOINTS_SITE = https://files.pythonhosted.org/packages/b4/ef/063484f1f9ba3081e920ec9972c96664e2edb9fdc3d8669b0e3b8fc0ad7c
PYTHON_ENTRYPOINTS_SETUP_TYPE = distutils
PYTHON_ENTRYPOINTS_LICENSE = MIT
PYTHON_ENTRYPOINTS_LICENSE_FILES = LICENSE

$(eval $(python-package))
