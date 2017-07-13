################################################################################
#
# freeswitch
#
################################################################################

FREESWITCH_VERSION = 1.6.19
FREESWITCH_SOURCE = freeswitch-$(FREESWITCH_VERSION).tar.xz
FREESWITCH_SITE = http://files.freeswitch.org/freeswitch-releases
FREESWITCH_LICENSE = MPL-1.1, \
	GPL-3.0+ with font exception (fonts), \
	Apache-2.0 (apr, apr-util), \
	LGPL-2.0+ (sofia-sip), \
	LGPL-2.1, GPL-2.0 (spandsp), \
	BSD-3-Clause (libsrtp), \
	tiff license

FREESWITCH_LICENSE_FILES = \
	COPYING \
	libs/apr/LICENSE \
	libs/apr-util/LICENSE \
	libs/sofia-sip/COPYING \
	libs/sofia-sip/COPYRIGHTS \
	libs/spandsp/COPYING \
	libs/srtp/LICENSE \
	libs/tiff-4.0.2/COPYRIGHT

# required dependencies
FREESWITCH_DEPENDENCIES = \
	host-pkgconf \
	jpeg \
	libcurl \
	openssl \
	pcre \
	speex \
	sqlite \
	util-linux \
	zlib

# disable display of ClueCon banner in fs_cli
FREESWITCH_CONF_ENV += \
	disable_cc=yes

# we neither need host-perl nor host-php
FREESWITCH_CONF_ENV += \
	ac_cv_prog_PERL=false \
	ac_cv_have_perl=no \
	ac_cv_prog_PHP=false \
	ac_cv_have_php=no \
	ac_cv_prog_PHP_CONFIG=false \
	ac_cv_have_php_config=no

# copied from freeswitch/configure.ac, line 258+
FREESWITCH_CONF_ENV += \
	ac_cv_file__dev_ptmx=yes \
	ac_cv_va_copy=yes \
	ac_cv_file__dev_urandom=yes \
	ac_cv_func_realloc_0_nonnull=yes \
	ac_cv_func_malloc_0_nonnull=yes \
	ac_cv_func_setpgrp_void=yes \
	ac_cv_file__dev_zero=yes \
	apr_cv_tcp_nodelay_with_cork=yes \
	ac_cv_file_dbd_apr_dbd_mysql_c=no \
	ac_cv_sizeof_ssize_t=4 \
	apr_cv_mutex_recursive=yes \
	ac_cv_func_pthread_rwlock_init=yes \
	apr_cv_type_rwlock_t=yes \
	apr_cv_process_shared_works=yes \
	apr_cv_mutex_robust_shared=yes

# build breaks with -Werror enabled
FREESWITCH_CONF_ENV += \
	ac_cv_gcc_supports_w_no_unused_result=no

FREESWITCH_CONF_OPTS = \
	--without-erlang \
	--enable-fhs \
	--without-python \
	--disable-system-xmlrpc-c

# zrtp supports a limited set of archs, sparc support is also broken due
# to a broken ld call by gcc, see libs/libzrtp/include/zrtp_config.h
ifeq ($(BR2_i386)$(BR2_arm)$(BR2_armeb)$(BR2_aarch64)$(BR2_aarch64_be)$(BR2_mips)$(BR2_mipsel)$(BR2_mips64)$(BR2_mips64el)$(BR2_powerpc)$(BR2_powerpc64)$(BR2_powerpcle)$(BR2_x86_64),y)
FREESWITCH_LICENSE_FILES += libs/libzrtp/src/zrtp_legal.c
FREESWITCH_CONF_OPTS += --enable-zrtp
else
FREESWITCH_CONF_OPTS += --disable-zrtp
endif

# Enable optional modules
FREESWITCH_ENABLED_MODULES += \
	applications/mod_avmd \
	applications/mod_blacklist \
	applications/mod_callcenter \
	applications/mod_commands \
	applications/mod_conference \
	applications/mod_curl \
	applications/mod_db \
	applications/mod_directory \
	applications/mod_dptools \
	applications/mod_easyroute \
	applications/mod_esf \
	applications/mod_esl \
	applications/mod_expr \
	applications/mod_fifo \
	applications/mod_fsk \
	applications/mod_hash \
	applications/mod_httapi \
	applications/mod_lcr \
	applications/mod_sms \
	applications/mod_snom \
	applications/mod_spandsp \
	applications/mod_spy \
	applications/mod_valet_parking \
	applications/mod_voicemail \
	codecs/mod_g723_1 \
	codecs/mod_g729 \
	dialplans/mod_dialplan_asterisk \
	dialplans/mod_dialplan_xml \
	endpoints/mod_loopback \
	endpoints/mod_rtc \
	endpoints/mod_rtmp \
	endpoints/mod_sofia \
	endpoints/mod_verto \
	event_handlers/mod_cdr_csv \
	event_handlers/mod_cdr_sqlite \
	event_handlers/mod_event_socket \
	formats/mod_local_stream \
	formats/mod_native_file \
	formats/mod_tone_stream \
	loggers/mod_console \
	loggers/mod_logfile \
	loggers/mod_syslog \
	say/mod_say_de \
	say/mod_say_en \
	say/mod_say_es \
	say/mod_say_es_ar \
	say/mod_say_fa \
	say/mod_say_fr \
	say/mod_say_he \
	say/mod_say_hr \
	say/mod_say_hu \
	say/mod_say_it \
	say/mod_say_ja \
	say/mod_say_nl \
	say/mod_say_pl \
	say/mod_say_pt \
	say/mod_say_ru \
	say/mod_say_sv \
	say/mod_say_th \
	say/mod_say_zh \
	xml_int/mod_xml_cdr \
	xml_int/mod_xml_rpc \
	xml_int/mod_xml_scgi

define FREESWITCH_ENABLE_MODULES
	$(Q)echo $(FREESWITCH_ENABLED_MODULES) \
		| tr ' ' '\n' \
		> $(@D)/modules.conf
endef
FREESWITCH_PRE_CONFIGURE_HOOKS += FREESWITCH_ENABLE_MODULES

# mod_isac supports a limited set of archs
# src/mod/codecs/mod_isac/typedefs.h
ifeq ($(BR2_i386)$(BR2_mips)$(BR2_mipsel)$(BR2_mips64)$(BR2_mips64el)$(BR2_x86_64),y)
FREESWITCH_LICENSE := $(FREESWITCH_LICENSE), BSD-3-Clause (mod_isac)
FREESWITCH_LICENSE_FILES += src/mod/codecs/mod_isac/LICENSE
FREESWITCH_ENABLED_MODULES += codecs/mod_isac
endif

ifeq ($(BR2_PACKAGE_ALSA_LIB),y)
FREESWITCH_DEPENDENCIES += alsa-lib
FREESWITCH_ENABLED_MODULES += endpoints/mod_alsa
endif

ifeq ($(BR2_PACKAGE_FREETYPE),y)
FREESWITCH_DEPENDENCIES += freetype
endif

ifeq ($(BR2_PACKAGE_LIBBROADVOICE),y)
FREESWITCH_DEPENDENCIES += libbroadvoice
FREESWITCH_ENABLED_MODULES += codecs/mod_bv
endif

ifeq ($(BR2_PACKAGE_LIBCODEC2),y)
FREESWITCH_DEPENDENCIES += libcodec2
FREESWITCH_ENABLED_MODULES += codecs/mod_codec2
endif

ifeq ($(BR2_PACKAGE_LIBEDIT),y)
FREESWITCH_DEPENDENCIES += libedit
FREESWITCH_CONF_OPTS += --enable-core-libedit-support
else
FREESWITCH_CONF_OPTS += --disable-core-libedit-support
endif

ifeq ($(BR2_PACKAGE_LIBG7221),y)
FREESWITCH_DEPENDENCIES += libg7221
endif

ifeq ($(BR2_PACKAGE_LIBILBC),y)
FREESWITCH_DEPENDENCIES += libilbc
FREESWITCH_ENABLED_MODULES += codecs/mod_ilbc
endif

ifeq ($(BR2_PACKAGE_LIBLDNS),y)
FREESWITCH_DEPENDENCIES += libldns
FREESWITCH_ENABLED_MODULES += applications/mod_enum
endif

ifeq ($(BR2_PACKAGE_LIBMEMCACHED),y)
FREESWITCH_DEPENDENCIES += libmemcached
FREESWITCH_ENABLED_MODULES += applications/mod_memcache
endif

ifeq ($(BR2_PACKAGE_LIBPNG),y)
FREESWITCH_DEPENDENCIES += libpng
FREESWITCH_ENABLED_MODULES += formats/mod_png
endif

ifeq ($(BR2_PACKAGE_LIBYAML),y)
FREESWITCH_DEPENDENCIES += libyaml
FREESWITCH_ENABLED_MODULES += languages/mod_yaml
endif

ifeq ($(BR2_PACKAGE_LUA),y)
FREESWITCH_DEPENDENCIES += lua
FREESWITCH_ENABLED_MODULES += languages/mod_lua
endif

ifeq ($(BR2_PACKAGE_OPENLDAP),y)
FREESWITCH_DEPENDENCIES += openldap
FREESWITCH_ENABLED_MODULES += directories/mod_ldap xml_int/mod_xml_ldap
endif

ifeq ($(BR2_PACKAGE_OPUS),y)
FREESWITCH_DEPENDENCIES += opus
FREESWITCH_ENABLED_MODULES += codecs/mod_opus
endif

ifeq ($(BR2_PACKAGE_PORTAUDIO),y)
FREESWITCH_DEPENDENCIES += portaudio
FREESWITCH_ENABLED_MODULES += endpoints/mod_portaudio
endif

ifeq ($(BR2_PACKAGE_LAME)$(BR2_PACKAGE_LIBSHOUT)$(BR2_PACKAGE_MPG123),yyy)
FREESWITCH_DEPENDENCIES += lame libshout mpg123
FREESWITCH_ENABLED_MODULES += formats/mod_shout
endif

ifeq ($(BR2_PACKAGE_LIBSILK),y)
FREESWITCH_DEPENDENCIES += libsilk
FREESWITCH_ENABLED_MODULES += codecs/mod_silk
endif

ifeq ($(BR2_PACKAGE_LIBSNDFILE),y)
FREESWITCH_DEPENDENCIES += libsndfile
FREESWITCH_ENABLED_MODULES += formats/mod_sndfile
endif

ifeq ($(BR2_PACKAGE_LIBSOUNDTOUCH),y)
FREESWITCH_DEPENDENCIES += libsoundtouch
FREESWITCH_ENABLED_MODULES += applications/mod_soundtouch
endif

ifeq ($(BR2_PACKAGE_OPENCV),y)
FREESWITCH_DEPENDENCIES += opencv
FREESWITCH_ENABLED_MODULES += applications/mod_cv
endif

ifeq ($(BR2_PACKAGE_UNIXODBC),y)
FREESWITCH_DEPENDENCIES += unixodbc
FREESWITCH_CONF_OPTS += \
	--enable-core-odbc-support \
	--with-odbc=$(STAGING_DIR)/usr
else
FREESWITCH_CONF_OPTS += --disable-core-odbc-support
endif

ifeq ($(BR2_PACKAGE_XZ),y)
FREESWITCH_DEPENDENCIES += xz
endif

ifeq ($(BR2_TOOLCHAIN_GCC_AT_LEAST_4_8)$(BR2_PACKAGE_FFMPEG),yy)
FREESWITCH_LICENSE := $(FREESWITCH_LICENSE), BSD-3-Clause (libvpx, libyuv)
FREESWITCH_LICENSE_FILES += libs/libvpx/LICENSE libs/libyuv/LICENSE
FREESWITCH_CONF_OPTS += --enable-libvpx --enable-libyuv
FREESWITCH_DEPENDENCIES += host-yasm ffmpeg
FREESWITCH_ENABLED_MODULES += applications/mod_av applications/mod_fsv
FREESWITCH_MAKE_ENV += CROSS=$(TARGET_CROSS)
else
FREESWITCH_CONF_OPTS += --disable-libvpx --disable-libyuv
endif

$(eval $(autotools-package))
