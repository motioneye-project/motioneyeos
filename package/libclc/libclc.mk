################################################################################
#
# libclc
#
################################################################################

# There are only two releases: release_35 and release_38, but the last
# commit is from 2 years ago. Master has some recent activity.
LIBCLC_VERSION = dabae5a2afb78cba0320a86e3f5f0b5dc83e077c
LIBCLC_SITE = https://git.llvm.org/git/libclc
LIBCLC_SITE_METHOD = git
LIBCLC_LICENSE = NCSA or MIT
LIBCLC_LICENSE_FILES = LICENSE.TXT

LIBCLC_DEPENDENCIES = host-clang host-llvm
LIBCLC_INSTALL_STAGING = YES

# C++ compiler is used to build a small tool (prepare-builtins) for the host.
# It must be built with the C++ compiler from the host.
#
# The headers are installed in /usr/share and not /usr/include,
# because they are needed at runtime on the target to build the OpenCL
# kernels.
LIBCLC_CONF_OPTS = \
	--with-llvm-config=$(HOST_DIR)/usr/bin/llvm-config \
	--prefix=/usr \
	--includedir=/usr/share \
	--pkgconfigdir=/usr/lib/pkgconfig \
	--with-cxx-compiler=$(HOSTCXX)

define LIBCLC_CONFIGURE_CMDS
	(cd $(@D); $(TARGET_CONFIGURE_OPTS) ./configure.py $(LIBCLC_CONF_OPTS))
endef

define LIBCLC_BUILD_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) -C $(@D)
endef

define LIBCLC_INSTALL_TARGET_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) -C $(@D) DESTDIR=$(TARGET_DIR) install
endef

define LIBCLC_INSTALL_STAGING_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) -C $(@D) DESTDIR=$(STAGING_DIR) install
endef

$(eval $(generic-package))
