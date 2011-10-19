#############################################################
#
# libmodbus
#
#############################################################
LIBMODBUS_VERSION = 3.0.1
LIBMODBUS_SITE = http://github.com/downloads/stephane/libmodbus
LIBMODBUS_SOURCE = libmodbus-$(LIBMODBUS_VERSION).tar.gz
LIBMODBUS_INSTALL_STAGING = YES

$(eval $(call AUTOTARGETS))
