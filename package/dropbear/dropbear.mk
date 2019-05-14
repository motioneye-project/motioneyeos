################################################################################
#
# dropbear
#
################################################################################

DROPBEAR_VERSION = 2018.76
DROPBEAR_SITE = https://matt.ucc.asn.au/dropbear/releases
DROPBEAR_SOURCE = dropbear-$(DROPBEAR_VERSION).tar.bz2
DROPBEAR_LICENSE = MIT, BSD-2-Clause-like, BSD-2-Clause
DROPBEAR_LICENSE_FILES = LICENSE
DROPBEAR_TARGET_BINS = dropbearkey dropbearconvert scp
DROPBEAR_PROGRAMS = dropbear $(DROPBEAR_TARGET_BINS)

# Disable hardening flags added by dropbear configure.ac, and let
# Buildroot add them when the relevant options are enabled. This
# prevents dropbear from using SSP support when not available.
DROPBEAR_CONF_OPTS = --disable-harden

ifeq ($(BR2_PACKAGE_DROPBEAR_CLIENT),y)
# Build dbclient, and create a convenience symlink named ssh
DROPBEAR_PROGRAMS += dbclient
DROPBEAR_TARGET_BINS += dbclient ssh
endif

DROPBEAR_MAKE = \
	$(MAKE) MULTI=1 SCPPROGRESS=1 \
	PROGRAMS="$(DROPBEAR_PROGRAMS)"

# With BR2_SHARED_STATIC_LIBS=y the generic infrastructure adds a
# --enable-static flags causing dropbear to be built as a static
# binary. Adding a --disable-static reverts this
ifeq ($(BR2_SHARED_STATIC_LIBS),y)
DROPBEAR_CONF_OPTS += --disable-static
endif

ifeq ($(BR2_PACKAGE_LINUX_PAM),y)
define DROPBEAR_SVR_PAM_AUTH
	echo '#define DROPBEAR_SVR_PASSWORD_AUTH 0'     >> $(@D)/localoptions.h
	echo '#define DROPBEAR_SVR_PAM_AUTH 1'          >> $(@D)/localoptions.h
endef
define DROPBEAR_INSTALL_PAM_CONF
	$(INSTALL) -D -m 644 package/dropbear/etc-pam.d-sshd $(TARGET_DIR)/etc/pam.d/sshd
endef
DROPBEAR_DEPENDENCIES += linux-pam
DROPBEAR_CONF_OPTS += --enable-pam
DROPBEAR_POST_EXTRACT_HOOKS += DROPBEAR_SVR_PAM_AUTH
DROPBEAR_POST_INSTALL_TARGET_HOOKS += DROPBEAR_INSTALL_PAM_CONF
else
# Ensure that dropbear doesn't use crypt() when it's not available
define DROPBEAR_SVR_PASSWORD_AUTH
	echo '#if !HAVE_CRYPT'                          >> $(@D)/localoptions.h
	echo '#define DROPBEAR_SVR_PASSWORD_AUTH 0'     >> $(@D)/localoptions.h
	echo '#endif'                                   >> $(@D)/localoptions.h
endef
DROPBEAR_POST_EXTRACT_HOOKS += DROPBEAR_SVR_PASSWORD_AUTH
endif

define DROPBEAR_DISABLE_LEGACY_CRYPTO
	echo '#define DROPBEAR_3DES 0'                  >> $(@D)/localoptions.h
	echo '#define DROPBEAR_ENABLE_CBC_MODE 0'       >> $(@D)/localoptions.h
	echo '#define DROPBEAR_SHA1_96_HMAC 0'          >> $(@D)/localoptions.h
	echo '#define DROPBEAR_DSS 0'                   >> $(@D)/localoptions.h
	echo '#define DROPBEAR_DH_GROUP1 0'             >> $(@D)/localoptions.h
endef
ifneq ($(BR2_PACKAGE_DROPBEAR_LEGACY_CRYPTO),y)
DROPBEAR_POST_EXTRACT_HOOKS += DROPBEAR_DISABLE_LEGACY_CRYPTO
endif

define DROPBEAR_ENABLE_REVERSE_DNS
	echo '#define DO_HOST_LOOKUP 1'                 >> $(@D)/localoptions.h
endef

define DROPBEAR_BUILD_FEATURED
	echo '#define DROPBEAR_SMALL_CODE 0'            >> $(@D)/localoptions.h
	echo '#define DROPBEAR_TWOFISH128 1'            >> $(@D)/localoptions.h
	echo '#define DROPBEAR_TWOFISH256 1'            >> $(@D)/localoptions.h
endef

define DROPBEAR_DISABLE_STANDALONE
	echo '#define NON_INETD_MODE 0'                 >> $(@D)/localoptions.h
endef

define DROPBEAR_CUSTOM_PATH
	echo '#define DEFAULT_PATH $(BR2_SYSTEM_DEFAULT_PATH)' >>$(@D)/localoptions.h
endef

DROPBEAR_POST_EXTRACT_HOOKS += DROPBEAR_CUSTOM_PATH

define DROPBEAR_INSTALL_INIT_SYSTEMD
	$(INSTALL) -D -m 644 package/dropbear/dropbear.service \
		$(TARGET_DIR)/usr/lib/systemd/system/dropbear.service
	mkdir -p $(TARGET_DIR)/etc/systemd/system/multi-user.target.wants
	ln -fs ../../../../usr/lib/systemd/system/dropbear.service \
		$(TARGET_DIR)/etc/systemd/system/multi-user.target.wants/dropbear.service
endef

ifeq ($(BR2_USE_MMU),y)
define DROPBEAR_INSTALL_INIT_SYSV
	$(INSTALL) -D -m 755 package/dropbear/S50dropbear \
		$(TARGET_DIR)/etc/init.d/S50dropbear
endef
else
DROPBEAR_POST_EXTRACT_HOOKS += DROPBEAR_DISABLE_STANDALONE
endif

ifeq ($(BR2_PACKAGE_DROPBEAR_DISABLE_REVERSEDNS),)
DROPBEAR_POST_EXTRACT_HOOKS += DROPBEAR_ENABLE_REVERSE_DNS
endif

ifeq ($(BR2_PACKAGE_DROPBEAR_SMALL),y)
DROPBEAR_CONF_OPTS += --disable-zlib --enable-bundled-libtom
else
DROPBEAR_POST_EXTRACT_HOOKS += DROPBEAR_BUILD_FEATURED
DROPBEAR_DEPENDENCIES += zlib libtomcrypt
DROPBEAR_CONF_OPTS += --disable-bundled-libtom
endif

ifneq ($(BR2_PACKAGE_DROPBEAR_WTMP),y)
DROPBEAR_CONF_OPTS += --disable-wtmp
endif

ifneq ($(BR2_PACKAGE_DROPBEAR_LASTLOG),y)
DROPBEAR_CONF_OPTS += --disable-lastlog
endif

define DROPBEAR_INSTALL_TARGET_CMDS
	$(INSTALL) -m 755 $(@D)/dropbearmulti $(TARGET_DIR)/usr/sbin/dropbear
	for f in $(DROPBEAR_TARGET_BINS); do \
		ln -snf ../sbin/dropbear $(TARGET_DIR)/usr/bin/$$f ; \
	done
	ln -snf /var/run/dropbear $(TARGET_DIR)/etc/dropbear
endef

$(eval $(autotools-package))
