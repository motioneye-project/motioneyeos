################################################################################
#
# rpm
#
################################################################################

RPM_VERSION_MAJOR = 5.2
RPM_VERSION = $(RPM_VERSION_MAJOR).0
RPM_SITE = http://rpm5.org/files/rpm/rpm-$(RPM_VERSION_MAJOR)
RPM_DEPENDENCIES = host-pkgconf zlib beecrypt neon popt openssl
RPM_LICENSE = LGPLv2.1
RPM_LICENSE_FILES = COPYING.LIB

RPM_CONF_ENV = \
	CFLAGS="$(TARGET_CFLAGS) -I$(STAGING_DIR)/usr/include/beecrypt -I$(STAGING_DIR)/usr/include/neon -DHAVE_MUTEX_THREAD_ONLY" \
	ac_cv_va_copy=yes

RPM_CONF_OPTS = \
	--disable-build-versionscript \
	--disable-rpath \
	--without-selinux \
	--without-python \
	--without-perl \
	--with-openssl=external \
	--with-zlib=external \
	--with-libbeecrypt=$(STAGING_DIR) \
	--with-popt=external

ifeq ($(BR2_NEEDS_GETTEXT_IF_LOCALE),y)
RPM_DEPENDENCIES += gettext
endif

ifeq ($(BR2_PACKAGE_PCRE),y)
RPM_DEPENDENCIES += pcre
RPM_CONF_OPTS += --with-pcre=external
else
RPM_CONF_OPTS += --with-pcre=none
endif

ifeq ($(BR2_PACKAGE_FILE),y)
RPM_DEPENDENCIES += file
RPM_CONF_OPTS += --with-file=external
else
RPM_CONF_OPTS += --with-file=none
endif

# xz payload support needs a toolchain w/ C++
ifeq ($(BR2_PACKAGE_XZ)$(BR2_INSTALL_LIBSTDCPP),yy)
RPM_DEPENDENCIES += xz
RPM_CONF_OPTS += --with-xz=external
else
RPM_CONF_OPTS += --with-xz=none
endif

ifeq ($(BR2_PACKAGE_BZIP2),y)
RPM_CONF_OPTS += --with-bzip2
RPM_DEPENDENCIES += bzip2
endif

RPM_MAKE = $(MAKE1)

RPM_INSTALL_TARGET_OPTS = DESTDIR=$(TARGET_DIR) program_transform_name= install

$(eval $(autotools-package))
