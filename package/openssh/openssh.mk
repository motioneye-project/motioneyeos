#############################################################
#
# openssh
#
#############################################################
OPENSSH_VERSION=5.1p1
OPENSSH_SITE=ftp://ftp.openbsd.org/pub/OpenBSD/OpenSSH/portable

OPENSSH_CONF_ENV = LD=$(TARGET_CC)
OPENSSH_CONF_OPT = --libexecdir=/usr/lib --disable-lastlog --disable-utmp \
		--disable-utmpx --disable-wtmp --disable-wtmpx --without-x

OPENSSH_INSTALL_TARGET_OPT = DESTDIR=$(TARGET_DIR) install

OPENSSH_DEPENDENCIES = zlib openssl

$(eval $(call AUTOTARGETS,package,openssh))

$(OPENSSH_HOOK_POST_INSTALL):
	$(INSTALL) -D -m 755 package/openssh/S50sshd $(TARGET_DIR)/etc/init.d/S50sshd
	touch $@
