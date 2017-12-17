################################################################################
#
# tvheadend
#
################################################################################

TVHEADEND_VERSION = e5f5a4278949afc96e26d6cd50cf968e0e92d7b6
TVHEADEND_SITE = $(call github,tvheadend,tvheadend,$(TVHEADEND_VERSION))
TVHEADEND_LICENSE = GPLv3+
TVHEADEND_LICENSE_FILES = LICENSE.md
TVHEADEND_DEPENDENCIES = \
	host-gettext \
	host-pkgconf \
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

ifeq ($(BR2_PACKAGE_FFMPEG),y)
TVHEADEND_DEPENDENCIES += ffmpeg
TVHEADEND_CONF_OPTS += --enable-libav
else
TVHEADEND_CONF_OPTS += --disable-libav
endif

ifeq ($(BR2_PACKAGE_LIBDVBCSA),y)
TVHEADEND_DEPENDENCIES += libdvbcsa
TVHEADEND_CONF_OPTS += --enable-dvbcsa
else
TVHEADEND_CONF_OPTS += --disable-dvbcsa
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
	(cd $(@D);						\
		$(TARGET_CONFIGURE_OPTS)			\
		$(TARGET_CONFIGURE_ARGS)			\
		CFLAGS="$(TVHEADEND_CFLAGS)"			\
		./configure					\
			--prefix=/usr				\
			--arch="$(ARCH)"			\
			--cpu="$(BR2_GCC_TARGET_CPU)"		\
			--nowerror				\
			--python="$(HOST_DIR)/usr/bin/python"	\
			--enable-dvbscan			\
			--enable-bundle				\
			--disable-ffmpeg_static			\
			--disable-hdhomerun_static		\
			$(TVHEADEND_CONF_OPTS)			\
	)
endef

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
