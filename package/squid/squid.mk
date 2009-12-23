#############################################################
#
# squid
#
#############################################################

SQUID_VERSION = 3.0.STABLE21
SQUID_SOURCE = squid-$(SQUID_VERSION).tar.bz2
SQUID_SITE = http://www.squid-cache.org/Versions/v3/3.0
SQUID_AUTORECONF = YES
SQUID_LIBTOOL_PATCH = NO
SQUID_CONF_ENV =	ac_cv_epoll_works=yes ac_cv_func_setresuid=yes \
			ac_cv_func_va_copy=yes ac_cv_func___va_copy=yes \
			ac_cv_func_strnstr=no
SQUID_CONF_OPT =	--disable-wccp --disable-wccp2 \
			--disable-htcp --disable-snmp \
			--enable-linux-netfilter \
			--enable-storeio=ufs,diskd,aufs,null \
			--enable-removal-policies="lru,heap" \
			--with-aufs-threads=24 --with-filedescriptors=1024
ifeq ($(BR2_PACKAGE_OPENSSL),y)
	SQUID_CONF_OPT += --enable-ssl
	SQUID_DEPENDENCIES += openssl
endif

$(eval $(call AUTOTARGETS,package,squid))

$(SQUID_HOOK_POST_INSTALL):
	rm -f $(addprefix $(TARGET_DIR)/usr/bin/, \
		RunCache RunAccel)
	rm -f $(addprefix $(TARGET_DIR)/etc/, \
		cachemgr.conf mime.conf.default squid.conf.default)
	rm -f $(TARGET_DIR)/usr/libexec/cachemgr.cgi
	rm -f $(TARGET_DIR)/usr/share/mib.txt
	touch $@
