################################################################################
#
# python-colorlog
#
################################################################################

PYTHON_COLORLOG_VERSION = 4.0.2
PYTHON_COLORLOG_SOURCE = colorlog-$(PYTHON_COLORLOG_VERSION).tar.gz
PYTHON_COLORLOG_SITE = https://files.pythonhosted.org/packages/fc/30/6ba1282b773e9f44d9cfaafa38b6cc180441307c5fe0edd8db13a8903e3f
PYTHON_COLORLOG_SETUP_TYPE = setuptools
PYTHON_COLORLOG_LICENSE = MIT
PYTHON_COLORLOG_LICENSE_FILES = LICENSE

$(eval $(python-package))
