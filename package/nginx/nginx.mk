################################################################################
#
# nginx
#
################################################################################

NGINX_VERSION = 1.10.3
NGINX_SITE = http://nginx.org/download
NGINX_LICENSE = BSD-2c
NGINX_LICENSE_FILES = LICENSE
NGINX_DEPENDENCIES = host-pkgconf

NGINX_CONF_OPTS = \
	--crossbuild=Linux::$(BR2_ARCH) \
	--with-cc="$(TARGET_CC)" \
	--with-cpp="$(TARGET_CC)" \
	--with-ld-opt="$(TARGET_LDFLAGS)" \
	--with-ipv6

# www-data user and group are used for nginx. Because these user and group
# are already set by buildroot, it is not necessary to redefine them.
# See system/skeleton/etc/passwd
#   username: www-data    uid: 33
#   groupname: www-data   gid: 33
#
# So, we just need to create the directories used by nginx with the right
# ownership.
define NGINX_PERMISSIONS
	/var/lib/nginx d 755 33 33 - - - - -
endef

# disable external libatomic_ops because its detection fails.
NGINX_CONF_ENV += \
	ngx_force_c_compiler=yes \
	ngx_force_c99_have_variadic_macros=yes \
	ngx_force_gcc_have_variadic_macros=yes \
	ngx_force_gcc_have_atomic=yes \
	ngx_force_have_epoll=yes \
	ngx_force_have_sendfile=yes \
	ngx_force_have_sendfile64=yes \
	ngx_force_have_pr_set_dumpable=yes \
	ngx_force_have_timer_event=yes \
	ngx_force_have_map_anon=yes \
	ngx_force_have_map_devzero=yes \
	ngx_force_have_sysvshm=yes \
	ngx_force_have_posix_sem=yes

# prefix: nginx root configuration location
NGINX_CONF_OPTS += \
	--prefix=/usr \
	--conf-path=/etc/nginx/nginx.conf \
	--sbin-path=/usr/sbin/nginx \
	--pid-path=/var/run/nginx.pid \
	--lock-path=/var/run/lock/nginx.lock \
	--user=www-data \
	--group=www-data \
	--error-log-path=/var/log/nginx/error.log \
	--http-log-path=/var/log/nginx/access.log \
	--http-client-body-temp-path=/var/tmp/nginx/client-body \
	--http-proxy-temp-path=/var/tmp/nginx/proxy \
	--http-fastcgi-temp-path=/var/tmp/nginx/fastcgi \
	--http-scgi-temp-path=/var/tmp/nginx/scgi \
	--http-uwsgi-temp-path=/var/tmp/nginx/uwsgi

NGINX_CONF_OPTS += \
	$(if $(BR2_PACKAGE_NGINX_FILE_AIO),--with-file-aio) \
	$(if $(BR2_PACKAGE_NGINX_THREADS),--with-threads)

ifeq ($(BR2_PACKAGE_LIBATOMIC_OPS),y)
NGINX_DEPENDENCIES += libatomic_ops
NGINX_CONF_OPTS += --with-libatomic
NGINX_CONF_ENV += ngx_force_have_libatomic=yes
ifeq ($(BR2_sparc_v8)$(BR2_sparc_leon3),y)
NGINX_CFLAGS += "-DAO_NO_SPARC_V9"
endif
else
NGINX_CONF_ENV += ngx_force_have_libatomic=no
endif

ifeq ($(BR2_PACKAGE_PCRE),y)
NGINX_DEPENDENCIES += pcre
NGINX_CONF_OPTS += --with-pcre
else
NGINX_CONF_OPTS += --without-pcre
endif

# modules disabled or not activated because of missing dependencies:
# - google_perftools  (googleperftools)
# - http_geoip_module (geoip)
# - http_perl_module  (host-perl)
# - pcre-jit          (want to rebuild pcre)

# Notes:
# * Feature/module option are *not* symetric.
#   If a feature is on by default, only its --without-xxx option exists;
#   if a feature is off by default, only its --with-xxx option exists.
# * The configure script fails if unknown options are passed on the command
#   line.

# misc. modules
NGINX_CONF_OPTS += \
	$(if $(BR2_PACKAGE_NGINX_SELECT_MODULE),--with-select_module,--without-select_module) \
	$(if $(BR2_PACKAGE_NGINX_POLL_MODULE),--with-poll_module,--without-poll_module)

ifneq ($(BR2_PACKAGE_NGINX_ADD_MODULES),)
NGINX_CONF_OPTS += \
	$(addprefix --add-module=,$(call qstrip,$(BR2_PACKAGE_NGINX_ADD_MODULES)))
endif

# http server modules
ifeq ($(BR2_PACKAGE_NGINX_HTTP),y)
ifeq ($(BR2_PACKAGE_NGINX_HTTP_CACHE),y)
NGINX_DEPENDENCIES += openssl
else
NGINX_CONF_OPTS += --without-http-cache
endif

ifeq ($(BR2_PACKAGE_NGINX_HTTP_V2_MODULE),y)
NGINX_DEPENDENCIES += zlib
NGINX_CONF_OPTS += --with-http_v2_module
endif

ifeq ($(BR2_PACKAGE_NGINX_HTTP_SSL_MODULE),y)
NGINX_DEPENDENCIES += openssl
NGINX_CONF_OPTS += --with-http_ssl_module
endif

ifeq ($(BR2_PACKAGE_NGINX_HTTP_XSLT_MODULE),y)
NGINX_DEPENDENCIES += libxml2 libxslt
NGINX_CONF_OPTS += --with-http_xslt_module
endif

ifeq ($(BR2_PACKAGE_NGINX_HTTP_IMAGE_FILTER_MODULE),y)
NGINX_DEPENDENCIES += gd jpeg libpng
NGINX_CONF_OPTS += --with-http_image_filter_module
endif

ifeq ($(BR2_PACKAGE_NGINX_HTTP_GUNZIP_MODULE),y)
NGINX_DEPENDENCIES += zlib
NGINX_CONF_OPTS += --with-http_gunzip_module
endif

ifeq ($(BR2_PACKAGE_NGINX_HTTP_GZIP_STATIC_MODULE),y)
NGINX_DEPENDENCIES += zlib
NGINX_CONF_OPTS += --with-http_gzip_static_module
endif

ifeq ($(BR2_PACKAGE_NGINX_HTTP_SECURE_LINK_MODULE),y)
NGINX_DEPENDENCIES += openssl
NGINX_CONF_OPTS += --with-http_secure_link_module
endif

ifeq ($(BR2_PACKAGE_NGINX_HTTP_GZIP_MODULE),y)
NGINX_DEPENDENCIES += zlib
else
NGINX_CONF_OPTS += --without-http_gzip_module
endif

ifeq ($(BR2_PACKAGE_NGINX_HTTP_REWRITE_MODULE),y)
NGINX_DEPENDENCIES += pcre
else
NGINX_CONF_OPTS += --without-http_rewrite_module
endif

NGINX_CONF_OPTS += \
	$(if $(BR2_PACKAGE_NGINX_HTTP_REALIP_MODULE),--with-http_realip_module) \
	$(if $(BR2_PACKAGE_NGINX_HTTP_ADDITION_MODULE),--with-http_addition_module) \
	$(if $(BR2_PACKAGE_NGINX_HTTP_SUB_MODULE),--with-http_sub_module) \
	$(if $(BR2_PACKAGE_NGINX_HTTP_DAV_MODULE),--with-http_dav_module) \
	$(if $(BR2_PACKAGE_NGINX_HTTP_FLV_MODULE),--with-http_flv_module) \
	$(if $(BR2_PACKAGE_NGINX_HTTP_MP4_MODULE),--with-http_mp4_module) \
	$(if $(BR2_PACKAGE_NGINX_HTTP_AUTH_REQUEST_MODULE),--with-http_auth_request_module) \
	$(if $(BR2_PACKAGE_NGINX_HTTP_RANDOM_INDEX_MODULE),--with-http_random_index_module) \
	$(if $(BR2_PACKAGE_NGINX_HTTP_DEGRADATION_MODULE),--with-http_degradation_module) \
	$(if $(BR2_PACKAGE_NGINX_HTTP_STUB_STATUS_MODULE),--with-http_stub_status_module) \
	$(if $(BR2_PACKAGE_NGINX_HTTP_CHARSET_MODULE),,--without-http_charset_module) \
	$(if $(BR2_PACKAGE_NGINX_HTTP_SSI_MODULE),,--without-http_ssi_module) \
	$(if $(BR2_PACKAGE_NGINX_HTTP_USERID_MODULE),,--without-http_userid_module) \
	$(if $(BR2_PACKAGE_NGINX_HTTP_ACCESS_MODULE),,--without-http_access_module) \
	$(if $(BR2_PACKAGE_NGINX_HTTP_AUTH_BASIC_MODULE),,--without-http_auth_basic_module) \
	$(if $(BR2_PACKAGE_NGINX_HTTP_AUTOINDEX_MODULE),,--without-http_autoindex_module) \
	$(if $(BR2_PACKAGE_NGINX_HTTP_GEO_MODULE),,--without-http_geo_module) \
	$(if $(BR2_PACKAGE_NGINX_HTTP_MAP_MODULE),,--without-http_map_module) \
	$(if $(BR2_PACKAGE_NGINX_HTTP_SPLIT_CLIENTS_MODULE),,--without-http_split_clients_module) \
	$(if $(BR2_PACKAGE_NGINX_HTTP_REFERER_MODULE),,--without-http_referer_module) \
	$(if $(BR2_PACKAGE_NGINX_HTTP_PROXY_MODULE),,--without-http_proxy_module) \
	$(if $(BR2_PACKAGE_NGINX_HTTP_FASTCGI_MODULE),,--without-http_fastcgi_module) \
	$(if $(BR2_PACKAGE_NGINX_HTTP_UWSGI_MODULE),,--without-http_uwsgi_module) \
	$(if $(BR2_PACKAGE_NGINX_HTTP_SCGI_MODULE),,--without-http_scgi_module) \
	$(if $(BR2_PACKAGE_NGINX_HTTP_MEMCACHED_MODULE),,--without-http_memcached_module) \
	$(if $(BR2_PACKAGE_NGINX_HTTP_LIMIT_CONN_MODULE),,--without-http_limit_conn_module) \
	$(if $(BR2_PACKAGE_NGINX_HTTP_LIMIT_REQ_MODULE),,--without-http_limit_req_module) \
	$(if $(BR2_PACKAGE_NGINX_HTTP_EMPTY_GIF_MODULE),,--without-http_empty_gif_module) \
	$(if $(BR2_PACKAGE_NGINX_HTTP_BROWSER_MODULE),,--without-http_browser_module) \
	$(if $(BR2_PACKAGE_NGINX_HTTP_UPSTREAM_IP_HASH_MODULE),,--without-http_upstream_ip_hash_module) \
	$(if $(BR2_PACKAGE_NGINX_HTTP_UPSTREAM_LEAST_CONN_MODULE),,--without-http_upstream_least_conn_module) \
	$(if $(BR2_PACKAGE_NGINX_HTTP_UPSTREAM_KEEPALIVE_MODULE),,--without-http_upstream_keepalive_module)

else # !BR2_PACKAGE_NGINX_HTTP
NGINX_CONF_OPTS += --without-http
endif # BR2_PACKAGE_NGINX_HTTP

# mail modules
ifeq ($(BR2_PACKAGE_NGINX_MAIL),y)
NGINX_CONF_OPTS += --with-mail

ifeq ($(BR2_PACKAGE_NGINX_MAIL_SSL_MODULE),y)
NGINX_DEPENDENCIES += openssl
NGINX_CONF_OPTS += --with-mail_ssl_module
endif

NGINX_CONF_OPTS += \
	$(if $(BR2_PACKAGE_NGINX_MAIL_POP3_MODULE),,--without-mail_pop3_module) \
	$(if $(BR2_PACKAGE_NGINX_MAIL_IMAP_MODULE),,--without-mail_imap_module) \
	$(if $(BR2_PACKAGE_NGINX_MAIL_SMTP_MODULE),,--without-mail_smtp_module)

endif # BR2_PACKAGE_NGINX_MAIL

# stream modules
ifeq ($(BR2_PACKAGE_NGINX_STREAM),y)
NGINX_CONF_OPTS += --with-stream

ifeq ($(BR2_PACKAGE_NGINX_STREAM_SSL_MODULE),y)
NGINX_DEPENDENCIES += openssl
NGINX_CONF_OPTS += --with-stream_ssl_module
endif

NGINX_CONF_OPTS += \
	$(if $(BR2_PACKAGE_NGINX_STREAM_LIMIT_CONN_MODULE),,--without-stream_limit_conn_module) \
	$(if $(BR2_PACKAGE_NGINX_STREAM_ACCESS_MODULE),,--without-stream_access_module) \
	$(if $(BR2_PACKAGE_NGINX_STREAM_UPSTREAM_HASH_MODULE),,--without-stream_upstream_hash_module) \
	$(if $(BR2_PACKAGE_NGINX_STREAM_UPSTREAM_LEAST_CONN_MODULE),,--without-stream_upstream_least_conn_module) \
	$(if $(BR2_PACKAGE_NGINX_STREAM_UPSTREAM_ZONE_MODULE),,--without-stream_upstream_zone_module)

endif # BR2_PACKAGE_NGINX_STREAM

# external modules
ifeq ($(BR2_PACKAGE_NGINX_UPLOAD),y)
NGINX_CONF_OPTS += $(addprefix --add-module=,$(NGINX_UPLOAD_DIR))
NGINX_DEPENDENCIES += nginx-upload
endif

ifeq ($(BR2_PACKAGE_NGINX_DAV_EXT),y)
NGINX_CONF_OPTS += --add-module=$(NGINX_DAV_EXT_DIR)
NGINX_DEPENDENCIES += nginx-dav-ext
endif

ifeq ($(BR2_PACKAGE_NGINX_NAXSI),y)
NGINX_DEPENDENCIES += nginx-naxsi
NGINX_CONF_OPTS += --add-module=$(NGINX_NAXSI_DIR)/naxsi_src
endif

# Debug logging
NGINX_CONF_OPTS += $(if $(BR2_PACKAGE_NGINX_DEBUG),--with-debug)

define NGINX_DISABLE_WERROR
	$(SED) 's/-Werror//g' -i $(@D)/auto/cc/*
endef

NGINX_PRE_CONFIGURE_HOOKS += NGINX_DISABLE_WERROR

define NGINX_CONFIGURE_CMDS
	cd $(@D) ; $(NGINX_CONF_ENV) \
		PKG_CONFIG="$(PKG_CONFIG_HOST_BINARY)" \
		GDLIB_CONFIG=$(STAGING_DIR)/usr/bin/gdlib-config \
		./configure $(NGINX_CONF_OPTS) \
			--with-cc-opt="$(TARGET_CFLAGS) $(NGINX_CFLAGS)"
endef

define NGINX_BUILD_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) -C $(@D)
endef

define NGINX_INSTALL_TARGET_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) -C $(@D) DESTDIR=$(TARGET_DIR) install
	$(RM) $(TARGET_DIR)/usr/sbin/nginx.old
	$(INSTALL) -D -m 0664 package/nginx/nginx.logrotate \
		$(TARGET_DIR)/etc/logrotate.d/nginx
endef

define NGINX_INSTALL_INIT_SYSTEMD
	$(INSTALL) -D -m 0644 package/nginx/nginx.service \
		$(TARGET_DIR)/usr/lib/systemd/system/nginx.service

	mkdir -p $(TARGET_DIR)/etc/systemd/system/multi-user.target.wants

	ln -fs ../../../../usr/lib/systemd/system/nginx.service \
		$(TARGET_DIR)/etc/systemd/system/multi-user.target.wants/nginx.service
endef

define NGINX_INSTALL_INIT_SYSV
	$(INSTALL) -D -m 0755 package/nginx/S50nginx \
		$(TARGET_DIR)/etc/init.d/S50nginx
endef

$(eval $(generic-package))
