################################################################################
#
# python-daemonize
#
################################################################################

PYTHON_DAEMONIZE_VERSION = 2.5.0
PYTHON_DAEMONIZE_SOURCE = daemonize-$(PYTHON_DAEMONIZE_VERSION).tar.gz
PYTHON_DAEMONIZE_SITE = https://files.pythonhosted.org/packages/8c/20/96f7dbc23812cfe4cf479c87af3e4305d0d115fd1fffec32ddeee7b9c82b
PYTHON_DAEMONIZE_SETUP_TYPE = setuptools
PYTHON_DAEMONIZE_LICENSE = MIT
PYTHON_DAEMONIZE_LICENSE_FILES = LICENSE

$(eval $(python-package))
