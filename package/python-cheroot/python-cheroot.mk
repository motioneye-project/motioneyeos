################################################################################
#
# python-cheroot
#
################################################################################

PYTHON_CHEROOT_VERSION = 8.2.1
PYTHON_CHEROOT_SOURCE = cheroot-$(PYTHON_CHEROOT_VERSION).tar.gz
PYTHON_CHEROOT_SITE = https://files.pythonhosted.org/packages/9b/4d/2e51e7ce60f54a5279e91648b9b9b497d4d22bc624ecae6af1b6866144a7
PYTHON_CHEROOT_LICENSE = BSD-3-Clause
PYTHON_CHEROOT_LICENSE_FILES = LICENSE.md
PYTHON_CHEROOT_SETUP_TYPE = setuptools
PYTHON_CHEROOT_DEPENDENCIES = host-python-setuptools-scm host-python-setuptools-scm-git-archive

$(eval $(python-package))
