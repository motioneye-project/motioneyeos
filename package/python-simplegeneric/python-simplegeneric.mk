################################################################################
#
# python-simplegeneric
#
################################################################################

PYTHON_SIMPLEGENERIC_VERSION = 0.8.1
PYTHON_SIMPLEGENERIC_SOURCE = simplegeneric-$(PYTHON_SIMPLEGENERIC_VERSION).zip
PYTHON_SIMPLEGENERIC_SITE = https://pypi.python.org/packages/3d/57/4d9c9e3ae9a255cd4e1106bb57e24056d3d0709fc01b2e3e345898e49d5b
PYTHON_SIMPLEGENERIC_LICENSE = ZPL-2.1

# Force setup-type to be 'setuptools' in order to force the package to
# be installed with --single-version-externally-managed. Otherwise we
# end up with a .egg file, which is a zip archive, and as such forces
# us to have 'zlib' as a runtime dependency
PYTHON_SIMPLEGENERIC_SETUP_TYPE = setuptools

define PYTHON_SIMPLEGENERIC_EXTRACT_CMDS
	unzip $(DL_DIR)/$(PYTHON_SIMPLEGENERIC_SOURCE) -d $(@D)
	mv $(@D)/simplegeneric-$(PYTHON_SIMPLEGENERIC_VERSION)/* $(@D)
	rmdir $(@D)/simplegeneric-$(PYTHON_SIMPLEGENERIC_VERSION)
endef

$(eval $(python-package))
