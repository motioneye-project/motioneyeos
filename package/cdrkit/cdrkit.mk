#############################################################
#
# cdrkit
#
#############################################################

CDRKIT_VERSION = 1.1.11
CDRKIT_SITE = http://www.cdrkit.org/releases
CDRKIT_DEPENDENCIES = libcap bzip2 zlib

ifeq ($(BR2_ENDIAN),"BIG")
CMAKE_ENDIAN_OPT=-DBITFIELDS_HTOL=1
else
CMAKE_ENDIAN_OPT=-DBITFIELDS_HTOL=0
endif

CDRKIT_CONF_OPT += $(CMAKE_ENDIAN_OPT)

## cdrkit isn't completely re-rooted by CMAKE_FIND_ROOT_PATH, so add
## some extra flags so it finds needed libs and headers.
CDRKIT_CONF_OPT += -DCMAKE_C_FLAGS="-I$(STAGING_DIR)/usr/include"
CDRKIT_CONF_OPT += -DCMAKE_EXE_LINKER_FLAGS="$(TARGET_LDFLAGS)"
HOST_CDRKIT_CONF_OPT += -DCMAKE_C_FLAGS="-I$(HOST_DIR)/usr/include"
HOST_CDRKIT_CONF_OPT += -DCMAKE_EXE_LINKER_FLAGS="$(HOST_LDFLAGS)"

$(eval $(cmake-package))
$(eval $(host-cmake-package))
