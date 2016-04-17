################################################################################
#
# freeswitch
#
################################################################################

FREESWITCH_VERSION = 1.6.7
FREESWITCH_SOURCE = freeswitch-$(FREESWITCH_VERSION).tar.xz
FREESWITCH_SITE = http://files.freeswitch.org/freeswitch-releases
FREESWITCH_LICENSE = MPLv1.1, \
	GPLv3+ with font exception (fonts), \
	Apache-2.0 (apr, apr-util), \
	LGPLv2+ (sofia-sip), \
	LGPLv2.1, GPLv2 (spandsp), \
	BSD-3c (libsrtp), \
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

# freeswitch comes with pre-enabled modules, since we want to control
# the modules ourselves reset the upstream configuration
define FREESWITCH_RESET_MODULES
	> $(@D)/modules.conf
endef
FREESWITCH_PRE_CONFIGURE_HOOKS += FREESWITCH_RESET_MODULES

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
	--disable-core-libedit-support \
	--disable-core-odbc-support \
	--disable-libvpx \
	--disable-libyuv \
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

$(eval $(autotools-package))
