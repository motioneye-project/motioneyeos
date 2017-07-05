################################################################################
#
# mfgtools
#
################################################################################

MFGTOOLS_VERSION = b219fc219a35c365010897ed093c40750f8cdac6
MFGTOOLS_SITE = $(call github,NXPmicro,mfgtools,$(MFGTOOLS_VERSION))
MFGTOOLS_SUBDIR = MfgToolLib
MFGTOOLS_LICENSE = BSD-3-Clause or CPOL
MFGTOOLS_LICENSE_FILES = LICENSE CPOL.htm
HOST_MFGTOOLS_DEPENDENCIES = host-libusb

HOST_MFGTOOLS_CFLAGS = \
	$(HOST_CFLAGS) $(HOST_LDFLAGS) -std=c++11 -lpthread \
	-L$(@D)/MfgToolLib -lMfgToolLib -I$(@D)/MfgToolLib \
	-lusb-1.0 -I$(HOST_DIR)/include/libusb-1.0 \
	-fpermissive -Wno-write-strings

define HOST_MFGTOOLS_CLI_BUILD
	$(HOST_CONFIGURE_OPTS) $(MAKE) CC="$(HOSTCXX)" \
		CFLAGS="$(HOST_MFGTOOLS_CFLAGS)" -C $(@D)/TestPrgm
endef

HOST_MFGTOOLS_POST_BUILD_HOOKS += HOST_MFGTOOLS_CLI_BUILD

define HOST_MFGTOOLS_INSTALL_CMDS
	$(INSTALL) -D -m 755 $(@D)/MfgToolLib/libMfgToolLib.so \
		$(HOST_DIR)/lib/libMfgToolLib.so
	$(INSTALL) -D -m 755 $(@D)/TestPrgm/mfgtoolcli \
		$(HOST_DIR)/bin/mfgtoolcli
endef

$(eval $(host-cmake-package))
