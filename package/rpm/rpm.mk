#############################################################
#
# rpm
#
#############################################################
RPM_VERSION = 5.1.1
RPM_SITE = http://rpm5.org/files/rpm/rpm-5.1/
RPM_AUTORECONF = YES

RPM_DEPENDENCIES = zlib bzip2 beecrypt neon popt

RPM_CONF_ENV = CFLAGS="-I$(STAGING_DIR)/usr/include/beecrypt -I$(STAGING_DIR)/usr/include/neon" \
		ac_cv_va_copy=yes

RPM_CONF_OPT = --disable-build-versionscript --disable-rpath \
	--without-selinux \
	--without-python --without-perl \
	--with-zlib=$(STAGING_DIR) \
	--with-libbeecrypt=$(STAGING_DIR) \
	--with-popt=$(STAGING_DIR) \
	--with-mutex=UNIX/fcntl \
	--with-bzip2 \
	$(DISABLE_NLS)

RPM_MAKE_OPT = -j1

RPM_INSTALL_TARGET_OPT=DESTDIR=$(TARGET_DIR) program_transform_name= install

$(eval $(call AUTOTARGETS,package,rpm))
