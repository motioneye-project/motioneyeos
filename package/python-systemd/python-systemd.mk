################################################################################
#
# python-systemd
#
################################################################################

PYTHON_SYSTEMD_VERSION = 233 # Should be kept in sync with $(SYSTEMD_VERSION)
PYTHON_SYSTEMD_SOURCE = systemd-python-$(PYTHON_SYSTEMD_VERSION).tar.gz
PYTHON_SYSTEMD_SITE = https://pypi.python.org/packages/10/89/d66ae73bdbc2614e4f2e90ddf9ef80d22c28f3cd70071345c3640465c14c
PYTHON_SYSTEMD_SETUP_TYPE = distutils
PYTHON_SYSTEMD_LICENSE = LGPL-2.1
PYTHON_SYSTEMD_LICENSE_FILES = LICENSE.txt
PYTHON_SYSTEMD_DEPENDENCIES = systemd # To be able to link against libsystemd

$(eval $(python-package))
