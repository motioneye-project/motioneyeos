################################################################################
#
# python-paramiko
#
################################################################################

PYTHON_PARAMIKO_VERSION = 2.0.2
PYTHON_PARAMIKO_SOURCE = paramiko-$(PYTHON_PARAMIKO_VERSION).tar.gz
PYTHON_PARAMIKO_SITE = https://pypi.python.org/packages/6b/4e/971b8c917456a2ec9666311f7e695493002a64022397cd668150b5efd2a8
PYTHON_PARAMIKO_SETUP_TYPE = setuptools
PYTHON_PARAMIKO_LICENSE = LGPLv2.1+
PYTHON_PARAMIKO_LICENSE_FILES = LICENSE

$(eval $(python-package))
