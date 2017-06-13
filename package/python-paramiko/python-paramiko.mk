################################################################################
#
# python-paramiko
#
################################################################################

PYTHON_PARAMIKO_VERSION = 2.2.0
PYTHON_PARAMIKO_SOURCE = paramiko-$(PYTHON_PARAMIKO_VERSION).tar.gz
PYTHON_PARAMIKO_SITE = https://pypi.python.org/packages/ea/a1/75393511fa6b645d28bd614ba061af99e94a6916c6b4f619f8b6b58bc35e
PYTHON_PARAMIKO_SETUP_TYPE = setuptools
PYTHON_PARAMIKO_LICENSE = LGPL-2.1+
PYTHON_PARAMIKO_LICENSE_FILES = LICENSE

$(eval $(python-package))
