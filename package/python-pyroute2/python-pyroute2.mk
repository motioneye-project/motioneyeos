#############################################################
#
# python-pyroute2
#
#############################################################

PYTHON_PYROUTE2_VERSION = 16a8aced82c65b94eb9e15a7d773a3256763d155
PYTHON_PYROUTE2_SITE = $(call github,svinota,pyroute2,$(PYTHON_PYROUTE2_VERSION))
PYTHON_PYROUTE2_LICENSE = Apache-2.0 or GPLv2+
PYTHON_PYROUTE2_LICENSE_FILES = LICENSE.Apache.v2 LICENSE.GPL.v2 README.license.md
PYTHON_PYROUTE2_SETUP_TYPE = distutils
PYTHON_PYROUTE2_DEPENDENCIES = host-gawk

# this hook is needed to create setup.py from setup.py.in
define PYTHON_PYROUTE2_CREATE_SETUP_PY
	$(TARGET_MAKE_ENV) $(MAKE1) -C $(@D) update-version
endef

PYTHON_PYROUTE2_PRE_CONFIGURE_HOOKS += PYTHON_PYROUTE2_CREATE_SETUP_PY

$(eval $(python-package))
