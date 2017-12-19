################################################################################
#
# python-h2
#
################################################################################

PYTHON_H2_VERSION = 3.0.1
PYTHON_H2_SOURCE = h2-$(PYTHON_H2_VERSION).tar.gz
PYTHON_H2_SITE = https://pypi.python.org/packages/3c/86/aebb88df3c87255cfd0ffd338608fbfb34d1c850750a486e7f05b013e5a3
PYTHON_H2_SETUP_TYPE = setuptools
PYTHON_H2_LICENSE = MIT
PYTHON_H2_LICENSE_FILES = LICENSE

$(eval $(python-package))
