################################################################################
#
# python-systemd
#
################################################################################

PYTHON_SYSTEMD_VERSION = 234 # Should be kept in sync with $(SYSTEMD_VERSION)
PYTHON_SYSTEMD_SOURCE = systemd-python-$(PYTHON_SYSTEMD_VERSION).tar.gz
PYTHON_SYSTEMD_SITE = https://pypi.python.org/packages/e8/a8/00ba0f605837a8f69523e6c3a4fb14675a6430c163f836540129c50b3aef
PYTHON_SYSTEMD_SETUP_TYPE = distutils
PYTHON_SYSTEMD_LICENSE = LGPL-2.1
PYTHON_SYSTEMD_LICENSE_FILES = LICENSE.txt
PYTHON_SYSTEMD_DEPENDENCIES = systemd # To be able to link against libsystemd

$(eval $(python-package))
