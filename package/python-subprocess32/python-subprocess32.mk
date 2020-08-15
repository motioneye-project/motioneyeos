################################################################################
#
# python-subprocess32
#
################################################################################

PYTHON_SUBPROCESS32_VERSION = 3.5.4
PYTHON_SUBPROCESS32_SOURCE = subprocess32-$(PYTHON_SUBPROCESS32_VERSION).tar.gz
PYTHON_SUBPROCESS32_SITE = https://files.pythonhosted.org/packages/32/c8/564be4d12629b912ea431f1a50eb8b3b9d00f1a0b1ceff17f266be190007
PYTHON_SUBPROCESS32_SETUP_TYPE = setuptools
PYTHON_SUBPROCESS32_LICENSE = Python-2.0
PYTHON_SUBPROCESS32_LICENSE_FILES = LICENSE

# The configure step needs to be run outside of the setup.py since it isn't
# run correctly for cross-compiling
define PYTHON_SUBPROCESS32_CONFIGURE_CMDS
	(cd $(@D) && \
	$(TARGET_CONFIGURE_OPTS) \
	$(TARGET_CONFIGURE_ARGS) \
	./configure \
		--target=$(GNU_TARGET_NAME) \
		--host=$(GNU_TARGET_NAME) \
		--build=$(GNU_HOST_NAME) \
		--prefix=/usr \
		--exec-prefix=/usr \
		--sysconfdir=/etc \
		--program-prefix="" \
	)
endef

$(eval $(python-package))
