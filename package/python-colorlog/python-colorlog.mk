################################################################################
#
# python-colorlog
#
################################################################################

PYTHON_COLORLOG_VERSION = 4.1.0
PYTHON_COLORLOG_SOURCE = colorlog-$(PYTHON_COLORLOG_VERSION).tar.gz
PYTHON_COLORLOG_SITE = https://files.pythonhosted.org/packages/a5/51/c6e1f2c7e6d7524b580d5a8d7691fd4530f894ae8a23ba66a065291ceba2
PYTHON_COLORLOG_SETUP_TYPE = setuptools
PYTHON_COLORLOG_LICENSE = MIT
PYTHON_COLORLOG_LICENSE_FILES = LICENSE

$(eval $(python-package))
