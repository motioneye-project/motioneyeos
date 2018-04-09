################################################################################
#
# python-fastentrypoints
#
################################################################################

PYTHON_FASTENTRYPOINTS_VERSION = 0.10
PYTHON_FASTENTRYPOINTS_SOURCE = fastentrypoints-$(PYTHON_FASTENTRYPOINTS_VERSION).tar.gz
PYTHON_FASTENTRYPOINTS_SITE = https://pypi.python.org/packages/e8/c8/c2902c9c9da43d8be8c75a730f15f0c51933c42c39b91d1d7b605a88e907
PYTHON_FASTENTRYPOINTS_SETUP_TYPE = setuptools
PYTHON_FASTENTRYPOINTS_LICENSE = BSD-2-Clause
PYTHON_FASTENTRYPOINTS_LICENSE_FILES = fastentrypoints.py

$(eval $(host-python-package))
