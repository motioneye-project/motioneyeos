#############################################################
#
# alsa-lib
#
#############################################################

ALSA_LIB_VERSION = 1.0.25
ALSA_LIB_SOURCE = alsa-lib-$(ALSA_LIB_VERSION).tar.bz2
ALSA_LIB_SITE = ftp://ftp.alsa-project.org/pub/lib
ALSA_LIB_LICENSE = LGPLv2.1+
ALSA_LIB_LICENSE_FILES = COPYING
ALSA_LIB_INSTALL_STAGING = YES
ALSA_LIB_CFLAGS=$(TARGET_CFLAGS)
ALSA_LIB_CONF_OPT = --with-alsa-devdir=$(call qstrip,$(BR2_PACKAGE_ALSA_LIB_DEVDIR)) \
		    --with-pcm-plugins="$(call qstrip,$(BR2_PACKAGE_ALSA_LIB_PCM_PLUGINS))" \
		    --with-ctl-plugins="$(call qstrip,$(BR2_PACKAGE_ALSA_LIB_CTL_PLUGINS))" \
		    --without-versioned

# Can't build with static & shared at the same time (1.0.25+)
ifeq ($(BR2_PREFER_STATIC),y)
ALSA_LIB_CONF_OPT += --enable-shared=no
else
ALSA_LIB_CONF_OPT += --enable-static=no
endif

ifneq ($(BR2_PACKAGE_ALSA_LIB_ALOAD),y)
ALSA_LIB_CONF_OPT += --disable-aload
endif
ifneq ($(BR2_PACKAGE_ALSA_LIB_MIXER),y)
ALSA_LIB_CONF_OPT += --disable-mixer
endif
ifneq ($(BR2_PACKAGE_ALSA_LIB_PCM),y)
ALSA_LIB_CONF_OPT += --disable-pcm
endif
ifneq ($(BR2_PACKAGE_ALSA_LIB_RAWMIDI),y)
ALSA_LIB_CONF_OPT += --disable-rawmidi
endif
ifneq ($(BR2_PACKAGE_ALSA_LIB_HWDEP),y)
ALSA_LIB_CONF_OPT += --disable-hwdep
endif
ifneq ($(BR2_PACKAGE_ALSA_LIB_SEQ),y)
ALSA_LIB_CONF_OPT += --disable-seq
endif
ifneq ($(BR2_PACKAGE_ALSA_LIB_ALISP),y)
ALSA_LIB_CONF_OPT += --disable-alisp
endif
ifneq ($(BR2_PACKAGE_ALSA_LIB_OLD_SYMBOLS),y)
ALSA_LIB_CONF_OPT += --disable-old-symbols
endif

ifeq ($(BR2_ENABLE_DEBUG),y)
ALSA_LIB_CONF_OPT += --enable-debug
endif

ifeq ($(BR2_avr32),y)
ALSA_LIB_CFLAGS+=-DAVR32_INLINE_BUG
endif

ifeq ($(BR2_PACKAGE_ALSA_LIB_PYTHON),y)
ALSA_LIB_CONF_OPT += \
	--with-pythonlibs=-lpython$(PYTHON_VERSION_MAJOR) \
	--with-pythonincludes=$(STAGING_DIR)/usr/include/python$(PYTHON_VERSION_MAJOR)
ALSA_LIB_CFLAGS+=-I$(STAGING_DIR)/usr/include/python$(PYTHON_VERSION_MAJOR)
ALSA_LIB_DEPENDENCIES = python
else
ALSA_LIB_CONF_OPT += --disable-python
endif

ifeq ($(BR2_SOFT_FLOAT),y)
ALSA_LIB_CONF_OPT += --with-softfloat
endif

ALSA_LIB_CONF_ENV = CFLAGS="$(ALSA_LIB_CFLAGS)" \
		    LDFLAGS="$(TARGET_LDFLAGS) -lm"

define ALSA_LIB_UNINSTALL_TARGET_CMDS
	-rm -f $(TARGET_DIR)/usr/lib/libasound.so*
	-rm -rf $(TARGET_DIR)/usr/lib/alsa-lib
	-rm -rf $(TARGET_DIR)/usr/share/alsa
endef

define ALSA_LIB_UNINSTALL_STAGING_CMDS
	-rm -f $(STAGING_DIR)/usr/lib/libasound.*
	-rm -rf $(STAGING_DIR)/usr/lib/alsa-lib
	-rm -rf $(STAGING_DIR)/usr/share/alsa
endef

$(eval $(autotools-package))
