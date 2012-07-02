#############################################################
#
# squid
#
#############################################################

SQUID_VERSION = 3.1.20
SQUID_SITE = http://www.squid-cache.org/Versions/v3/3.1
SQUID_DEPENDENCIES = libcap host-libcap
SQUID_CONF_ENV =	ac_cv_epoll_works=yes ac_cv_func_setresuid=yes \
			ac_cv_func_va_copy=yes ac_cv_func___va_copy=yes \
			ac_cv_func_strnstr=no ac_cv_have_squid=yes
SQUID_CONF_OPT =	--enable-wccp --enable-wccpv2 --enable-async-io=8 \
			--enable-htcp --enable-snmp --enable-linux-netfilter \
			--enable-removal-policies="lru,heap" \
			--with-filedescriptors=1024 --disable-ident-lookups \
			--enable-auth="digest" --disable-strict-error-checking \
			--enable-digest-auth-helpers="password" \
			--enable-external-acl-helpers="ip_user"

ifeq ($(BR2_PACKAGE_OPENSSL),y)
	SQUID_CONF_OPT += --enable-ssl
	SQUID_DEPENDENCIES += openssl
endif

define SQUID_CLEANUP_TARGET
	rm -f $(addprefix $(TARGET_DIR)/usr/bin/, \
		RunCache RunAccel)
	rm -f $(addprefix $(TARGET_DIR)/etc/, \
		cachemgr.conf mime.conf.default squid.conf.default)
endef

SQUID_POST_INSTALL_TARGET_HOOKS += SQUID_CLEANUP_TARGET

$(eval $(autotools-package))
