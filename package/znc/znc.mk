################################################################################
#
# znc
#
################################################################################

ZNC_VERSION = 1.7.5
ZNC_SITE = http://znc.in/releases/archive
ZNC_LICENSE = Apache-2.0
ZNC_LICENSE_FILES = LICENSE
ZNC_DEPENDENCIES = host-pkgconf
ZNC_CONF_OPTS = -DWANT_CYRUS=OFF -DWANT_I18N=OFF -DWANT_PERL=OFF

# Before CMake 3.10, passing THREADS_PTHREAD_ARG=OFF was needed to
# disable a try_run() call in the FindThreads tests, which caused a
# build failure when cross-compiling.
ZNC_CONF_OPTS += -DTHREADS_PTHREAD_ARG=OFF

ifeq ($(BR2_PACKAGE_ICU),y)
ZNC_DEPENDENCIES += icu
ZNC_CONF_OPTS += -DWANT_ICU=ON
else
ZNC_CONF_OPTS += -DWANT_ICU=OFF
endif

ifeq ($(BR2_PACKAGE_OPENSSL),y)
ZNC_DEPENDENCIES += openssl
ZNC_CONF_OPTS += -DWANT_OPENSSL=ON
else
ZNC_CONF_OPTS += -DWANT_OPENSSL=OFF
endif

ifeq ($(BR2_PACKAGE_ZLIB),y)
ZNC_DEPENDENCIES += zlib
ZNC_CONF_OPTS += -DWANT_ZLIB=ON
else
ZNC_CONF_OPTS += -DWANT_ZLIB=OFF
endif

# python support depends on icu
ifeq ($(BR2_PACKAGE_ICU)$(BR2_PACKAGE_PYTHON3),yy)
ZNC_DEPENDENCIES += python3 host-swig
ZNC_CONF_OPTS += \
	-DWANT_PYTHON=ON \
	-DWANT_PYTHON_VERSION=python3 \
	-DWANT_SWIG=ON
else
ZNC_CONF_OPTS += \
	-DWANT_PYTHON=OFF \
	-DWANT_SWIG=OFF
endif

$(eval $(cmake-package))
