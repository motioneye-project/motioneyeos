#############################################################
#
# dropbear
#
#############################################################

DROPBEAR_VERSION = 0.52
DROPBEAR_SOURCE = dropbear-$(DROPBEAR_VERSION).tar.gz
DROPBEAR_SITE = http://matt.ucc.asn.au/dropbear/releases
DROPBEAR_DEPENDENCIES = zlib
DROPBEAR_TARGET_BINS = dbclient dropbearkey dropbearconvert scp ssh
# configure misdetects this as no, but the result is not used for
# anything. Unfortunately it breaks the build for other packages also
# checking for struct sockaddr_storage when using a shared config
# cache, so force it to yes
DROPBEAR_CONF_ENV = ac_cv_type_struct_sockaddr_storage=yes
DROPBEAR_MAKE =	$(MAKE) MULTI=1 SCPPROGRESS=1 \
		PROGRAMS="dropbear dbclient dropbearkey dropbearconvert scp"

define DROPBEAR_FIX_XAUTH
	$(SED) 's,^#define XAUTH_COMMAND.*/xauth,#define XAUTH_COMMAND "/usr/bin/xauth,g' $(@D)/options.h
endef

DROPBEAR_POST_EXTRACT_HOOKS += DROPBEAR_FIX_XAUTH

define DROPBEAR_DISABLE_REVERSE_DNS
	$(SED) 's,^#define DO_HOST_LOOKUP.*,/* #define DO_HOST_LOOKUP */,' $(@D)/options.h
endef

ifeq ($(BR2_PACKAGE_DROPBEAR_DISABLE_REVERSEDNS),y)
DROPBEAR_POST_EXTRACT_HOOKS += DROPBEAR_DISABLE_REVERSE_DNS
endif

define DROPBEAR_INSTALL_TARGET_CMDS
	$(INSTALL) -m 755 $(@D)/dropbearmulti $(TARGET_DIR)/usr/sbin/dropbear
	for f in $(DROPBEAR_TARGET_BINS); do \
		ln -snf ../sbin/dropbear $(TARGET_DIR)/usr/bin/$$f ; \
	done
	if [ ! -f $(TARGET_DIR)/etc/init.d/S50dropbear ]; then \
		$(INSTALL) -m 0755 -D package/dropbear/S50dropbear $(TARGET_DIR)/etc/init.d/S50dropbear; \
	fi
endef

define DROPBEAR_UNINSTALL_TARGET_CMDS
	rm -f $(TARGET_DIR)/usr/sbin/dropbear
	rm -f $(addprefix $(TARGET_DIR)/usr/bin/, $(DROPBEAR_TARGET_BINS))
	rm -f $(TARGET_DIR)/etc/init.d/S50dropbear
endef

$(eval $(call AUTOTARGETS,package,dropbear))
