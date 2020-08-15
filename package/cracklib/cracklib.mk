################################################################################
#
# cracklib
#
################################################################################

CRACKLIB_VERSION = 2.9.7
CRACKLIB_SITE = https://github.com/cracklib/cracklib/releases/download/v$(CRACKLIB_VERSION)
CRACKLIB_LICENSE = LGPL-2.1
CRACKLIB_LICENSE_FILES = COPYING.LIB
CRACKLIB_INSTALL_STAGING = YES
CRACKLIB_DEPENDENCIES = host-cracklib $(TARGET_NLS_DEPENDENCIES)
CRACKLIB_CONF_ENV = LIBS=$(TARGET_NLS_LIBS)

ifeq ($(BR2_PACKAGE_ZLIB),y)
CRACKLIB_CONF_OPTS += --with-zlib
CRACKLIB_DEPENDENCIES += zlib
else
CRACKLIB_CONF_OPTS += --without-zlib
endif

ifeq ($(BR2_PACKAGE_PYTHON),y)
CRACKLIB_CONF_OPTS += --with-python
CRACKLIB_DEPENDENCIES += python
else
CRACKLIB_CONF_OPTS += --without-python
endif

HOST_CRACKLIB_CONF_OPTS += --without-python --without-zlib

ifeq ($(BR2_PACKAGE_CRACKLIB_FULL_DICT),y)
CRACKLIB_EXTRA_DOWNLOADS = cracklib-words-$(CRACKLIB_VERSION).gz
CRACKLIB_DICT_SOURCE = $(CRACKLIB_DL_DIR)/cracklib-words-$(CRACKLIB_VERSION).gz
else
CRACKLIB_DICT_SOURCE = $(@D)/dicts/cracklib-small
endif

ifeq ($(BR2_PACKAGE_CRACKLIB_TOOLS),)
define CRACKLIB_REMOVE_TOOLS
	rm -f $(TARGET_DIR)/usr/sbin/*cracklib*
endef
CRACKLIB_POST_INSTALL_TARGET_HOOKS += CRACKLIB_REMOVE_TOOLS
endif

define CRACKLIB_BUILD_DICT
	$(HOST_MAKE_ENV) cracklib-format $(CRACKLIB_DICT_SOURCE) | \
		$(HOST_MAKE_ENV) cracklib-packer $(TARGET_DIR)/usr/share/cracklib/pw_dict
	rm $(TARGET_DIR)/usr/share/cracklib/cracklib-small
endef
CRACKLIB_POST_INSTALL_TARGET_HOOKS += CRACKLIB_BUILD_DICT

$(eval $(autotools-package))
$(eval $(host-autotools-package))
