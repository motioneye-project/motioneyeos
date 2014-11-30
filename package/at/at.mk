################################################################################
#
# at
#
################################################################################

AT_VERSION = 3.1.13
AT_SOURCE = at_$(AT_VERSION).orig.tar.gz
AT_SITE = http://snapshot.debian.org/archive/debian/20141023T043132Z/pool/main/a/at
# missing deps for parsetime.l
AT_MAKE = $(MAKE1)
AT_AUTORECONF = YES
AT_DEPENDENCIES = $(if $(BR2_PACKAGE_FLEX),flex) host-bison host-flex
AT_LICENSE = GPLv2+, GPLv3+, ISC
AT_LICENSE_FILES = Copyright COPYING

AT_CONF_OPTS = \
	--with-jobdir=/var/spool/cron/atjobs \
	--with-atspool=/var/spool/cron/atspool \
	--with-daemon_username=root \
	--with-daemon_groupname=root \
	SENDMAIL=/usr/sbin/sendmail

define AT_INSTALL_INIT_SYSV
	$(INSTALL) -m 0755 -D package/at/S99at $(TARGET_DIR)/etc/init.d/S99at
endef

$(eval $(autotools-package))
