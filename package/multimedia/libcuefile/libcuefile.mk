################################################################################
#
# libcuefile
#
################################################################################

LIBCUEFILE_VERSION = r453
LIBCUEFILE_SITE = http://files.musepack.net/source
LIBCUEFILE_SOURCE = libcuefile_$(LIBCUEFILE_VERSION).tar.gz
LIBCUEFILE_DEPENDENCIES = host-cmake
LIBCUEFILE_INSTALL_STAGING = YES

# CMake doesn't support having the --sysroot option directly in the
# compiler path, so move this option to the CFLAGS/CXXFLAGS variables.
# It also gets confused by ccache, so don't use ccache here.
LIBCUEFILE_TARGET_CC = $(filter-out --sysroot=%,$(TARGET_CC_NOCCACHE))
LIBCUEFILE_TARGET_CFLAGS = $(filter --sysroot=%,$(TARGET_CC)) $(TARGET_CFLAGS)

define LIBCUEFILE_CONFIGURE_CMDS
	(cd $(@D) ; \
		$(HOST_DIR)/usr/bin/cmake . \
		-DCMAKE_C_COMPILER:FILEPATH="$(LIBCUEFILE_TARGET_CC)" \
		-DCMAKE_C_FLAGS:STRING="$(LIBCUEFILE_TARGET_CFLAGS)" \
		-DCMAKE_INSTALL_PREFIX:PATH="/usr" \
	)
endef

define LIBCUEFILE_BUILD_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) -C $(@D)
endef

define LIBCUEFILE_INSTALL_STAGING_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) -C $(@D) DESTDIR="$(STAGING_DIR)" install
	cp -r $(@D)/include $(STAGING_DIR)/usr
endef

define LIBCUEFILE_INSTALL_TARGET_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) -C $(@D) DESTDIR="$(TARGET_DIR)" install
	cp -r $(@D)/include $(TARGET_DIR)/usr
endef

$(eval $(call GENTARGETS,package/multimedia,libcuefile))
