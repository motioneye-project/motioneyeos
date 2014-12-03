################################################################################
#
# python-pam
#
################################################################################

PYTHON_PAM_VERSION = 0.5.0
PYTHON_PAM_SOURCE = PyPAM-$(PYTHON_PAM_VERSION).tar.gz
# pangalactic.org gone
PYTHON_PAM_SITE = http://pkgs.fedoraproject.org/repo/pkgs/PyPAM/PyPAM-0.5.0.tar.gz/f1e7c2c56421dda28a75ace59a3c8871/
PYTHON_PAM_SETUP_TYPE = distutils
PYTHON_PAM_LICENSE = LGPLv2.1
PYTHON_PAM_LICENSE_FILES = COPYING
PYTHON_PAM_DEPENDENCIES = linux-pam

$(eval $(python-package))
