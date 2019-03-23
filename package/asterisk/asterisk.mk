################################################################################
#
# asterisk
#
################################################################################

ASTERISK_VERSION = 16.2.1
# Use the github mirror: it's an official mirror maintained by Digium, and
# provides tarballs, which the main Asterisk git tree (behind Gerrit) does not.
ASTERISK_SITE = $(call github,asterisk,asterisk,$(ASTERISK_VERSION))

ASTERISK_SOUNDS_BASE_URL = http://downloads.asterisk.org/pub/telephony/sounds/releases
ASTERISK_EXTRA_DOWNLOADS = \
	$(ASTERISK_SOUNDS_BASE_URL)/asterisk-core-sounds-en-gsm-1.6.1.tar.gz \
	$(ASTERISK_SOUNDS_BASE_URL)/asterisk-moh-opsound-wav-2.03.tar.gz

ASTERISK_LICENSE = GPL-2.0, BSD-3c (SHA1, resample), BSD-4c (db1-ast)
ASTERISK_LICENSE_FILES = \
	COPYING \
	main/sha1.c \
	codecs/speex/speex_resampler.h \
	utils/db1-ast/include/db.h

# For patches 0002, 0003 and 0005
ASTERISK_AUTORECONF = YES
ASTERISK_AUTORECONF_OPTS = -Iautoconf -Ithird-party -Ithird-party/pjproject -Ithird-party/jansson

ASTERISK_DEPENDENCIES = \
	host-asterisk \
	jansson \
	libcurl \
	libedit \
	libxml2 \
	sqlite \
	util-linux

# Asterisk wants to run its menuselect tool (a highly tweaked derivative of
# kconfig), but builds it using the target tools. So we build it in the host
# variant (see below), and copy the full build tree of menuselect.
define ASTERISK_COPY_MENUSELECT
	rm -rf $(@D)/menuselect
	cp -a $(HOST_ASTERISK_DIR)/menuselect $(@D)/menuselect
endef
ASTERISK_PRE_CONFIGURE_HOOKS += ASTERISK_COPY_MENUSELECT

ASTERISK_CONF_OPTS = \
	--disable-xmldoc \
	--disable-internal-poll \
	--disable-asteriskssl \
	--disable-rpath \
	--without-bfd \
	--without-cap \
	--without-cpg \
	--without-curses \
	--without-gtk2 \
	--without-gmime \
	--without-hoard \
	--without-iconv \
	--without-iksemel \
	--without-imap \
	--without-inotify \
	--without-iodbc \
	--without-isdnnet \
	--without-jack \
	--without-uriparser \
	--without-kqueue \
	--without-libedit \
	--without-libxslt \
	--without-lua \
	--without-misdn \
	--without-mysqlclient \
	--without-nbs \
	--without-neon29 \
	--without-newt \
	--without-openr2 \
	--without-osptk \
	--without-oss \
	--without-postgres \
	--without-pjproject \
	--without-pjproject-bundled \
	--without-popt \
	--without-resample \
	--without-sdl \
	--without-SDL_image \
	--without-sqlite \
	--without-suppserv \
	--without-tds \
	--without-termcap \
	--without-timerfd \
	--without-tinfo \
	--without-unbound \
	--without-unixodbc \
	--without-vpb \
	--without-x11 \
	--with-crypt \
	--with-jansson \
	--with-libcurl \
	--with-ilbc \
	--with-libxml2 \
	--with-libedit="$(STAGING_DIR)/usr" \
	--with-sqlite3="$(STAGING_DIR)/usr" \
	--with-sounds-cache=$(ASTERISK_DL_DIR)

# avcodec are from ffmpeg. There is virtually zero chance this could
# even work; asterisk is looking for ffmpeg/avcodec.h which has not
# been installed in this location since early 2007 (~10 years ago at
# the time of this writing).
ASTERISK_CONF_OPTS += --without-avcodec

ASTERISK_CONF_ENV = \
	ac_cv_file_bridges_bridge_softmix_include_hrirs_h=true \
	ac_cv_path_CONFIG_LIBXML2=$(STAGING_DIR)/usr/bin/xml2-config

# Uses __atomic_fetch_add_4
ifeq ($(BR2_TOOLCHAIN_HAS_LIBATOMIC),y)
ASTERISK_CONF_ENV += LIBS="-latomic"
endif

ifeq ($(BR2_TOOLCHAIN_USES_GLIBC),y)
ASTERISK_CONF_OPTS += --with-execinfo
else
ASTERISK_CONF_OPTS += --without-execinfo
endif

ifeq ($(BR2_PACKAGE_LIBGSM),y)
ASTERISK_DEPENDENCIES += libgsm
ASTERISK_CONF_OPTS += --with-gsm
else
ASTERISK_CONF_OPTS += --without-gsm
endif

ifeq ($(BR2_PACKAGE_ALSA_LIB),y)
ASTERISK_DEPENDENCIES += alsa-lib
ASTERISK_CONF_OPTS += --with-asound
else
ASTERISK_CONF_OPTS += --without-asound
endif

ifeq ($(BR2_PACKAGE_BLUEZ_UTILS),y)
ASTERISK_DEPENDENCIES += bluez_utils
ASTERISK_CONF_OPTS += --with-bluetooth
else
ASTERISK_CONF_OPTS += --without-bluetooth
endif

ifeq ($(BR2_PACKAGE_LIBICAL),y)
ASTERISK_DEPENDENCIES += libical
ASTERISK_CONF_OPTS += --with-ical
else
ASTERISK_CONF_OPTS += --without-ical
endif

ifeq ($(BR2_PACKAGE_OPENLDAP),y)
ASTERISK_DEPENDENCIES += openldap
ASTERISK_CONF_OPTS += --with-ldap
else
ASTERISK_CONF_OPTS += --without-ldap
endif

ifeq ($(BR2_PACKAGE_NEON),y)
ASTERISK_DEPENDENCIES += neon
ASTERISK_CONF_OPTS += --with-neon
ASTERISK_CONF_ENV += \
	ac_cv_path_CONFIG_NEON=$(STAGING_DIR)/usr/bin/neon-config
else
ASTERISK_CONF_OPTS += --without-neon
endif

ifeq ($(BR2_PACKAGE_NETSNMP),y)
ASTERISK_DEPENDENCIES += netsnmp
ASTERISK_CONF_OPTS += --with-netsnmp=$(STAGING_DIR)/usr
else
ASTERISK_CONF_OPTS += --without-netsnmp
endif

ifeq ($(BR2_PACKAGE_LIBOGG),y)
ASTERISK_DEPENDENCIES += libogg
ASTERISK_CONF_OPTS += --with-ogg
else
ASTERISK_CONF_OPTS += --without-ogg
endif

ifeq ($(BR2_PACKAGE_OPUS),y)
ASTERISK_DEPENDENCIES += opus
ASTERISK_CONF_OPTS += --with-opus
else
ASTERISK_CONF_OPTS += --without-opus
endif

ifeq ($(BR2_PACKAGE_PORTAUDIO),y)
ASTERISK_DEPENDENCIES += portaudio
ASTERISK_CONF_OPTS += --with-portaudio
else
ASTERISK_CONF_OPTS += --without-portaudio
endif

ifeq ($(BR2_PACKAGE_FREERADIUS_CLIENT),y)
ASTERISK_DEPENDENCIES += freeradius-client
ASTERISK_CONF_OPTS += --with-radius
else
ASTERISK_CONF_OPTS += --without-radius
endif

ifeq ($(BR2_PACKAGE_DAHDI_LINUX)$(BR2_PACKAGE_DAHDI_TOOLS),yy)
ASTERISK_DEPENDENCIES += dahdi-linux dahdi-tools
ASTERISK_CONF_OPTS += --with-dahdi --with-tonezone

ifeq ($(BR2_PACKAGE_LIBPRI),y)
ASTERISK_DEPENDENCIES += libpri
ASTERISK_CONF_OPTS += --with-pri
else
ASTERISK_CONF_OPTS += --without-pri
endif # PRI

ifeq ($(BR2_PACKAGE_LIBSS7),y)
ASTERISK_DEPENDENCIES += libss7
ASTERISK_CONF_OPTS += --with-ss7
else
ASTERISK_CONF_OPTS += --without-ss7
endif # SS7

else
ASTERISK_CONF_OPTS += \
	--without-dahdi --without-tonezone \
	--without-pri --without-ss7
endif # DAHDI

ifeq ($(BR2_PACKAGE_OPENSSL),y)
ASTERISK_DEPENDENCIES += openssl
ASTERISK_CONF_OPTS += --with-ssl
else
ASTERISK_CONF_OPTS += --without-ssl
endif

ifeq ($(BR2_PACKAGE_SPANDSP),y)
ASTERISK_DEPENDENCIES += spandsp
ASTERISK_CONF_OPTS += --with-spandsp
else
ASTERISK_CONF_OPTS += --without-spandsp
endif

ifeq ($(BR2_PACKAGE_SPEEX)$(BR2_PACKAGE_SPEEXDSP),yy)
ASTERISK_DEPENDENCIES += speex
ASTERISK_CONF_OPTS += --with-speex --with-speexdsp
else
ASTERISK_CONF_OPTS += --without-speex  --without-speexdsp
endif

# asterisk needs an openssl-enabled libsrtp
ifeq ($(BR2_PACKAGE_LIBSRTP)$(BR2_PACKAGE_OPENSSL)x$(BR2_STATIC_LIBS),yyx)
ASTERISK_DEPENDENCIES += libsrtp
ASTERISK_CONF_OPTS += --with-srtp
else
ASTERISK_CONF_OPTS += --without-srtp
endif

ifeq ($(BR2_PACKAGE_LIBVORBIS),y)
ASTERISK_DEPENDENCIES += libvorbis
ASTERISK_CONF_OPTS += --with-vorbis
else
ASTERISK_CONF_OPTS += --without-vorbis
endif

ifeq ($(BR2_PACKAGE_ZLIB),y)
ASTERISK_DEPENDENCIES += zlib
ASTERISK_CONF_OPTS += --with-z
else
ASTERISK_CONF_OPTS += --without-z
endif

ASTERISK_DIRS = \
	ASTVARLIBDIR="/usr/lib/asterisk" \
	ASTDATADIR="/usr/lib/asterisk" \
	ASTKEYDIR="/usr/lib/asterisk" \
	ASTDBDIR="/usr/lib/asterisk"

ASTERISK_MAKE_OPTS = $(ASTERISK_DIRS)

# Uses __atomic_fetch_add_4
ifeq ($(BR2_TOOLCHAIN_HAS_LIBATOMIC),y)
ASTERISK_MAKE_OPTS += ASTLDFLAGS="-latomic"
endif

# We want to install sample configuration files, too.
ASTERISK_INSTALL_TARGET_OPTS = \
	$(ASTERISK_DIRS) \
	DESTDIR=$(TARGET_DIR) \
	LDCONFIG=true \
	install samples

$(eval $(autotools-package))

#-------------------------------------------------------------------------------
# This part deals with building the menuselect tool as a host package

HOST_ASTERISK_DEPENDENCIES = host-pkgconf host-libxml2 host-ncurses
HOST_ASTERISK_SUBDIR = menuselect

HOST_ASTERISK_LICENSE = GPL-2.0
HOST_ASTERISK_LICENSE_FILES = COPYING

# No need to autoreconf for the host variant,
# so do not inherit the target setup.
HOST_ASTERISK_AUTORECONF = NO

HOST_ASTERISK_CONF_ENV = CONFIG_LIBXML2=$(HOST_DIR)/bin/xml2-config

HOST_ASTERISK_CONF_OPTS = \
	--without-newt \
	--without-curses \
	--with-ncurses=$(HOST_DIR)

# Not an automake package, so does not inherit LDFLAGS et al. from
# the configure run.
HOST_ASTERISK_MAKE_ENV = $(HOST_CONFIGURE_OPTS)

# Even though menuselect is an autotools package, it is not an automake
# package and does not have an 'install' rule, as asterisk does expect
# it to be in a sub-directory of its source tree. We do so by copying
# the full menuselect build tree as a pre-configure hook in the target
# variant.
# However, the sanity checks on host packages are not run on menuselect.
# But we still want to catch that menuselect has the proper rpath set,
# for example, as it uses host libraries that we do build, like
# host-libxml2.
# So we do manually install the menuselect tool.
define HOST_ASTERISK_INSTALL_CMDS
	$(INSTALL) -D -m 0755 $(@D)/menuselect/menuselect \
		$(HOST_DIR)/bin/asterisk-menuselect
endef

$(eval $(host-autotools-package))
