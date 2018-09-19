################################################################################
#
# e2fsprogs
#
################################################################################

E2FSPROGS_VERSION = 1.44.4
E2FSPROGS_SOURCE = e2fsprogs-$(E2FSPROGS_VERSION).tar.xz
E2FSPROGS_SITE = $(BR2_KERNEL_MIRROR)/linux/kernel/people/tytso/e2fsprogs/v$(E2FSPROGS_VERSION)
E2FSPROGS_LICENSE = GPL-2.0, MIT-like with advertising clause (libss and libet)
E2FSPROGS_LICENSE_FILES = NOTICE lib/ss/mit-sipb-copyright.h lib/et/internal.h
E2FSPROGS_INSTALL_STAGING = YES

# Use libblkid and libuuid from util-linux for host and target packages.
# This prevents overriding them with e2fsprogs' ones, which may cause
# problems for other packages.
E2FSPROGS_DEPENDENCIES = host-pkgconf util-linux
HOST_E2FSPROGS_DEPENDENCIES = host-pkgconf host-util-linux

# e4defrag doesn't build on older systems like RHEL5.x, and we don't
# need it on the host anyway.
# Disable fuse2fs as well to avoid carrying over deps, and it's unused
HOST_E2FSPROGS_CONF_OPTS = \
	--disable-defrag \
	--disable-e2initrd-helper \
	--disable-fuse2fs \
	--disable-libblkid \
	--disable-libuuid \
	--disable-testio-debug \
	--enable-symlink-install \
	--enable-elf-shlibs

# Set the binary directories to "/bin" and "/sbin", as busybox does,
# so that we do not end up with two versions of e2fs tools.
E2FSPROGS_CONF_OPTS = \
	--bindir=/bin \
	--sbindir=/sbin \
	$(if $(BR2_STATIC_LIBS),--disable-elf-shlibs,--enable-elf-shlibs) \
	$(if $(BR2_PACKAGE_E2FSPROGS_DEBUGFS),--enable-debugfs,--disable-debugfs) \
	$(if $(BR2_PACKAGE_E2FSPROGS_E2IMAGE),--enable-imager,--disable-imager) \
	$(if $(BR2_PACKAGE_E2FSPROGS_E4DEFRAG),--enable-defrag,--disable-defrag) \
	$(if $(BR2_PACKAGE_E2FSPROGS_FSCK),--enable-fsck,--disable-fsck) \
	$(if $(BR2_PACKAGE_E2FSPROGS_RESIZE2FS),--enable-resizer,--disable-resizer) \
	--disable-uuidd \
	--disable-libblkid \
	--disable-libuuid \
	--disable-e2initrd-helper \
	--disable-testio-debug \
	--disable-rpath \
	--enable-symlink-install

ifeq ($(BR2_PACKAGE_E2FSPROGS_FUSE2FS),y)
E2FSPROGS_CONF_OPTS += --enable-fuse2fs
E2FSPROGS_DEPENDENCIES += libfuse
else
E2FSPROGS_CONF_OPTS += --disable-fuse2fs
endif

ifeq ($(BR2_nios2),y)
E2FSPROGS_CONF_ENV += ac_cv_func_fallocate=no
endif

# Some programs are built for the host, but use definitions guessed by
# the configure script (i.e with the cross-compiler). Help them by
# saying that <sys/stat.h> is available on the host, which is needed
# for util/subst.c to build properly.
E2FSPROGS_CONF_ENV += \
	BUILD_CFLAGS="-DHAVE_SYS_STAT_H" \
	ac_cv_path_LDCONFIG=true

# Disable use of the host magic.h, as on older hosts (e.g. RHEL 5)
# it doesn't provide definitions expected by e2fsprogs support lib.
HOST_E2FSPROGS_CONF_ENV += \
	ac_cv_header_magic_h=no \
	ac_cv_lib_magic_magic_file=no \
	ac_cv_path_LDCONFIG=true

E2FSPROGS_INSTALL_STAGING_OPTS = \
	DESTDIR=$(STAGING_DIR) \
	install-libs

# Package does not build in parallel due to improper make rules
define HOST_E2FSPROGS_INSTALL_CMDS
	$(HOST_MAKE_ENV) $(MAKE1) -C $(@D) install install-libs
endef

$(eval $(autotools-package))
$(eval $(host-autotools-package))
