################################################################################
#
# collectd
#
################################################################################

COLLECTD_VERSION = 5.4.1
COLLECTD_SITE = http://collectd.org/files
COLLECTD_CONF_ENV = ac_cv_lib_yajl_yajl_alloc=yes
COLLECTD_INSTALL_STAGING = YES
COLLECTD_LICENSE = GPLv2 LGPLv2.1
COLLECTD_LICENSE_FILES = COPYING

# These require unmet dependencies, are fringe, pointless or deprecated
COLLECTD_PLUGINS_DISABLE = amqp apple_sensors aquaero ascent dbi email \
		gmond hddtemp ipmi ipvs java libvirt lpar lvm madwifi mbmon \
		memcachec modbus multimeter netapp netlink nginx \
		notify_desktop notify_email numa nut onewire oracle perl pf \
		pinba postgresql powerdns python redis routeros rrdcached \
		sigrok tape target_v5upgrade teamspeak2 ted \
		tokyotyrant uuid varnish vserver write_mongodb write_redis \
		xmms zfs_arc

COLLECTD_LDFLAGS = $(TARGET_LDFLAGS) -lm

ifeq ($(BR2_PREFER_STATIC_LIB),y)
# collectd-tg indirectly needs pthread but doesn't link with -pthread,
# causing static linker errors
COLLECTD_LDFLAGS += -lpthread
endif

COLLECTD_CONF_ENV += LDFLAGS="$(COLLECTD_LDFLAGS)"

COLLECTD_CONF_OPT += --with-nan-emulation --with-fp-layout=nothing \
	--localstatedir=/var --with-perl-bindings=no \
	$(foreach p, $(COLLECTD_PLUGINS_DISABLE), --disable-$(p)) \
	$(if $(BR2_PACKAGE_COLLECTD_AGGREGATION),--enable-aggregation,--disable-aggregation) \
	$(if $(BR2_PACKAGE_COLLECTD_APACHE),--enable-apache,--disable-apache) \
	$(if $(BR2_PACKAGE_COLLECTD_APCUPS),--enable-apcups,--disable-apcups) \
	$(if $(BR2_PACKAGE_COLLECTD_BATTERY),--enable-battery,--disable-battery) \
	$(if $(BR2_PACKAGE_COLLECTD_BIND),--enable-bind,--disable-bind) \
	$(if $(BR2_PACKAGE_COLLECTD_CGROUPS),--enable-cgroups,--disable-cgroups) \
	$(if $(BR2_PACKAGE_COLLECTD_CONNTRACK),--enable-conntrack,--disable-conntrack) \
	$(if $(BR2_PACKAGE_COLLECTD_CONTEXTSWITCH),--enable-contextswitch,--disable-contextswitch) \
	$(if $(BR2_PACKAGE_COLLECTD_CPU),--enable-cpu,--disable-cpu) \
	$(if $(BR2_PACKAGE_COLLECTD_CPUFREQ),--enable-cpufreq,--disable-cpufreq) \
	$(if $(BR2_PACKAGE_COLLECTD_CSV),--enable-csv,--disable-csv) \
	$(if $(BR2_PACKAGE_COLLECTD_CURL),--enable-curl,--disable-curl) \
	$(if $(BR2_PACKAGE_COLLECTD_CURL_JSON),--enable-curl_json,--disable-curl_json) \
	$(if $(BR2_PACKAGE_COLLECTD_CURL_XML),--enable-curl_xml,--disable-curl_xml) \
	$(if $(BR2_PACKAGE_COLLECTD_DF),--enable-df,--disable-df) \
	$(if $(BR2_PACKAGE_COLLECTD_DISK),--enable-disk,--disable-disk) \
	$(if $(BR2_PACKAGE_COLLECTD_DNS),--enable-dns,--disable-dns) \
	$(if $(BR2_PACKAGE_COLLECTD_EMPTY_COUNTER),--enable-match_empty_counter,--disable-match_empty_counter) \
	$(if $(BR2_PACKAGE_COLLECTD_ENTROPY),--enable-entropy,--disable-entropy) \
	$(if $(BR2_PACKAGE_COLLECTD_ETHSTAT),--enable-ethstat,--disable-ethstat) \
	$(if $(BR2_PACKAGE_COLLECTD_EXEC),--enable-exec,--disable-exec) \
	$(if $(BR2_PACKAGE_COLLECTD_FILECOUNT),--enable-filecount,--disable-filecount) \
	$(if $(BR2_PACKAGE_COLLECTD_FSCACHE),--enable-fscache,--disable-fscache) \
	$(if $(BR2_PACKAGE_COLLECTD_GRAPHITE),--enable-write_graphite,--disable-write_graphite) \
	$(if $(BR2_PACKAGE_COLLECTD_HASHED),--enable-match_hashed,--disable-match_hashed) \
	$(if $(BR2_PACKAGE_COLLECTD_INTERFACE),--enable-interface,--disable-interface) \
	$(if $(BR2_PACKAGE_COLLECTD_IPTABLES),--enable-iptables,--disable-iptables) \
	$(if $(BR2_PACKAGE_COLLECTD_IRQ),--enable-irq,--disable-irq) \
	$(if $(BR2_PACKAGE_COLLECTD_LOAD),--enable-load,--disable-load) \
	$(if $(BR2_PACKAGE_COLLECTD_LOGFILE),--enable-logfile,--disable-logfile) \
	$(if $(BR2_PACKAGE_COLLECTD_MD),--enable-md,--disable-md) \
	$(if $(BR2_PACKAGE_COLLECTD_MEMCACHED),--enable-memcached,--disable-memcached) \
	$(if $(BR2_PACKAGE_COLLECTD_MEMORY),--enable-memory,--disable-memory) \
	$(if $(BR2_PACKAGE_COLLECTD_MYSQL),--enable-mysql,--disable-mysql) \
	$(if $(BR2_PACKAGE_COLLECTD_NETWORK),--enable-network,--disable-network) \
	$(if $(BR2_PACKAGE_COLLECTD_NFS),--enable-nfs,--disable-nfs) \
	$(if $(BR2_PACKAGE_COLLECTD_NOTIFICATION),--enable-target_notification,--disable-target_notification) \
	$(if $(BR2_PACKAGE_COLLECTD_NOTIFY_EMAIL),--enable-notify_email,--disable-notify_email) \
	$(if $(BR2_PACKAGE_COLLECTD_NTPD),--enable-ntpd,--disable-ntpd) \
	$(if $(BR2_PACKAGE_COLLECTD_OLSRD),--enable-olsrd,--disable-olsrd) \
	$(if $(BR2_PACKAGE_COLLECTD_OPENVPN),--enable-openvpn,--disable-openvpn) \
	$(if $(BR2_PACKAGE_COLLECTD_PING),--enable-ping,--disable-ping) \
	$(if $(BR2_PACKAGE_COLLECTD_PROCESSES),--enable-processes,--disable-processes) \
	$(if $(BR2_PACKAGE_COLLECTD_PROTOCOLS),--enable-protocols,--disable-protocols) \
	$(if $(BR2_PACKAGE_COLLECTD_REGEX),--enable-match_regex,--disable-match-regex) \
	$(if $(BR2_PACKAGE_COLLECTD_REPLACE),--enable-target_replace,--disable-target_replace) \
	$(if $(BR2_PACKAGE_COLLECTD_RIEMANN),--enable-write_riemann,--disable-write_riemann) \
	$(if $(BR2_PACKAGE_COLLECTD_RRDTOOL),--enable-rrdtool,--disable-rrdtool) \
	$(if $(BR2_PACKAGE_COLLECTD_SCALE),--enable-target_scale,--disable-target_scale) \
	$(if $(BR2_PACKAGE_COLLECTD_SENSORS),--enable-sensors,--disable-sensors) \
	$(if $(BR2_PACKAGE_COLLECTD_SERIAL),--enable-serial,--disable-serial) \
	$(if $(BR2_PACKAGE_COLLECTD_STATSD),--enable-statsd,--disable-statsd) \
	$(if $(BR2_PACKAGE_COLLECTD_SET),--enable-target_set,--disable-target_set) \
	$(if $(BR2_PACKAGE_COLLECTD_SNMP),--enable-snmp,--disable-snmp) \
	$(if $(BR2_PACKAGE_COLLECTD_SWAP),--enable-swap,--disable-swap) \
	$(if $(BR2_PACKAGE_COLLECTD_SYSLOG),--enable-syslog,--disable-syslog) \
	$(if $(BR2_PACKAGE_COLLECTD_TABLE),--enable-table,--disable-table) \
	$(if $(BR2_PACKAGE_COLLECTD_TAIL),--enable-tail,--disable-tail) \
	$(if $(BR2_PACKAGE_COLLECTD_TAIL_CSV),--enable-tail_csv,--disable-tail_csv) \
	$(if $(BR2_PACKAGE_COLLECTD_TCPCONNS),--enable-tcpconns,--disable-tcpconns) \
	$(if $(BR2_PACKAGE_COLLECTD_THERMAL),--enable-thermal,--disable-thermal) \
	$(if $(BR2_PACKAGE_COLLECTD_THRESHOLD),--enable-threshold,--disable-threshold) \
	$(if $(BR2_PACKAGE_COLLECTD_TIMEDIFF),--enable-match_timediff,--disable-match_timediff) \
	$(if $(BR2_PACKAGE_COLLECTD_UNIXSOCK),--enable-unixsock,--disable-unixsock) \
	$(if $(BR2_PACKAGE_COLLECTD_UPTIME),--enable-uptime,--disable-uptime) \
	$(if $(BR2_PACKAGE_COLLECTD_USERS),--enable-users,--disable-users) \
	$(if $(BR2_PACKAGE_COLLECTD_VALUE),--enable-match_value,--disable-match_value) \
	$(if $(BR2_PACKAGE_COLLECTD_VMEM),--enable-vmem,--disable-vmem) \
	$(if $(BR2_PACKAGE_COLLECTD_WIRELESS),--enable-wireless,--disable-wireless) \
	$(if $(BR2_PACKAGE_COLLECTD_WRITEHTTP),--enable-write_http,--disable-write_http)

COLLECTD_DEPENDENCIES = host-pkgconf \
	$(if $(BR2_PACKAGE_COLLECTD_APACHE),libcurl) \
	$(if $(BR2_PACKAGE_COLLECTD_BIND),libcurl libxml2) \
	$(if $(BR2_PACKAGE_COLLECTD_CURL),libcurl) \
	$(if $(BR2_PACKAGE_COLLECTD_CURL_JSON),libcurl yajl) \
	$(if $(BR2_PACKAGE_COLLECTD_CURL_XML),libcurl libxml2) \
	$(if $(BR2_PACKAGE_COLLECTD_DNS),libpcap) \
	$(if $(BR2_PACKAGE_COLLECTD_IPTABLES),iptables) \
	$(if $(BR2_PACKAGE_COLLECTD_MYSQL),mysql) \
	$(if $(BR2_PACKAGE_COLLECTD_NOTIFY_EMAIL),libesmtp) \
	$(if $(BR2_PACKAGE_COLLECTD_PING),liboping) \
	$(if $(BR2_PACKAGE_COLLECTD_RIEMANN),protobuf-c) \
	$(if $(BR2_PACKAGE_COLLECTD_RRDTOOL),rrdtool) \
	$(if $(BR2_PACKAGE_COLLECTD_SENSORS),lm-sensors) \
	$(if $(BR2_PACKAGE_COLLECTD_SNMP),netsnmp) \
	$(if $(BR2_PACKAGE_COLLECTD_WRITEHTTP),libcurl)

# include/library fixups
ifeq ($(BR2_PACKAGE_LIBCURL),y)
	COLLECTD_CONF_OPT += --with-libcurl=$(STAGING_DIR)/usr
endif
ifeq ($(BR2_PACKAGE_MYSQL),y)
	COLLECTD_CONF_OPT += --with-libmysql=$(STAGING_DIR)/usr
endif
ifeq ($(BR2_PACKAGE_NETSNMP),y)
	COLLECTD_CONF_OPT += --with-libnetsnmp=$(STAGING_DIR)/usr/bin/net-snmp-config
endif
ifeq ($(BR2_PACKAGE_YAJL),y)
	COLLECTD_CONF_OPT += --with-yajl=$(STAGING_DIR)/usr
endif

# network can use libgcrypt
ifeq ($(BR2_PACKAGE_LIBGCRYPT),y)
	COLLECTD_DEPENDENCIES += libgcrypt
	COLLECTD_CONF_OPT += --with-libgcrypt=$(STAGING_DIR)/usr
endif

# released software should not break on minor warnings
define COLLECTD_DROP_WERROR
	$(SED) 's/-Werror//' \
		$(@D)/src/Makefile.in $(@D)/src/libcollectdclient/Makefile.in
endef

COLLECTD_POST_PATCH_HOOKS += COLLECTD_DROP_WERROR

define COLLECTD_INSTALL_TARGET_CMDS
	$(MAKE) DESTDIR=$(TARGET_DIR) -C $(@D) install
	rm -f $(TARGET_DIR)/usr/bin/collectd-nagios
	rm -f $(TARGET_DIR)/usr/share/collectd/postgresql_default.conf
endef

$(eval $(autotools-package))
