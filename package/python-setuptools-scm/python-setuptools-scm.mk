################################################################################
#
# python-setuptools-scm
#
################################################################################

PYTHON_SETUPTOOLS_SCM_VERSION = 1.15.1rc1
PYTHON_SETUPTOOLS_SCM_SOURCE = setuptools_scm-$(PYTHON_SETUPTOOLS_SCM_VERSION).tar.gz
PYTHON_SETUPTOOLS_SCM_SITE = https://pypi.python.org/packages/b8/4b/c7370d3c54a74ee8abb3c7e0792c6c95f1e9658e959211b5b86eebe4677a
PYTHON_SETUPTOOLS_SCM_LICENSE = MIT
PYTHON_SETUPTOOLS_SCM_LICENSE_FILES = LICENSE
PYTHON_SETUPTOOLS_SCM_SETUP_TYPE = setuptools

$(eval $(host-python-package))
