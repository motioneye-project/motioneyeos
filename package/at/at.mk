#############################################################
#
# at
#
#############################################################
AT_VERSION = 3.1.12
AT_SOURCE = at_$(AT_VERSION).orig.tar.gz
AT_SITE = $(BR2_DEBIAN_MIRROR)/debian/pool/main/a/at
AT_AUTORECONF = YES
AT_INSTALL_STAGING = NO
AT_INSTALL_TARGET = YES
# no install-strip / install-exec
AT_INSTALL_TARGET_OPT = DESTDIR=$(TARGET_DIR) install

AT_CONF_OPT = \
        --with-jobdir=/var/spool/cron/atjobs \
        --with-atspool=/var/spool/cron/atspool \
        --with-daemon_username=root \
        --with-daemon_groupname=root \
	SENDMAIL=/usr/sbin/sendmail

$(eval $(call AUTOTARGETS,package,at))

$(AT_HOOK_POST_INSTALL): $(AT_TARGET_INSTALL_TARGET)
	$(INSTALL) -m 0755 package/at/S99at $(TARGET_DIR)/etc/init.d/S99at
	touch $@

$(AT_TARGET_UNINSTALL):
	$(call MESSAGE,"Uninstalling")
	rm -rf $(addprefix $(TARGET_DIR),/usr/lib/atspool \
					 /usr/lib/atjobs \
					 /etc/at.deny \
					 /etc/init.d/S99at \
					 /usr/bin/at \
					 /usr/bin/atrm \
					 /usr/bin/atq \
					 /usr/sbin/atd \
					 /usr/sbin/atrun)
	rm -f $(addprefix $(TARGET_DIR)/usr/man/man*/, \
		at.1 atq.1 atrm.1 batch.1 at_allow.5 at_deny.5 atd.8 atrun.8)
	rm -f $(AT_TARGET_INSTALL_TARGET) $(AT_HOOK_POST_INSTALL)
