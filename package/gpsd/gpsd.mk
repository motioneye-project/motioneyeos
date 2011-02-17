#############################################################
#
# gpsd
#
#############################################################

GPSD_VERSION = 2.95
GPSD_SITE = http://download.berlios.de/gpsd
GPSD_INSTALL_STAGING = YES
GPSD_CONF_OPT = --disable-static
GPSD_TARGET_BINS = cgps gpsctl gpsdecode gpsmon gpspipe gpxlogger lcdgps

# Build libgpsmm if we've got C++
ifeq ($(BR2_INSTALL_LIBSTDCPP),y)
	GPSD_CONF_OPT += --enable-libgpsmm LDFLAGS="$(TARGET_LDFLAGS) -lstdc++"
else
	GPSD_CONF_OPT += --disable-libgpsmm
endif

# Enable or disable Qt binding
ifeq ($(BR2_PACKAGE_QT_NETWORK),y)
	GPSD_CONF_ENV += QMAKE="$(QT_QMAKE)"
	GPSD_CONF_OPT += --enable-libQgpsmm
	GPSD_DEPENDENCIES += qt host-pkg-config
else
	GPSD_CONF_OPT += --disable-libQgpsmm
endif

# If libusb is available build it before so the package can use it
ifeq ($(BR2_PACKAGE_LIBUSB),y)
	GPSD_DEPENDENCIES += libusb
endif

ifeq ($(strip $(BR2_PACKAGE_DBUS)),y)
	GPSD_CONF_OPT += --enable-dbus
	GPSD_DEPENDENCIES += dbus dbus-glib
endif

ifeq ($(BR2_PACKAGE_NCURSES),y)
	GPSD_DEPENDENCIES += ncurses
endif

# Protocol support
ifneq ($(BR2_PACKAGE_GPSD_ASHTECH),y)
	GPSD_CONF_OPT += --disable-ashtech
endif
ifneq ($(BR2_PACKAGE_GPSD_AIVDM),y)
	GPSD_CONF_OPT += --disable-aivdm
endif
ifneq ($(BR2_PACKAGE_GPSD_EARTHMATE),y)
	GPSD_CONF_OPT += --disable-earthmate
endif
ifneq ($(BR2_PACKAGE_GPSD_EVERMORE),y)
	GPSD_CONF_OPT += --disable-evermore
endif
ifneq ($(BR2_PACKAGE_GPSD_FV18),y)
	GPSD_CONF_OPT += --disable-fv18
endif
ifneq ($(BR2_PACKAGE_GPSD_GARMIN),y)
	GPSD_CONF_OPT += --disable-garmin
endif
ifeq ($(BR2_PACKAGE_GPSD_GARMIN_SIMPLE_TXT),y)
	GPSD_CONF_OPT += --enable-garmintxt
endif
ifneq ($(BR2_PACKAGE_GPSD_GPSCLOCK),y)
	GPSD_CONF_OPT += --disable-gpsclock
endif
ifneq ($(BR2_PACKAGE_GPSD_ITRAX),y)
	GPSD_CONF_OPT += --disable-itrax
endif
ifneq ($(BR2_PACKAGE_GPSD_MTK3301),y)
	GPSD_CONF_OPT += --disable-mtk3301
endif
ifneq ($(BR2_PACKAGE_GPSD_NMEA),y)
	GPSD_CONF_OPT += --disable-nmea
endif
ifneq ($(BR2_PACKAGE_GPSD_NTRIP),y)
	GPSD_CONF_OPT += --disable-ntrip
endif
ifneq ($(BR2_PACKAGE_GPSD_NAVCOM),y)
	GPSD_CONF_OPT += --disable-navcom
endif
ifneq ($(BR2_PACKAGE_GPSD_OCEANSERVER),y)
	GPSD_CONF_OPT += --disable-oceanserver
endif
ifneq ($(BR2_PACKAGE_GPSD_ONCORE),y)
	GPSD_CONF_OPT += --disable-oncore
endif
ifneq ($(BR2_PACKAGE_GPSD_RTCM104V2),y)
	GPSD_CONF_OPT += --disable-rtcm104v2
endif
ifneq ($(BR2_PACKAGE_GPSD_RTCM104V3),y)
	GPSD_CONF_OPT += --disable-rtcm104v3
endif
ifneq ($(BR2_PACKAGE_GPSD_SIRF),y)
	GPSD_CONF_OPT += --disable-sirf
endif
ifneq ($(BR2_PACKAGE_GPSD_SUPERSTAR2),y)
	GPSD_CONF_OPT += --disable-superstar2
endif
ifneq ($(BR2_PACKAGE_GPSD_TRIMBLE_TSIP),y)
	GPSD_CONF_OPT += --disable-tsip
endif
ifneq ($(BR2_PACKAGE_GPSD_TRIPMATE),y)
	GPSD_CONF_OPT += --disable-tripmate
endif
ifeq ($(BR2_PACKAGE_GPSD_TRUE_NORTH),y)
	GPSD_CONF_OPT += --enable-tnt
endif
ifneq ($(BR2_PACKAGE_GPSD_UBX),y)
	GPSD_CONF_OPT += --disable-ubx
endif

# Features
ifneq ($(BR2_PACKAGE_GPSD_NTP_SHM),y)
	GPSD_CONF_OPT += --disable-ntpshm
endif
ifneq ($(BR2_PACKAGE_GPSD_PPS),y)
	GPSD_CONF_OPT += --disable-pps
endif
ifeq ($(BR2_PACKAGE_GPSD_PPS_ON_CTS),y)
	GPSD_CONF_OPT += --enable-pps-on-cts
endif
ifeq ($(BR2_PACKAGE_GPSD_SQUELCH),y)
	GPSD_CONF_OPT += --enable-squelch
endif
ifneq ($(BR2_PACKAGE_GPSD_RECONFIGURE),y)
	GPSD_CONF_OPT += --disable-reconfigure
endif
ifneq ($(BR2_PACKAGE_GPSD_CONTROLSEND),y)
	GPSD_CONF_OPT += --disable-controlsend
endif
ifeq ($(BR2_PACKAGE_GPSD_RAW),y)
	GPSD_CONF_OPT += --enable-raw
endif
ifneq ($(BR2_PACKAGE_GPSD_OLDSTYLE),y)
	GPSD_CONF_OPT += --disable-oldstyle
endif
ifeq ($(BR2_PACKAGE_GPSD_PROFILING),y)
	GPSD_CONF_OPT += --enable-profiling
endif
ifneq ($(BR2_PACKAGE_GPSD_TIMING),y)
	GPSD_CONF_OPT += --disable-timing
endif
ifneq ($(BR2_PACKAGE_GPSD_CLIENT_DEBUG),y)
	GPSD_CONF_OPT += --disable-clientdebug
endif
ifeq ($(BR2_PACKAGE_GPSD_USER),y)
	GPSD_CONF_OPT += --enable-gpsd-user=$(BR2_PACKAGE_GPSD_USER_VALUE)
endif
ifeq ($(BR2_PACKAGE_GPSD_GROUP),y)
	GPSD_CONF_OPT += --enable-gpsd-group=$(BR2_PACKAGE_GPSD_GROUP_VALUE)
endif
ifeq ($(BR2_PACKAGE_GPSD_FIXED_PORT_SPEED),y)
	GPSD_CONF_OPT += --enable-fixed-port-speed=$(BR2_PACKAGE_GPSD_FIXED_PORT_SPEED_VALUE)
endif
ifeq ($(BR2_PACKAGE_GPSD_MAX_CLIENT),y)
	GPSD_CONF_OPT += --enable-max-clients=$(BR2_PACKAGE_GPSD_MAX_CLIENT_VALUE)
endif
ifeq ($(BR2_PACKAGE_GPSD_MAX_DEV),y)
	GPSD_CONF_OPT += --enable-max-devices=$(BR2_PACKAGE_GPSD_MAX_DEV_VALUE)
endif

define GPSD_BUILDS_CMDS
	$(SED) 's|^hardcode_libdir_flag_spec=.*|hardcode_libdir_flag_spec=""|g' $(GPSD_DIR)/libtool
	$(SED) 's|^runpath_var=LD_RUN_PATH|runpath_var=DIE_RPATH_DIE|g' $(GPSD_DIR)/libtool
	$(TARGET_MAKE_ENV) $(MAKE) -C $(@D) all libgpsmm
endef

define GPSD_INSTALL_TARGET_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) -C $(@D) DESTDIR=$(TARGET_DIR) install
	if [ ! -f $(TARGET_DIR)/etc/init.d/S50gpsd ]; then \
		$(INSTALL) -m 0755 -D package/gpsd/S50gpsd $(TARGET_DIR)/etc/init.d/S50gpsd; \
		$(SED) 's,^DEVICES=.*,DEVICES=$(BR2_PACKAGE_GPSD_DEVICES),' $(TARGET_DIR)/etc/init.d/S50gpsd; \
	fi
endef

define GPSD_UNINSTALL_TARGET_CMDS
	rm -f $(addprefix $(TARGET_DIR)/usr/bin/, $(GPSD_TARGET_BINS))
	rm -f $(TARGET_DIR)/usr/lib/libgps.*
	rm -f $(TARGET_DIR)/usr/lib/libgpsd.*
	rm -f $(TARGET_DIR)/usr/sbin/gpsd
	rm -f $(TARGET_DIR)/etc/init.d/S50gpsd
endef

$(eval $(call AUTOTARGETS,package,gpsd))
