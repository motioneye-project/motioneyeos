################################################################################
#
# collectd
#
################################################################################

COLLECTD_VERSION = 5.10.0
COLLECTD_SITE = \
	https://github.com/collectd/collectd/releases/download/$(COLLECTD_VERSION)
COLLECTD_SOURCE = collectd-$(COLLECTD_VERSION).tar.bz2
COLLECTD_CONF_ENV = ac_cv_lib_yajl_yajl_alloc=yes
COLLECTD_INSTALL_STAGING = YES
COLLECTD_LICENSE = MIT (daemon, plugins), GPL-2.0 (plugins), LGPL-2.1 (plugins)
COLLECTD_LICENSE_FILES = COPYING
# We're patching configure.ac
COLLECTD_AUTORECONF = YES

# These require unmet dependencies, are fringe, pointless or deprecated
COLLECTD_PLUGINS_DISABLE = \
	apple_sensors aquaero ascent barometer dbi dpdkstat email \
	gmond hddtemp intel_rdt ipmi java lpar \
	madwifi mbmon mic multimeter netapp notify_desktop numa \
	nut oracle perl pf pinba powerdns python routeros \
	rrdcached sigrok tape target_v5upgrade teamspeak2 ted \
	tokyotyrant turbostat uuid varnish virt vserver write_kafka \
	write_mongodb xencpu xmms zfs_arc zone

COLLECTD_CONF_ENV += LIBS="-lm"

#
# NOTE: There's also a third availible setting "intswap", which might
# be needed on some old ARM hardware (see [2]), but is not being
# accounted for as per discussion [1]
#
# [1] http://lists.busybox.net/pipermail/buildroot/2017-November/206100.html
# [2] http://lists.busybox.net/pipermail/buildroot/2017-November/206251.html
#
ifeq ($(BR2_ENDIAN),"BIG")
COLLECTD_FP_LAYOUT=endianflip
else
COLLECTD_FP_LAYOUT=nothing
endif

COLLECTD_CONF_OPTS += \
	--with-nan-emulation \
	--with-fp-layout=$(COLLECTD_FP_LAYOUT) \
	--with-perl-bindings=no \
	--disable-werror \
	$(foreach p, $(COLLECTD_PLUGINS_DISABLE), --disable-$(p)) \
	$(if $(BR2_PACKAGE_COLLECTD_AGGREGATION),--enable-aggregation,--disable-aggregation) \
	$(if $(BR2_PACKAGE_COLLECTD_AMQP),--enable-amqp,--disable-amqp) \
	$(if $(BR2_PACKAGE_COLLECTD_APACHE),--enable-apache,--disable-apache) \
	$(if $(BR2_PACKAGE_COLLECTD_APCUPS),--enable-apcups,--disable-apcups) \
	$(if $(BR2_PACKAGE_COLLECTD_BATTERY),--enable-battery,--disable-battery) \
	$(if $(BR2_PACKAGE_COLLECTD_BIND),--enable-bind,--disable-bind) \
	$(if $(BR2_PACKAGE_COLLECTD_CEPH),--enable-ceph,--disable-ceph) \
	$(if $(BR2_PACKAGE_COLLECTD_CHRONY),--enable-chrony,--disable-chrony) \
	$(if $(BR2_PACKAGE_COLLECTD_CGROUPS),--enable-cgroups,--disable-cgroups) \
	$(if $(BR2_PACKAGE_COLLECTD_CONNTRACK),--enable-conntrack,--disable-conntrack) \
	$(if $(BR2_PACKAGE_COLLECTD_CONTEXTSWITCH),--enable-contextswitch,--disable-contextswitch) \
	$(if $(BR2_PACKAGE_COLLECTD_CPU),--enable-cpu,--disable-cpu) \
	$(if $(BR2_PACKAGE_COLLECTD_CPUFREQ),--enable-cpufreq,--disable-cpufreq) \
	$(if $(BR2_PACKAGE_COLLECTD_CPUSLEEP),--enable-cpusleep,--disable-cpusleep) \
	$(if $(BR2_PACKAGE_COLLECTD_CSV),--enable-csv,--disable-csv) \
	$(if $(BR2_PACKAGE_COLLECTD_CURL),--enable-curl,--disable-curl) \
	$(if $(BR2_PACKAGE_COLLECTD_CURL_JSON),--enable-curl_json,--disable-curl_json) \
	$(if $(BR2_PACKAGE_COLLECTD_CURL_XML),--enable-curl_xml,--disable-curl_xml) \
	$(if $(BR2_PACKAGE_COLLECTD_DF),--enable-df,--disable-df) \
	$(if $(BR2_PACKAGE_COLLECTD_DISK),--enable-disk,--disable-disk) \
	$(if $(BR2_PACKAGE_COLLECTD_DNS),--enable-dns,--disable-dns) \
	$(if $(BR2_PACKAGE_COLLECTD_DRBD),--enable-drbd,--disable-drbd) \
	$(if $(BR2_PACKAGE_COLLECTD_EMPTY_COUNTER),--enable-match_empty_counter,--disable-match_empty_counter) \
	$(if $(BR2_PACKAGE_COLLECTD_ENTROPY),--enable-entropy,--disable-entropy) \
	$(if $(BR2_PACKAGE_COLLECTD_ETHSTAT),--enable-ethstat,--disable-ethstat) \
	$(if $(BR2_PACKAGE_COLLECTD_EXEC),--enable-exec,--disable-exec) \
	$(if $(BR2_PACKAGE_COLLECTD_FHCOUNT),--enable-fhcount,--disable-fhcount) \
	$(if $(BR2_PACKAGE_COLLECTD_FILECOUNT),--enable-filecount,--disable-filecount) \
	$(if $(BR2_PACKAGE_COLLECTD_FSCACHE),--enable-fscache,--disable-fscache) \
	$(if $(BR2_PACKAGE_COLLECTD_GPS),--enable-gps,--disable-gps) \
	$(if $(BR2_PACKAGE_COLLECTD_GRAPHITE),--enable-write_graphite,--disable-write_graphite) \
	$(if $(BR2_PACKAGE_COLLECTD_GRPC),--enable-grpc,--disable-grpc) \
	$(if $(BR2_PACKAGE_COLLECTD_HASHED),--enable-match_hashed,--disable-match_hashed) \
	$(if $(BR2_PACKAGE_COLLECTD_HUGEPAGES),--enable-hugepages,--disable-hugepages) \
	$(if $(BR2_PACKAGE_COLLECTD_INTERFACE),--enable-interface,--disable-interface) \
	$(if $(BR2_PACKAGE_COLLECTD_IPC),--enable-ipc,--disable-ipc) \
	$(if $(BR2_PACKAGE_COLLECTD_IPTABLES),--enable-iptables,--disable-iptables) \
	$(if $(BR2_PACKAGE_COLLECTD_IPVS),--enable-ipvs,--disable-ipvs) \
	$(if $(BR2_PACKAGE_COLLECTD_IRQ),--enable-irq,--disable-irq) \
	$(if $(BR2_PACKAGE_COLLECTD_LOAD),--enable-load,--disable-load) \
	$(if $(BR2_PACKAGE_COLLECTD_LOGFILE),--enable-logfile,--disable-logfile) \
	$(if $(BR2_PACKAGE_COLLECTD_LOGSTASH),--enable-log_logstash,--disable-log_logstash) \
	$(if $(BR2_PACKAGE_COLLECTD_LUA),--enable-lua,--disable-lua) \
	$(if $(BR2_PACKAGE_COLLECTD_LVM),--enable-lvm,--disable-lvm) \
	$(if $(BR2_PACKAGE_COLLECTD_MD),--enable-md,--disable-md) \
	$(if $(BR2_PACKAGE_COLLECTD_MEMCACHEC),--enable-memcachec,--disable-memcachec) \
	$(if $(BR2_PACKAGE_COLLECTD_MEMCACHED),--enable-memcached,--disable-memcached) \
	$(if $(BR2_PACKAGE_COLLECTD_MEMORY),--enable-memory,--disable-memory) \
	$(if $(BR2_PACKAGE_COLLECTD_MODBUS),--enable-modbus,--disable-modbus) \
	$(if $(BR2_PACKAGE_COLLECTD_MQTT),--enable-mqtt,--disable-mqtt) \
	$(if $(BR2_PACKAGE_COLLECTD_MYSQL),--enable-mysql,--disable-mysql) \
	$(if $(BR2_PACKAGE_COLLECTD_NETLINK),--enable-netlink,--disable-netlink) \
	$(if $(BR2_PACKAGE_COLLECTD_NETWORK),--enable-network,--disable-network) \
	$(if $(BR2_PACKAGE_COLLECTD_NFS),--enable-nfs,--disable-nfs) \
	$(if $(BR2_PACKAGE_COLLECTD_NGINX),--enable-nginx,--disable-nginx) \
	$(if $(BR2_PACKAGE_COLLECTD_NOTIFICATION),--enable-target_notification,--disable-target_notification) \
	$(if $(BR2_PACKAGE_COLLECTD_NOTIFY_EMAIL),--enable-notify_email,--disable-notify_email) \
	$(if $(BR2_PACKAGE_COLLECTD_NOTIFY_NAGIOS),--enable-notify_nagios,--disable-notify_nagios) \
	$(if $(BR2_PACKAGE_COLLECTD_NTPD),--enable-ntpd,--disable-ntpd) \
	$(if $(BR2_PACKAGE_COLLECTD_OLSRD),--enable-olsrd,--disable-olsrd) \
	$(if $(BR2_PACKAGE_COLLECTD_ONEWIRE),--enable-onewire,--disable-onewire) \
	$(if $(BR2_PACKAGE_COLLECTD_OPENLDAP),--enable-openldap,--disable-openldap) \
	$(if $(BR2_PACKAGE_COLLECTD_OPENVPN),--enable-openvpn,--disable-openvpn) \
	$(if $(BR2_PACKAGE_COLLECTD_PING),--enable-ping,--disable-ping) \
	$(if $(BR2_PACKAGE_COLLECTD_POSTGRESQL),--enable-postgresql,--disable-postgresql) \
	$(if $(BR2_PACKAGE_COLLECTD_PROCESSES),--enable-processes,--disable-processes) \
	$(if $(BR2_PACKAGE_COLLECTD_PROTOCOLS),--enable-protocols,--disable-protocols) \
	$(if $(BR2_PACKAGE_COLLECTD_REDIS),--enable-redis,--disable-redis) \
	$(if $(BR2_PACKAGE_COLLECTD_REGEX),--enable-match_regex,--disable-match-regex) \
	$(if $(BR2_PACKAGE_COLLECTD_REPLACE),--enable-target_replace,--disable-target_replace) \
	$(if $(BR2_PACKAGE_COLLECTD_RIEMANN),--enable-write_riemann,--disable-write_riemann) \
	$(if $(BR2_PACKAGE_COLLECTD_RRDTOOL),--enable-rrdtool,--disable-rrdtool) \
	$(if $(BR2_PACKAGE_COLLECTD_SCALE),--enable-target_scale,--disable-target_scale) \
	$(if $(BR2_PACKAGE_COLLECTD_SENSORS),--enable-sensors,--disable-sensors) \
	$(if $(BR2_PACKAGE_COLLECTD_SERIAL),--enable-serial,--disable-serial) \
	$(if $(BR2_PACKAGE_COLLECTD_STATSD),--enable-statsd,--disable-statsd) \
	$(if $(BR2_PACKAGE_COLLECTD_SET),--enable-target_set,--disable-target_set) \
	$(if $(BR2_PACKAGE_COLLECTD_SMART),--enable-smart,--disable-smart) \
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
	$(if $(BR2_PACKAGE_COLLECTD_WRITEHTTP),--enable-write_http,--disable-write_http) \
	$(if $(BR2_PACKAGE_COLLECTD_WRITELOG),--enable-write_log,--disable-write_log) \
	$(if $(BR2_PACKAGE_COLLECTD_WRITEPROMETHEUS),--enable-write_prometheus,--disable-write_prometheus) \
	$(if $(BR2_PACKAGE_COLLECTD_WRITEREDIS),--enable-write_redis,--disable-write_redis) \
	$(if $(BR2_PACKAGE_COLLECTD_WRITESENSU),--enable-write_sensu,--disable-write_sensu) \
	$(if $(BR2_PACKAGE_COLLECTD_WRITETSDB),--enable-write_tsdb,--disable-write_tsdb) \
	$(if $(BR2_PACKAGE_COLLECTD_ZOOKEEPER),--enable-zookeeper,--disable-zookeeper)

COLLECTD_DEPENDENCIES = \
	host-pkgconf \
	$(if $(BR2_PACKAGE_COLLECTD_AMQP),rabbitmq-c) \
	$(if $(BR2_PACKAGE_COLLECTD_APACHE),libcurl) \
	$(if $(BR2_PACKAGE_COLLECTD_BIND),libcurl libxml2) \
	$(if $(BR2_PACKAGE_COLLECTD_CEPH),yajl) \
	$(if $(BR2_PACKAGE_COLLECTD_CURL),libcurl) \
	$(if $(BR2_PACKAGE_COLLECTD_CURL_JSON),libcurl yajl) \
	$(if $(BR2_PACKAGE_COLLECTD_CURL_XML),libcurl libxml2) \
	$(if $(BR2_PACKAGE_COLLECTD_DNS),libpcap) \
	$(if $(BR2_PACKAGE_COLLECTD_GPS),gpsd) \
	$(if $(BR2_PACKAGE_COLLECTD_GRPC),grpc) \
	$(if $(BR2_PACKAGE_COLLECTD_IPTABLES),iptables) \
	$(if $(BR2_PACKAGE_COLLECTD_LOGSTASH),yajl) \
	$(if $(BR2_PACKAGE_COLLECTD_LUA),lua) \
	$(if $(BR2_PACKAGE_COLLECTD_LVM),lvm2) \
	$(if $(BR2_PACKAGE_COLLECTD_MEMCACHEC),libmemcached) \
	$(if $(BR2_PACKAGE_COLLECTD_MODBUS),libmodbus) \
	$(if $(BR2_PACKAGE_COLLECTD_MQTT),mosquitto) \
	$(if $(BR2_PACKAGE_COLLECTD_MYSQL),mysql) \
	$(if $(BR2_PACKAGE_COLLECTD_NETLINK),libmnl) \
	$(if $(BR2_PACKAGE_COLLECTD_NGINX),libcurl) \
	$(if $(BR2_PACKAGE_COLLECTD_NOTIFY_EMAIL),libesmtp) \
	$(if $(BR2_PACKAGE_COLLECTD_ONEWIRE),owfs) \
	$(if $(BR2_PACKAGE_COLLECTD_OPENLDAP),openldap) \
	$(if $(BR2_PACKAGE_COLLECTD_PING),liboping) \
	$(if $(BR2_PACKAGE_COLLECTD_POSTGRESQL),postgresql) \
	$(if $(BR2_PACKAGE_COLLECTD_REDIS),hiredis) \
	$(if $(BR2_PACKAGE_COLLECTD_RIEMANN),libtool riemann-c-client) \
	$(if $(BR2_PACKAGE_COLLECTD_RRDTOOL),rrdtool) \
	$(if $(BR2_PACKAGE_COLLECTD_SENSORS),lm-sensors) \
	$(if $(BR2_PACKAGE_COLLECTD_SMART),libatasmart) \
	$(if $(BR2_PACKAGE_COLLECTD_SNMP),netsnmp) \
	$(if $(BR2_PACKAGE_COLLECTD_WRITEHTTP),libcurl) \
	$(if $(BR2_PACKAGE_COLLECTD_WRITEPROMETHEUS),libmicrohttpd protobuf-c) \
	$(if $(BR2_PACKAGE_COLLECTD_WRITEREDIS),hiredis)

# include/library fixups
ifeq ($(BR2_PACKAGE_GRPC),y)
COLLECTD_CONF_OPTS += --with-libgrpc++=$(STAGING_DIR)/usr
endif
ifeq ($(BR2_PACKAGE_LIBCURL),y)
COLLECTD_CONF_OPTS += --with-libcurl=$(STAGING_DIR)/usr
endif
ifeq ($(BR2_PACKAGE_MYSQL),y)
COLLECTD_CONF_OPTS += --with-libmysql=$(STAGING_DIR)/usr
endif
ifeq ($(BR2_PACKAGE_NETSNMP),y)
COLLECTD_CONF_OPTS += --with-libnetsnmp=$(STAGING_DIR)/usr
endif
ifeq ($(BR2_PACKAGE_POSTGRESQL),y)
COLLECTD_CONF_OPTS += --with-libpq=$(STAGING_DIR)/usr/bin/pg_config
COLLECTD_CONF_ENV += LIBS="-lpthread -lm"
endif
ifeq ($(BR2_PACKAGE_YAJL),y)
COLLECTD_CONF_OPTS += --with-libyajl=$(STAGING_DIR)/usr
endif

# network can use libgcrypt
ifeq ($(BR2_PACKAGE_LIBGCRYPT),y)
COLLECTD_DEPENDENCIES += libgcrypt
COLLECTD_CONF_OPTS += --with-libgcrypt=$(STAGING_DIR)/usr/bin/libgcrypt-config
else
COLLECTD_CONF_OPTS += --with-libgcrypt=no
endif

define COLLECTD_INSTALL_TARGET_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) DESTDIR=$(TARGET_DIR) -C $(@D) install
	rm -f $(TARGET_DIR)/usr/bin/collectd-nagios
endef

ifeq ($(BR2_PACKAGE_COLLECTD_POSTGRESQL),)
define COLLECTD_REMOVE_UNNEEDED_POSTGRESQL_DEFAULT_CONF
	rm -f $(TARGET_DIR)/usr/share/collectd/postgresql_default.conf
endef
COLLECTD_POST_INSTALL_TARGET_HOOKS += COLLECTD_REMOVE_UNNEEDED_POSTGRESQL_DEFAULT_CONF
endif

define COLLECTD_INSTALL_INIT_SYSTEMD
	$(INSTALL) -D -m 644 package/collectd/collectd.service \
		$(TARGET_DIR)/usr/lib/systemd/system/collectd.service
endef

$(eval $(autotools-package))
