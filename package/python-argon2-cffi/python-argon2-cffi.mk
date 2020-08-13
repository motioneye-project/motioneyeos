################################################################################
#
# python-argon2-cffi
#
################################################################################

PYTHON_ARGON2_CFFI_VERSION = 20.1.0
PYTHON_ARGON2_CFFI_SOURCE = argon2-cffi-$(PYTHON_ARGON2_CFFI_VERSION).tar.gz
PYTHON_ARGON2_CFFI_SITE = https://files.pythonhosted.org/packages/74/fd/d78e003a79c453e8454197092fce9d1c6099445b7e7da0b04eb4fe1dbab7
PYTHON_ARGON2_CFFI_SETUP_TYPE = setuptools
PYTHON_ARGON2_CFFI_LICENSE = MIT
PYTHON_ARGON2_CFFI_LICENSE_FILES = LICENSE
PYTHON_ARGON2_CFFI_DEPENDENCIES = host-python-cffi

ifeq ($(BR2_X86_CPU_HAS_SSE2),y)
PYTHON_ARGON2_CFFI_ENV = ARGON2_CFFI_USE_SSE2=1
else
PYTHON_ARGON2_CFFI_ENV = ARGON2_CFFI_USE_SSE2=0
endif

$(eval $(python-package))
