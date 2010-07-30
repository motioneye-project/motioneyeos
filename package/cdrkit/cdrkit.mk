CDRKIT_VERSION=1.1.10
CDRKIT_SOURCE=cdrkit-$(CDRKIT_VERSION).tar.gz
CDRKIT_SITE=http://www.cdrkit.org/releases/

CDRKIT_DEPENDENCIES=libcap bzip2 host-cmake zlib
HOST_CDRKIT_DEPENDENCIES=host-libcap host-cmake host-bzip2 host-zlib

ifeq ($(BR2_ENDIAN),"BIG")
CMAKE_ENDIAN_OPT=-DBITFIELDS_HTOL=1
else
CMAKE_ENDIAN_OPT=-DBITFIELDS_HTOL=0
endif

# CMake doesn't support having the --sysroot option directly in the
# compiler path, so move this option to the CFLAGS/CXXFLAGS variables.
CDRKIT_TARGET_CC = $(filter-out --sysroot=%,$(TARGET_CC))
CDRKIT_TARGET_CXX = $(filter-out --sysroot=%,$(TARGET_CXX))
CDRKIT_TARGET_CFLAGS = $(filter --sysroot=%,$(TARGET_CC)) $(TARGET_CFLAGS)
CDRKIT_TARGET_CXXFLAGS = $(filter --sysroot=%,$(TARGET_CXX)) $(TARGET_CXXFLAGS)

define CDRKIT_CONFIGURE_CMDS
 -mkdir $(@D)/build
 (cd $(@D)/build ; \
	$(HOST_DIR)/usr/bin/cmake .. \
		-Wno-dev \
		-DCMAKE_SYSTEM_NAME:STRING="Linux" \
		-DCMAKE_C_COMPILER:FILEPATH="$(CDRKIT_TARGET_CC)" \
		-DCMAKE_CXX_COMPILER:FILEPATH="$(CDRKIT_TARGET_CXX)" \
		-DCMAKE_C_FLAGS:STRING="$(CDRKIT_TARGET_CFLAGS)" \
		-DCMAKE_CXX_FLAGS:STRING="$(CDRKIT_TARGET_CXXFLAGS)" \
		-DCMAKE_EXE_LINKER_FLAGS:STRING="$(TARGET_LDFLAGS)" \
		-DCMAKE_MODULE_LINKER_FLAGS:STRING="$(TARGET_LDFLAGS)" \
		-DCMAKE_SHARED_LINKER_FLAGS:STRING="$(TARGET_LDFLAGS)" \
		-DCMAKE_FIND_ROOT_PATH:PATH="$(STAGING_DIR)" \
		-DCMAKE_INSTALL_PREFIX:PATH="$(TARGET_DIR)/usr" \
		$(CMAKE_ENDIAN_OPT) \
 )
endef

define CDRKIT_BUILD_CMDS
 $(TARGET_MAKE_ENV) $(MAKE) -C $(@D)/build
endef

define CDRKIT_INSTALL_TARGET_CMDS
 $(TARGET_MAKE_ENV) $(MAKE) -C $(@D)/build install
endef

define HOST_CDRKIT_CONFIGURE_CMDS
 -mkdir $(@D)/build
 (cd $(@D)/build ; \
	$(HOST_DIR)/usr/bin/cmake .. \
		-Wno-dev \
		-DCMAKE_C_FLAGS="$(HOST_CFLAGS)" \
		-DCMAKE_EXE_LINKER_FLAGS:STRING="$(HOST_LDFLAGS)" \
		-DCMAKE_MODULE_LINKER_FLAGS:STRING="$(HOST_LDFLAGS)" \
		-DCMAKE_SHARED_LINKER_FLAGS:STRING="$(HOST_LDFLAGS)" \
		-DCMAKE_INSTALL_PREFIX:STRING="$(HOST_DIR)/usr" \
 )
endef

define HOST_CDRKIT_BUILD_CMDS
 $(HOST_MAKE_ENV) $(MAKE) -C $(@D)/build
endef

define HOST_CDRKIT_INSTALL_CMDS
 $(HOST_MAKE_ENV) $(MAKE) -C $(@D)/build  install
endef

$(eval $(call GENTARGETS,package,cdrkit))
$(eval $(call GENTARGETS,package,cdrkit,host))

