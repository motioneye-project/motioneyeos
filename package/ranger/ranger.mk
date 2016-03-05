################################################################################
#
# ranger
#
################################################################################

RANGER_VERSION = 1.7.2
RANGER_SITE = http://ranger.nongnu.org
RANGER_SETUP_TYPE = distutils
RANGER_LICENSE = GPLv3
RANGER_LICENSE_FILES = AUTHORS

# The ranger script request python to be called with -O (optimize generated
# bytecode slightly; also PYTHONOPTIMIZE=x). This implicitly requires the python
# source files to be present. Therefore, the -O flag is removed when only the .pyc
# files are installed.

define RANGER_DO_NOT_GENERATE_BYTECODE_AT_RUNTIME
	$(SED) 's%/usr/bin/python -O%/usr/bin/python%g' $(@D)/scripts/ranger
endef

ifeq ($(BR2_PACKAGE_PYTHON3_PYC_ONLY)$(BR2_PACKAGE_PYTHON_PYC_ONLY),y)
RANGER_POST_PATCH_HOOKS += RANGER_DO_NOT_GENERATE_BYTECODE_AT_RUNTIME
endif

$(eval $(python-package))
