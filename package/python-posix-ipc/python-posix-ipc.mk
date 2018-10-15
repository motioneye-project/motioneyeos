################################################################################
#
# python-posix-ipc
#
################################################################################

PYTHON_POSIX_IPC_VERSION = 1.0.4
PYTHON_POSIX_IPC_SOURCE = posix_ipc-$(PYTHON_POSIX_IPC_VERSION).tar.gz
PYTHON_POSIX_IPC_SITE = https://files.pythonhosted.org/packages/c9/3e/54217da71aa26b488295d878df4d3132093253b4ae5798ac66fcb6921ef0
PYTHON_POSIX_IPC_LICENSE = BSD-3-Clause
PYTHON_POSIX_IPC_LICENSE_FILES = LICENSE
PYTHON_POSIX_IPC_SETUP_TYPE = setuptools

$(eval $(python-package))
