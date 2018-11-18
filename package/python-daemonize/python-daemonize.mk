################################################################################
#
# python-daemonize
#
################################################################################

PYTHON_DAEMONIZE_VERSION = 2.4.7
PYTHON_DAEMONIZE_SOURCE = daemonize-$(PYTHON_DAEMONIZE_VERSION).tar.gz
PYTHON_DAEMONIZE_SITE = https://pypi.python.org/packages/84/15/923e3fe48239adf5d697c29e04a3f868d3e4ce8539aab29d6abe784db5be
PYTHON_DAEMONIZE_SETUP_TYPE = setuptools
PYTHON_DAEMONIZE_LICENSE = MIT
PYTHON_DAEMONIZE_LICENSE_FILES = LICENSE

$(eval $(python-package))
