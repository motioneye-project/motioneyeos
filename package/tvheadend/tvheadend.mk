################################################################################
#
# tvheadend
#
################################################################################

TVHEADEND_VERSION = 17dff3e5ffbd67174b6c0d7b49f5488e19ec1ead
TVHEADEND_SITE = $(call github,tvheadend,tvheadend,$(TVHEADEND_VERSION))
TVHEADEND_LICENSE = GPL-3.0+
TVHEADEND_LICENSE_FILES = LICENSE.md
TVHEADEND_DEPENDENCIES = \
	host-gettext \
	host-pkgconf \
	host-pngquant \
	$(if $(BR2_PACKAGE_PYTHON3),host-python3,host-python) \
	openssl

ifeq ($(BR2_PACKAGE_AVAHI),y)
TVHEADEND_DEPENDENCIES += avahi
endif

ifeq ($(BR2_PACKAGE_DBUS),y)
TVHEADEND_DEPENDENCIES += dbus
TVHEADEND_CONF_OPTS += --enable-dbus-1
else
TVHEADEND_CONF_OPTS += --disable-dbus-1
endif

ifeq ($(BR2_PACKAGE_TVHEADEND_TRANSCODING),y)
TVHEADEND_CONF_OPTS += --enable-libav --enable-libx264
TVHEADEND_DEPENDENCIES += ffmpeg x264
ifeq ($(BR2_PACKAGE_LIBVA)$(BR2_PACKAGE_XORG7),yy)
TVHEADEND_CONF_OPTS += --enable-vaapi
TVHEADEND_DEPENDENCIES += libva
else
TVHEADEND_CONF_OPTS += --disable-vaapi
endif
ifeq ($(BR2_PACKAGE_OPUS),y)
TVHEADEND_CONF_OPTS += --enable-libopus
TVHEADEND_DEPENDENCIES += opus
else
TVHEADEND_CONF_OPTS += --disable-libopus
endif
ifeq ($(BR2_PACKAGE_RPI_USERLAND),y)
TVHEADEND_CONF_OPTS += --enable-omx
TVHEADEND_DEPENDENCIES += rpi-userland
else
TVHEADEND_CONF_OPTS += --disable-omx
endif
ifeq ($(BR2_PACKAGE_X265),y)
TVHEADEND_CONF_OPTS += --enable-libx265
TVHEADEND_DEPENDENCIES += x265
else
TVHEADEND_CONF_OPTS += --disable-libx265
endif
else
TVHEADEND_CONF_OPTS += \
	--disable-libav \
	--disable-libopus \
	--disable-omx \
	--disable-vaapi \
	--disable-libx264 \
	--disable-libx265
endif

ifeq ($(BR2_PACKAGE_LIBDVBCSA),y)
TVHEADEND_DEPENDENCIES += libdvbcsa
TVHEADEND_CONF_OPTS += --enable-tvhcsa
else
TVHEADEND_CONF_OPTS += --disable-tvhcsa
endif

ifeq ($(BR2_PACKAGE_LIBHDHOMERUN),y)
TVHEADEND_DEPENDENCIES += libhdhomerun
TVHEADEND_CONF_OPTS += --enable-hdhomerun_client
else
TVHEADEND_CONF_OPTS += --disable-hdhomerun_client
endif

ifeq ($(BR2_PACKAGE_LIBICONV),y)
TVHEADEND_DEPENDENCIES += libiconv
endif

TVHEADEND_CFLAGS = $(TARGET_CFLAGS)
ifeq ($(BR2_PACKAGE_LIBURIPARSER),y)
TVHEADEND_DEPENDENCIES += liburiparser
TVHEADEND_CFLAGS += $(if $(BR2_USE_WCHAR),,-DURI_NO_UNICODE)
endif

ifeq ($(BR2_PACKAGE_PCRE),y)
TVHEADEND_DEPENDENCIES += pcre
TVHEADEND_CONF_OPTS += --enable-pcre
else
TVHEADEND_CONF_OPTS += --disable-pcre
endif

TVHEADEND_DEPENDENCIES += dtv-scan-tables

# The tvheadend build system expects the transponder data to be present inside
# its source tree. To prevent a download initiated by the build system just
# copy the data files in the right place and add the corresponding stamp file.
define TVHEADEND_INSTALL_DTV_SCAN_TABLES
	$(INSTALL) -d $(@D)/data/dvb-scan
	cp -r $(TARGET_DIR)/usr/share/dvb/* $(@D)/data/dvb-scan/
	touch $(@D)/data/dvb-scan/.stamp
endef
TVHEADEND_PRE_CONFIGURE_HOOKS += TVHEADEND_INSTALL_DTV_SCAN_TABLES

define TVHEADEND_CONFIGURE_CMDS
	(cd $(@D); \
		$(TARGET_CONFIGURE_OPTS) \
		$(TARGET_CONFIGURE_ARGS) \
		CFLAGS="$(TVHEADEND_CFLAGS)" \
		./configure \
			--prefix=/usr \
			--arch="$(ARCH)" \
			--cpu="$(GCC_TARGET_CPU)" \
			--nowerror \
			--python="$(HOST_DIR)/bin/python" \
			--enable-dvbscan \
			--enable-bundle \
			--enable-pngquant \
			--disable-ffmpeg_static \
			--disable-hdhomerun_static \
			$(TVHEADEND_CONF_OPTS) \
	)
endef

define TVHEADEND_FIX_PNGQUANT_PATH
	$(SED) "s%^pngquant_bin =.*%pngquant_bin = '$(HOST_DIR)/bin/pngquant'%" \
		$(@D)/support/mkbundle
endef
TVHEADEND_POST_CONFIGURE_HOOKS += TVHEADEND_FIX_PNGQUANT_PATH

define TVHEADEND_BUILD_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) -C $(@D)
endef

define TVHEADEND_INSTALL_TARGET_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) -C $(@D) DESTDIR="$(TARGET_DIR)" install
endef

# Remove documentation and source files that are not needed because we
# use the bundled web interface version.
define TVHEADEND_CLEAN_SHARE
	rm -rf $(TARGET_DIR)/usr/share/tvheadend/docs
	rm -rf $(TARGET_DIR)/usr/share/tvheadend/src
endef

TVHEADEND_POST_INSTALL_TARGET_HOOKS += TVHEADEND_CLEAN_SHARE

#----------------------------------------------------------------------------
# To run tvheadend, we need:
#  - a startup script, and its config file
#  - a non-root user to run as, and a home for it that is not accessible
#    to the other users (because there will be crendentials in there)

define TVHEADEND_INSTALL_INIT_SYSV
	$(INSTALL) -D package/tvheadend/etc.default.tvheadend $(TARGET_DIR)/etc/default/tvheadend
	$(INSTALL) -D package/tvheadend/S99tvheadend          $(TARGET_DIR)/etc/init.d/S99tvheadend
endef

define TVHEADEND_USERS
	tvheadend -1 tvheadend -1 * /home/tvheadend - video TVHeadend daemon
endef
define TVHEADEND_PERMISSIONS
	/home/tvheadend r 0700 tvheadend tvheadend - - - - -
endef

$(eval $(generic-package))
