################################################################################
#
# python-zc-lockfile
#
################################################################################

PYTHON_ZC_LOCKFILE_VERSION = 2.0
PYTHON_ZC_LOCKFILE_SOURCE = zc.lockfile-$(PYTHON_ZC_LOCKFILE_VERSION).tar.gz
PYTHON_ZC_LOCKFILE_SITE = https://files.pythonhosted.org/packages/11/98/f21922d501ab29d62665e7460c94f5ed485fd9d8348c126697947643a881
PYTHON_ZC_LOCKFILE_SETUP_TYPE = setuptools
PYTHON_ZC_LOCKFILE_LICENSE = ZPL-2.1
PYTHON_ZC_LOCKFILE_LICENSE_FILES = LICENSE.txt

$(eval $(python-package))
