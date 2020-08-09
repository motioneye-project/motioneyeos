################################################################################
#
# python-brotli
#
################################################################################

PYTHON_BROTLI_VERSION = 1.0.7
PYTHON_BROTLI_SOURCE = Brotli-$(PYTHON_BROTLI_VERSION).zip
PYTHON_BROTLI_SITE = https://files.pythonhosted.org/packages/cd/9c/7955895f5672ecc85270244582c6b53ff95bb4c24bf77bd9271d42351635
PYTHON_BROTLI_SETUP_TYPE = setuptools
PYTHON_BROTLI_LICENSE = MIT
PYTHON_BROTLI_LICENSE_FILES = LICENSE

PYTHON_BROTLI_CFLAGS = $(TARGET_CFLAGS)

ifeq ($(BR2_TOOLCHAIN_HAS_GCC_BUG_68485),y)
PYTHON_BROTLI_CFLAGS += -O0
endif

PYTHON_BROTLI_ENV = CFLAGS="$(PYTHON_BROTLI_CFLAGS)"

define PYTHON_BROTLI_EXTRACT_CMDS
	$(UNZIP) -d $(@D) $(PYTHON_BROTLI_DL_DIR)/$(PYTHON_BROTLI_SOURCE)
	mv $(@D)/Brotli-$(PYTHON_BROTLI_VERSION)/* $(@D)
	$(RM) -r $(@D)/Brotli-$(PYTHON_BROTLI_VERSION)
endef

$(eval $(python-package))
