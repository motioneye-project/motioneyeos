################################################################################
#
# libcrossguid
#
################################################################################

LIBCROSSGUID_VERSION = v0.2.2
LIBCROSSGUID_SITE = $(call github,graeme-hill,crossguid,$(LIBCROSSGUID_VERSION))
LIBCROSSGUID_LICENSE = MIT
LIBCROSSGUID_LICENSE_FILES = LICENSE
LIBCROSSGUID_INSTALL_STAGING = YES
# only a static library
LIBCROSSGUID_INSTALL_TARGET = NO
LIBCROSSGUID_DEPENDENCIES = util-linux

define LIBCROSSGUID_BUILD_CMDS
	(cd $(@D); $(TARGET_CXX) $(TARGET_CXXFLAGS) -std=c++11 -DGUID_LIBUUID \
		-c Guid.cpp -o guid.o)
	(cd $(@D); $(TARGET_AR) rvs libcrossguid.a guid.o)
endef

define LIBCROSSGUID_INSTALL_STAGING_CMDS
	$(INSTALL) -D -m 644 $(@D)/libcrossguid.a \
		$(STAGING_DIR)/usr/lib/libcrossguid.a
	$(INSTALL) -D -m 644 $(@D)/Guid.hpp $(STAGING_DIR)/usr/include/guid.h
endef

$(eval $(generic-package))
