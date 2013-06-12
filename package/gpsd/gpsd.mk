################################################################################
#
# gpsd
#
################################################################################

GPSD_VERSION = 3.9
GPSD_SITE = http://download-mirror.savannah.gnu.org/releases/gpsd/
GPSD_LICENSE = BSD-3c
GPSD_LICENSE_FILES = COPYING
GPSD_INSTALL_STAGING = YES

GPSD_DEPENDENCIES = host-scons host-pkgconf

GPSD_LDFLAGS = $(TARGET_LDFLAGS)

GPSD_SCONS_ENV = $(TARGET_CONFIGURE_OPTS)

GPSD_SCONS_OPTS = \
	arch=$(ARCH)\
	prefix=/usr\
	chrpath=no\
	sysroot=$(STAGING_DIR)\
	strip=no\
	python=no

ifeq ($(BR2_PACKAGE_NCURSES),y)
	GPSD_DEPENDENCIES += ncurses
else
	GPSD_SCONS_OPTS += ncurses=no
endif

# Disable IPv6, if we don't support it
ifneq ($(BR2_INET_IPV6),y)
	GPSD_SCONS_OPTS += ipv6=no
endif

# Build libgpsmm if we've got C++
ifeq ($(BR2_INSTALL_LIBSTDCPP),y)
	GPSD_LDFLAGS += -lstdc++
	GPSD_SCONS_OPTS += libgpsmm=yes
else
	GPSD_SCONS_OPTS += libgpsmm=no
endif

# Enable or disable Qt binding
ifeq ($(BR2_PACKAGE_QT_NETWORK),y)
	GPSD_SCONS_ENV += QMAKE="$(QT_QMAKE)"
	GPSD_DEPENDENCIES += qt host-pkgconf
else
	GPSD_SCONS_OPTS += libQgpsmm=no
endif

# If libusb is available build it before so the package can use it
ifeq ($(BR2_PACKAGE_LIBUSB),y)
	GPSD_DEPENDENCIES += libusb
else
	GPSD_SCONS_OPTS += usb=no
endif

# If bluetooth is available build it before so the package can use it
ifeq ($(BR2_PACKAGE_BLUEZ_UTILS),y)
	GPSD_DEPENDENCIES += bluez_utils
else
	GPSD_SCONS_OPTS += bluez=no
endif

ifeq ($(BR2_PACKAGE_DBUS_GLIB),y)
	GPSD_SCONS_OPTS += dbus_export=yes
	GPSD_DEPENDENCIES += dbus-glib
endif

# Protocol support
ifneq ($(BR2_PACKAGE_GPSD_ASHTECH),y)
	GPSD_SCONS_OPTS += ashtech=no
endif
ifneq ($(BR2_PACKAGE_GPSD_AIVDM),y)
	GPSD_SCONS_OPTS += aivdm=no
endif
ifneq ($(BR2_PACKAGE_GPSD_EARTHMATE),y)
	GPSD_SCONS_OPTS += earthmate=no
endif
ifneq ($(BR2_PACKAGE_GPSD_EVERMORE),y)
	GPSD_SCONS_OPTS += evermore=no
endif
ifneq ($(BR2_PACKAGE_GPSD_FURY),y)
	GPSD_SCONS_OPTS += fury=no
endif
ifneq ($(BR2_PACKAGE_GPSD_FV18),y)
	GPSD_SCONS_OPTS += fv18=no
endif
ifneq ($(BR2_PACKAGE_GPSD_GARMIN),y)
	GPSD_SCONS_OPTS += garmin=no
endif
ifneq ($(BR2_PACKAGE_GPSD_GARMIN_SIMPLE_TXT),y)
	GPSD_SCONS_OPTS += garmintxt=no
endif
ifneq ($(BR2_PACKAGE_GPSD_GEOSTAR),y)
	GPSD_SCONS_OPTS += geostar=no
endif
ifneq ($(BR2_PACKAGE_GPSD_GPSCLOCK),y)
	GPSD_SCONS_OPTS += gpsclock=no
endif
ifneq ($(BR2_PACKAGE_GPSD_ITRAX),y)
	GPSD_SCONS_OPTS += itrax=no
endif
ifneq ($(BR2_PACKAGE_GPSD_MTK3301),y)
	GPSD_SCONS_OPTS += mtk3301=no
endif
ifneq ($(BR2_PACKAGE_GPSD_NMEA),y)
	GPSD_SCONS_OPTS += nmea=no
endif
ifneq ($(BR2_PACKAGE_GPSD_NTRIP),y)
	GPSD_SCONS_OPTS += ntrip=no
endif
ifneq ($(BR2_PACKAGE_GPSD_NAVCOM),y)
	GPSD_SCONS_OPTS += navcom=no
endif
ifneq ($(BR2_PACKAGE_GPSD_NMEA2000),y)
	GPSD_SCONS_OPTS += nmea2000=no
endif
ifneq ($(BR2_PACKAGE_GPSD_OCEANSERVER),y)
	GPSD_SCONS_OPTS += oceanserver=no
endif
ifneq ($(BR2_PACKAGE_GPSD_ONCORE),y)
	GPSD_SCONS_OPTS += oncore=no
endif
ifneq ($(BR2_PACKAGE_GPSD_RTCM104V2),y)
	GPSD_SCONS_OPTS += rtcm104v2=no
endif
ifneq ($(BR2_PACKAGE_GPSD_RTCM104V3),y)
	GPSD_SCONS_OPTS += rtcm104v3=no
endif
ifneq ($(BR2_PACKAGE_GPSD_SIRF),y)
	GPSD_SCONS_OPTS += sirf=no
endif
ifneq ($(BR2_PACKAGE_GPSD_SUPERSTAR2),y)
	GPSD_SCONS_OPTS += superstar2=no
endif
ifneq ($(BR2_PACKAGE_GPSD_TRIMBLE_TSIP),y)
	GPSD_SCONS_OPTS += tsip=no
endif
ifneq ($(BR2_PACKAGE_GPSD_TRIPMATE),y)
	GPSD_SCONS_OPTS += tripmate=no
endif
ifneq ($(BR2_PACKAGE_GPSD_TRUE_NORTH),y)
	GPSD_SCONS_OPTS += tnt=no
endif
ifneq ($(BR2_PACKAGE_GPSD_UBX),y)
	GPSD_SCONS_OPTS += ubx=no
endif

# Features
ifneq ($(BR2_PACKAGE_GPSD_NTP_SHM),y)
	GPSD_SCONS_OPTS += ntpshm=no
endif
ifneq ($(BR2_PACKAGE_GPSD_PPS),y)
	GPSD_SCONS_OPTS += pps=no
endif
ifeq ($(BR2_PACKAGE_GPSD_SQUELCH),y)
	GPSD_SCONS_OPTS += squelch=yes
endif
ifneq ($(BR2_PACKAGE_GPSD_RECONFIGURE),y)
	GPSD_SCONS_OPTS += reconfigure=no
endif
ifneq ($(BR2_PACKAGE_GPSD_CONTROLSEND),y)
	GPSD_SCONS_OPTS += controlsend=no
endif
ifneq ($(BR2_PACKAGE_GPSD_OLDSTYLE),y)
	GPSD_SCONS_OPTS += oldstyle=no
endif
ifeq ($(BR2_PACKAGE_GPSD_PROFILING),y)
	GPSD_SCONS_OPTS += profiling=yes
endif
ifneq ($(BR2_PACKAGE_GPSD_CLIENT_DEBUG),y)
	GPSD_SCONS_OPTS += clientdebug=no
endif
ifeq ($(BR2_PACKAGE_GPSD_USER),y)
	GPSD_SCONS_OPTS += gpsd_user=$(BR2_PACKAGE_GPSD_USER_VALUE)
endif
ifeq ($(BR2_PACKAGE_GPSD_GROUP),y)
	GPSD_SCONS_OPTS += gpsd_group=$(BR2_PACKAGE_GPSD_GROUP_VALUE)
endif
ifeq ($(BR2_PACKAGE_GPSD_FIXED_PORT_SPEED),y)
	GPSD_SCONS_OPTS += fixed_port_speed=$(BR2_PACKAGE_GPSD_FIXED_PORT_SPEED_VALUE)
endif
ifeq ($(BR2_PACKAGE_GPSD_MAX_CLIENT),y)
	GPSD_SCONS_OPTS += limited_max_clients=$(BR2_PACKAGE_GPSD_MAX_CLIENT_VALUE)
endif
ifeq ($(BR2_PACKAGE_GPSD_MAX_DEV),y)
	GPSD_SCONS_OPTS += limited_max_devices=$(BR2_PACKAGE_GPSD_MAX_DEV_VALUE)
endif

GPSD_SCONS_ENV += LDFLAGS="$(GPSD_LDFLAGS)"

define GPSD_BUILD_CMDS
	(cd $(@D); \
		$(GPSD_SCONS_ENV) \
		$(SCONS) \
		$(GPSD_SCONS_OPTS))
endef

define GPSD_INSTALL_TARGET_CMDS
	(cd $(@D); \
		$(GPSD_SCONS_ENV) \
		DESTDIR=$(TARGET_DIR) \
		$(SCONS) \
		$(GPSD_SCONS_OPTS) \
		install)
	if [ ! -f $(TARGET_DIR)/etc/init.d/S50gpsd ]; then \
		$(INSTALL) -m 0755 -D package/gpsd/S50gpsd $(TARGET_DIR)/etc/init.d/S50gpsd; \
		$(SED) 's,^DEVICES=.*,DEVICES=$(BR2_PACKAGE_GPSD_DEVICES),' $(TARGET_DIR)/etc/init.d/S50gpsd; \
	fi
endef

define GPSD_INSTALL_STAGING_CMDS
	(cd $(@D); \
		$(GPSD_SCONS_ENV) \
		DESTDIR=$(STAGING_DIR) \
		$(SCONS) \
		$(GPSD_SCONS_OPTS) \
		install)
endef

ifeq ($(BR2_ROOTFS_DEVICE_CREATION_DYNAMIC_UDEV),y)
define GPSD_INSTALL_UDEV_RULES
	(cd $(@D); \
		$(GPSD_SCONS_ENV) \
		DESTDIR=$(TARGET_DIR) \
		$(SCONS) \
		$(GPSD_SCONS_OPTS) \
		udev-install)
endef

GPSD_POST_INSTALL_TARGET_HOOKS += GPSD_INSTALL_UDEV_RULES
endif

$(eval $(generic-package))
