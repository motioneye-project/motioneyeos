################################################################################
#
# python-paramiko
#
################################################################################

PYTHON_PARAMIKO_VERSION = 1.16.0
PYTHON_PARAMIKO_SOURCE = paramiko-$(PYTHON_PARAMIKO_VERSION).tar.gz
PYTHON_PARAMIKO_SITE = https://pypi.python.org/packages/source/p/paramiko
PYTHON_PARAMIKO_SETUP_TYPE = setuptools
PYTHON_PARAMIKO_LICENSE = LGPLv2.1+
PYTHON_PARAMIKO_LICENSE_FILES = LICENSE

$(eval $(python-package))
