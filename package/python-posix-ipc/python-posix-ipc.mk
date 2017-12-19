################################################################################
#
# python-posix-ipc
#
################################################################################

PYTHON_POSIX_IPC_VERSION = 1.0.0
PYTHON_POSIX_IPC_SOURCE = posix_ipc-$(PYTHON_POSIX_IPC_VERSION).tar.gz
PYTHON_POSIX_IPC_SITE = https://pypi.python.org/packages/f0/e6/bff62b62b2e75f695b737695951b7a4c1c6595369268a37868f5c34e1c12
PYTHON_POSIX_IPC_LICENSE = BSD-3-Clause
PYTHON_POSIX_IPC_LICENSE_FILES = LICENSE
PYTHON_POSIX_IPC_SETUP_TYPE = distutils

$(eval $(python-package))
