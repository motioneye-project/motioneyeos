################################################################################
#
# python-cheroot
#
################################################################################

PYTHON_CHEROOT_VERSION = 8.1.0
PYTHON_CHEROOT_SOURCE = cheroot-$(PYTHON_CHEROOT_VERSION).tar.gz
PYTHON_CHEROOT_SITE = https://files.pythonhosted.org/packages/a1/6c/899c7de9323e440f7eda28fead4a84bd0ae5a557e6ebf8f12270cc502043
PYTHON_CHEROOT_LICENSE = BSD-3-Clause
PYTHON_CHEROOT_LICENSE_FILES = LICENSE.md
PYTHON_CHEROOT_SETUP_TYPE = setuptools
PYTHON_CHEROOT_DEPENDENCIES = host-python-setuptools-scm host-python-setuptools-scm-git-archive

$(eval $(python-package))
