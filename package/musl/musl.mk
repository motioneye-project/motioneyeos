################################################################################
#
# musl
#
################################################################################

MUSL_VERSION = 1.1.4
MUSL_SITE = http://www.musl-libc.org/releases
MUSL_LICENSE = MIT
MUSL_LICENSE_FILES = COPYRIGHT

# Before musl is configured, we must have the first stage
# cross-compiler and the kernel headers
MUSL_DEPENDENCIES = host-gcc-initial linux-headers

# musl is part of the toolchain so disable the toolchain dependency
MUSL_ADD_TOOLCHAIN_DEPENDENCY = NO

MUSL_INSTALL_STAGING = YES

# We need to run the musl configure script prior to building the
# gcc-intermediate, so that we can call the install-headers step and
# get the crt<X>.o built. However, we need to call it again after
# gcc-intermediate has been built, otherwise the configure script
# doesn't realize that libgcc has been built, and doesn't link the C
# library properly with libgcc, which causes build failure down the
# road. We will have the opportunity to simplify this once we switch
# to a 2-steps gcc build.
define MUSL_CONFIGURE_CALL
	(cd $(@D); \
		$(TARGET_CONFIGURE_OPTS) \
		CFLAGS="$(filter-out -D_LARGEFILE_SOURCE -D_LARGEFILE64_SOURCE -D_FILE_OFFSET_BITS=64,$(TARGET_CFLAGS)) $(MUSL_EXTRA_CFLAGS)" \
		CPPFLAGS="$(filter-out -D_LARGEFILE_SOURCE -D_LARGEFILE64_SOURCE -D_FILE_OFFSET_BITS=64,$(TARGET_CPPFLAGS))" \
		./configure \
			--target=$(GNU_TARGET_NAME) \
			--host=$(GNU_TARGET_NAME) \
			--prefix=/usr \
			--disable-gcc-wrapper)
endef

define MUSL_CONFIGURE_CMDS
	$(MUSL_CONFIGURE_CALL)
	$(TARGET_MAKE_ENV) $(MAKE) -C $(@D) \
		DESTDIR=$(STAGING_DIR) install-headers
	$(TARGET_MAKE_ENV) $(MAKE) -C $(@D) \
		crt/crt1.o crt/crti.o crt/crtn.o
	cp $(@D)/crt/crt*.o $(STAGING_DIR)/usr/lib
	$(TARGET_CROSS)gcc -nostdlib \
		-nostartfiles -shared -x c /dev/null -o $(STAGING_DIR)/usr/lib/libc.so
endef

define MUSL_BUILD_CMDS
	$(MUSL_CONFIGURE_CALL)
	$(TARGET_MAKE_ENV) $(MAKE) -C $(@D)
endef

define MUSL_INSTALL_STAGING_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) -C $(@D) \
		DESTDIR=$(STAGING_DIR) install-libs install-tools
endef

# prefix is set to an empty value to get the C library installed in
# /lib and not /usr/lib
define MUSL_INSTALL_TARGET_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) -C $(@D) \
		DESTDIR=$(TARGET_DIR) prefix= install-libs
	$(RM) $(addprefix $(TARGET_DIR)/lib/,crt1.o crtn.o crti.o Scrt1.o)
endef

$(eval $(generic-package))

# Before musl is built, we must have the second stage cross-compiler
$(MUSL_TARGET_BUILD): | host-gcc-intermediate
