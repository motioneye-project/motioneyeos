################################################################################
#
# librtlsdr
#
################################################################################

LIBRTLSDR_VERSION = v0.5.3
LIBRTLSDR_SITE = $(call github,steve-m,librtlsdr,$(LIBRTLSDR_VERSION))
LIBRTLSDR_LICENSE = GPLv2+
LIBRTLSDR_LICENSE_FILES = COPYING
LIBRTLSDR_INSTALL_STAGING = YES
LIBRTLSDR_DEPENDENCIES = libusb

ifeq ($(BR2_PACKAGE_HAS_UDEV),y)
LIBRTLSDR_CONF_OPTS += -DINSTALL_UDEV_RULES=ON
endif

ifeq ($(BR2_PACKAGE_LIBRTLSDR_DETACH_DRIVER),y)
LIBRTLSDR_CONF_OPTS += -DDETACH_KERNEL_DRIVER=1
endif

# In case of static-lib-only builds, CMake's FindThreads.cmake code tries to
# get the right flags, checking first for -lpthreads, then -lpthread, and lastly
# for -pthread.
# The 2 first link checks fail because of undefined symbols: __libc_setup_tls.
# In the later check, CMake successfully compiles and links the test program,
# but it also tries to run it, which is wrong when cross-compiling.
#
# The following CMake variable only disables the TRY_RUN call in the -pthread
# test.
LIBRTLSDR_CONF_OPTS += -DTHREADS_PTHREAD_ARG=OFF

$(eval $(cmake-package))
