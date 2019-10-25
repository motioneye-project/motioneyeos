################################################################################
#
# python-uvloop
#
################################################################################

PYTHON_UVLOOP_VERSION = 0.13.0
PYTHON_UVLOOP_SOURCE = uvloop-$(PYTHON_UVLOOP_VERSION).tar.gz
PYTHON_UVLOOP_SITE = https://files.pythonhosted.org/packages/e3/15/dc3276384f4363015d7c72282f37066bae26c77f99158f66c9058ac167cf
PYTHON_UVLOOP_SETUP_TYPE = setuptools
PYTHON_UVLOOP_LICENSE = Apache-2.0, MIT
PYTHON_UVLOOP_LICENSE_FILES = LICENSE-APACHE LICENSE-MIT
PYTHON_UVLOOP_BUILD_OPTS = build_ext --inplace --cython-always --use-system-libuv
PYTHON_UVLOOP_INSTALL_TARGET_OPTS = build_ext --inplace --cython-always --use-system-libuv
PYTHON_UVLOOP_DEPENDENCIES = libuv host-python-cython

# force regenerating loop.c with cython. can be removed with the next
# uvloop version bump
define PYTHON_UVLOOP_FORCE_REGEN_LOOPC
	$(RM) $(@D)/uvloop/loop.c
endef
PYTHON_UVLOOP_PRE_BUILD_HOOKS += PYTHON_UVLOOP_FORCE_REGEN_LOOPC

$(eval $(python-package))
