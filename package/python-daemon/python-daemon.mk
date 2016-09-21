################################################################################
#
# python-daemon
#
################################################################################

PYTHON_DAEMON_VERSION = 2.1.1
PYTHON_DAEMON_SITE = https://pypi.python.org/packages/source/p/python-daemon
PYTHON_DAEMON_LICENSE = Apache-2.0 (library), GPLv3+ (test, build)
PYTHON_DAEMON_LICENSE_FILES = LICENSE.ASF-2 LICENSE.GPL-3
PYTHON_DAEMON_SETUP_TYPE = setuptools
PYTHON_DAEMON_DEPENDENCIES = host-python-docutils

$(eval $(python-package))
