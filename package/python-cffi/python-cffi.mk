################################################################################
#
# python-cffi
#
################################################################################

PYTHON_CFFI_VERSION = 1.6.0
PYTHON_CFFI_SOURCE = cffi-$(PYTHON_CFFI_VERSION).tar.gz
PYTHON_CFFI_SITE = https://pypi.python.org/packages/b6/98/11feff87072e2e640fb8320712b781eccdef05d588618915236b32289d5a
PYTHON_CFFI_SETUP_TYPE = setuptools
PYTHON_CFFI_DEPENDENCIES = host-pkgconf libffi
PYTHON_CFFI_LICENSE = MIT
PYTHON_CFFI_LICENSE_FILES = LICENSE

# This host package uses pkg-config to find libffi, so we have to
# provide the proper hints for pkg-config to behave properly for host
# packages.
HOST_PYTHON_CFFI_ENV = \
	PKG_CONFIG_ALLOW_SYSTEM_CFLAGS=1 \
	PKG_CONFIG_ALLOW_SYSTEM_LIBS=1 \
	PKG_CONFIG="$(PKG_CONFIG_HOST_BINARY)" \
	PKG_CONFIG_SYSROOT_DIR="/" \
	PKG_CONFIG_LIBDIR="$(HOST_DIR)/usr/lib/pkgconfig:$(HOST_DIR)/usr/share/pkgconfig"
HOST_PYTHON_CFFI_DEPENDENCIES = host-pkgconf host-python-pycparser host-libffi

$(eval $(python-package))
$(eval $(host-python-package))
