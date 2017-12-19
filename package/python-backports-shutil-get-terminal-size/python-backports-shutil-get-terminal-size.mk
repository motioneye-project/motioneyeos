################################################################################
#
# python-backports-shutil-get-terminal-size
#
################################################################################

PYTHON_BACKPORTS_SHUTIL_GET_TERMINAL_SIZE_VERSION = 1.0.0
PYTHON_BACKPORTS_SHUTIL_GET_TERMINAL_SIZE_SOURCE = backports.shutil_get_terminal_size-$(PYTHON_BACKPORTS_SHUTIL_GET_TERMINAL_SIZE_VERSION).tar.gz
PYTHON_BACKPORTS_SHUTIL_GET_TERMINAL_SIZE_SITE = https://pypi.python.org/packages/ec/9c/368086faa9c016efce5da3e0e13ba392c9db79e3ab740b763fe28620b18b
PYTHON_BACKPORTS_SHUTIL_GET_TERMINAL_SIZE_SETUP_TYPE = setuptools
PYTHON_BACKPORTS_SHUTIL_GET_TERMINAL_SIZE_LICENSE = MIT
PYTHON_BACKPORTS_SHUTIL_GET_TERMINAL_SIZE_LICENSE_FILES = LICENSE

$(eval $(python-package))
