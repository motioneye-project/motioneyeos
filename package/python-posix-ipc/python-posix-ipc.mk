################################################################################
#
# python-posix-ipc
#
################################################################################

PYTHON_POSIX_IPC_VERSION = 0.9.6
PYTHON_POSIX_IPC_SOURCE = posix_ipc-$(PYTHON_POSIX_IPC_VERSION).tar.gz
PYTHON_POSIX_IPC_SITE = http://semanchuk.com/philip/posix_ipc
PYTHON_POSIX_IPC_LICENSE = BSD-3c
PYTHON_POSIX_IPC_LICENSE_FILES = LICENSE
PYTHON_POSIX_IPC_SETUP_TYPE = distutils

$(eval $(python-package))
