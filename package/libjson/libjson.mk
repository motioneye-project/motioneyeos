#############################################################
#
# libjson
#
#############################################################

LIBJSON_VERSION = 7.6.1
LIBJSON_SITE = http://downloads.sourceforge.net/project/libjson
LIBJSON_SOURCE = libjson_$(LIBJSON_VERSION).zip
LIBJSON_INSTALL_STAGING = YES
LIBJSON_LICENSE = BSD-2c
LIBJSON_LICENSE_FILES = License.txt

LIBJSON_MAKE_OPT = BUILD_TYPE= SHARED=$(if $(BR2_PREFER_STATIC_LIB),0,1) \
	CXXFLAGS="$(TARGET_CXXFLAGS) -DNDEBUG"

define LIBJSON_EXTRACT_CMDS
	unzip -d $(@D) $(DL_DIR)/$(LIBJSON_SOURCE)
	mv $(@D)/libjson/* $(@D)
	$(RM) -r $(@D)/libjson
	$(SED) '/ldconfig/d' $(@D)/makefile
endef

define LIBJSON_BUILD_CMDS
	mkdir -p $(@D)/Objects_$(if $(BR2_PREFER_STATIC_LIB),static,shared) \
		$(@D)/_internal/Source/Dependencies
	$(TARGET_MAKE_ENV) $(MAKE) $(TARGET_CONFIGURE_OPTS) \
		$(LIBJSON_MAKE_OPT) -C $(@D)
endef

define LIBJSON_INSTALL_TARGET_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) $(TARGET_CONFIGURE_OPTS) \
		$(LIBJSON_MAKE_OPT) prefix=$(TARGET_DIR)/usr install -C $(@D)
endef

define LIBJSON_UNINSTALL_TARGET_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) $(TARGET_CONFIGURE_OPTS) \
		$(LIBJSON_MAKE_OPT) prefix=$(TARGET_DIR)/usr uninstall -C $(@D)
endef

define LIBJSON_INSTALL_STAGING_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) $(TARGET_CONFIGURE_OPTS) \
		$(LIBJSON_MAKE_OPT) prefix=$(STAGING_DIR)/usr install -C $(@D)
endef

define LIBJSON_UNINSTALL_STAGING_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) $(TARGET_CONFIGURE_OPTS) \
		$(LIBJSON_MAKE_OPT) prefix=$(STAGING_DIR)/usr uninstall -C $(@D)
endef

define LIBJSON_CLEAN_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) $(TARGET_CONFIGURE_OPTS) $(LIBJSON_MAKE_OPT) \
		clean -C $(@D)
endef

$(eval $(generic-package))
