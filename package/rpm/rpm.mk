#############################################################
#
# rpm
#
#############################################################
RPM_VERSION = 5.2.0
RPM_SITE = http://rpm5.org/files/rpm/rpm-5.2/
RPM_DEPENDENCIES = zlib beecrypt neon popt

RPM_CONF_ENV = CFLAGS="$(TARGET_CFLAGS) -I$(STAGING_DIR)/usr/include/beecrypt -I$(STAGING_DIR)/usr/include/neon -DHAVE_MUTEX_THREAD_ONLY" \
		ac_cv_va_copy=yes

RPM_CONF_OPT = --disable-build-versionscript --disable-rpath \
	--without-selinux \
	--without-python --without-perl \
	--with-openssl=external \
	--with-zlib=$(STAGING_DIR) \
	--with-libbeecrypt=$(STAGING_DIR) \
	--with-popt=$(STAGING_DIR)

ifeq ($(BR2_PACKAGE_PCRE),y)
RPM_DEPENDENCIES += pcre
RPM_CONF_OPT += --with-pcre=external
else
RPM_CONF_OPT += --with-pcre=no
endif

ifeq ($(BR2_PACKAGE_FILE),y)
RPM_DEPENDENCIES += file
RPM_CONF_OPT += --with-file=external
else
RPM_CONF_OPT += --with-file=no
endif

ifeq ($(BR2_PACKAGE_RPM_XZ_PAYLOADS),y)
RPM_CONF_OPT+=--with-xz
endif

ifeq ($(BR2_PACKAGE_RPM_BZIP2_PAYLOADS),y)
RPM_CONF_OPT+=--with-bzip2
RPM_DEPENDENCIES+=bzip2
endif

RPM_MAKE = $(MAKE1)

RPM_INSTALL_TARGET_OPT=DESTDIR=$(TARGET_DIR) program_transform_name= install

$(eval $(autotools-package))
