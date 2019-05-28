################################################################################
#
# python-bluepy
#
################################################################################

PYTHON_BLUEPY_VERSION = 1.3.0
PYTHON_BLUEPY_SOURCE = bluepy-$(PYTHON_BLUEPY_VERSION).tar.gz
PYTHON_BLUEPY_SITE = https://files.pythonhosted.org/packages/27/91/6cfca10bee9862f93015413cf9e6a52c3081a71f1518963396a055128f8e
PYTHON_BLUEPY_SETUP_TYPE = setuptools
PYTHON_BLUEPY_LICENSE = GPL-2.0+
PYTHON_BLUEPY_LICENSE_FILES = LICENSE.txt
PYTHON_BLUEPY_ENV = CC=$(TARGET_CROSS)gcc

define PYTHON_BLUEPY_REMOVE_CRAP
    $(RM) $(TARGET_DIR)/usr/bin/blescan
    $(RM) $(TARGET_DIR)/usr/bin/thingy52
    $(RM) $(TARGET_DIR)/usr/bin/sensortag
    $(RM) $(TARGET_DIR)/usr/lib/python*/site-packages/bluepy/bluez-src.tgz
    $(RM) $(TARGET_DIR)/usr/lib/python*/site-packages/bluepy/*.{h,c}
    $(RM) $(TARGET_DIR)/usr/lib/python*/site-packages/bluepy/Makefile 
endef

PYTHON_BLUEPY_POST_INSTALL_TARGET_HOOKS += PYTHON_BLUEPY_REMOVE_CRAP

$(eval $(python-package))
