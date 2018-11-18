################################################################################
#
# libjson
#
################################################################################

LIBJSON_VERSION = 7.6.1
LIBJSON_SITE = http://downloads.sourceforge.net/project/libjson
LIBJSON_SOURCE = libjson_$(LIBJSON_VERSION).zip
LIBJSON_INSTALL_STAGING = YES
LIBJSON_LICENSE = BSD-2-Clause
LIBJSON_LICENSE_FILES = License.txt

LIBJSON_CXXFLAGS = $(TARGET_CFLAGS) -DNDEBUG

ifeq ($(BR2_STATIC_LIBS),y)
LIBJSON_MAKE_OPTS += SHARED=0
else
LIBJSON_MAKE_OPTS += SHARED=1
LIBJSON_CXXFLAGS += -fPIC
endif

LIBJSON_MAKE_OPTS += BUILD_TYPE= CXXFLAGS="$(LIBJSON_CXXFLAGS)"

define LIBJSON_EXTRACT_CMDS
	$(UNZIP) -d $(@D) $(LIBJSON_DL_DIR)/$(LIBJSON_SOURCE)
	mv $(@D)/libjson/* $(@D)
	$(RM) -r $(@D)/libjson
	$(SED) '/ldconfig/d' $(@D)/makefile
endef

define LIBJSON_BUILD_CMDS
	mkdir -p $(@D)/Objects_$(if $(BR2_STATIC_LIBS),static,shared) \
		$(@D)/_internal/Source/Dependencies
	$(TARGET_MAKE_ENV) $(MAKE) $(TARGET_CONFIGURE_OPTS) \
		$(LIBJSON_MAKE_OPTS) -C $(@D)
endef

define LIBJSON_INSTALL_TARGET_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) $(TARGET_CONFIGURE_OPTS) \
		$(LIBJSON_MAKE_OPTS) prefix=$(TARGET_DIR)/usr install -C $(@D)
endef

define LIBJSON_INSTALL_STAGING_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) $(TARGET_CONFIGURE_OPTS) \
		$(LIBJSON_MAKE_OPTS) prefix=$(STAGING_DIR)/usr install -C $(@D)
endef

$(eval $(generic-package))
