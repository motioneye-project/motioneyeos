################################################################################
#
# python-daemon
#
################################################################################

PYTHON_DAEMON_VERSION = 1.5.5
PYTHON_DAEMON_SITE = https://pypi.python.org/packages/source/p/python-daemon
PYTHON_DAEMON_LICENSE = Python-2.0 (library), GPLv2+ (test)
PYTHON_DAEMON_LICENSE_FILES = LICENSE.PSF-2 LICENSE.GPL-2
PYTHON_DAEMON_SETUP_TYPE = setuptools

$(eval $(python-package))
