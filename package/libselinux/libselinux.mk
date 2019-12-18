################################################################################
#
# libselinux
#
################################################################################

LIBSELINUX_VERSION = 2.9
LIBSELINUX_SITE = https://github.com/SELinuxProject/selinux/releases/download/20190315
LIBSELINUX_LICENSE = Public Domain
LIBSELINUX_LICENSE_FILES = LICENSE

LIBSELINUX_DEPENDENCIES = $(BR2_COREUTILS_HOST_DEPENDENCY) libsepol pcre

LIBSELINUX_INSTALL_STAGING = YES

# Set SHLIBDIR to /usr/lib so it has the same value than LIBDIR, as a result
# we won't have to use a relative path in 0002-revert-ln-relative.patch
LIBSELINUX_MAKE_OPTS = \
	$(TARGET_CONFIGURE_OPTS) \
	ARCH=$(KERNEL_ARCH) \
	SHLIBDIR=/usr/lib

LIBSELINUX_MAKE_INSTALL_TARGETS = install

ifeq ($(BR2_TOOLCHAIN_USES_GLIBC),)
LIBSELINUX_DEPENDENCIES += musl-fts
LIBSELINUX_MAKE_OPTS += FTS_LDLIBS=-lfts
endif

ifeq ($(BR2_PACKAGE_PYTHON)$(BR2_PACKAGE_PYTHON3),y)
ifeq ($(BR2_PACKAGE_PYTHON3),y)
LIBSELINUX_DEPENDENCIES += python3 host-swig
LIBSELINUX_PYLIBVER = python$(PYTHON3_VERSION_MAJOR)
else ifeq ($(BR2_PACKAGE_PYTHON),y)
LIBSELINUX_DEPENDENCIES += python host-swig
LIBSELINUX_PYLIBVER = python$(PYTHON_VERSION_MAJOR)
endif

LIBSELINUX_MAKE_OPTS += \
	$(PKG_PYTHON_DISTUTILS_ENV) \
	PYTHON=$(LIBSELINUX_PYLIBVER)

LIBSELINUX_MAKE_INSTALL_TARGETS += install-pywrap

# dependencies are broken and result in file truncation errors at link
# time if the Python bindings are built through the same make
# invocation as the rest of the library.
define LIBSELINUX_BUILD_PYTHON_BINDINGS
	$(TARGET_MAKE_ENV) $(MAKE) -C $(@D) \
		$(LIBSELINUX_MAKE_OPTS) swigify pywrap
endef
endif # python || python3

# Filter out D_FILE_OFFSET_BITS=64. This fixes errors caused by glibc
# 2.22. We set CFLAGS and LDFLAGS here because we want to win over the
# CFLAGS/LDFLAGS definitions passed by $(PKG_PYTHON_DISTUTILS_ENV)
# when the python binding is enabled.
LIBSELINUX_MAKE_OPTS += \
	CFLAGS="$(filter-out -D_FILE_OFFSET_BITS=64,$(TARGET_CFLAGS))" \
	LDFLAGS="$(TARGET_LDFLAGS) -lpcre -lpthread"

define LIBSELINUX_BUILD_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) -C $(@D) \
		$(LIBSELINUX_MAKE_OPTS) all
	$(LIBSELINUX_BUILD_PYTHON_BINDINGS)
endef

define LIBSELINUX_INSTALL_STAGING_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) -C $(@D) \
		$(LIBSELINUX_MAKE_OPTS) DESTDIR=$(STAGING_DIR) \
		$(LIBSELINUX_MAKE_INSTALL_TARGETS)
endef

define LIBSELINUX_INSTALL_TARGET_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) -C $(@D) \
		$(LIBSELINUX_MAKE_OPTS) DESTDIR=$(TARGET_DIR) \
		$(LIBSELINUX_MAKE_INSTALL_TARGETS)
	# Create the selinuxfs mount point
	if [ ! -d "$(TARGET_DIR)/selinux" ]; then mkdir $(TARGET_DIR)/selinux; fi
	if ! grep -q "selinuxfs" $(TARGET_DIR)/etc/fstab; then \
		echo "none /selinux selinuxfs noauto 0 0" >> $(TARGET_DIR)/etc/fstab ; fi
endef

HOST_LIBSELINUX_DEPENDENCIES = \
	host-libsepol host-pcre host-swig

ifeq ($(BR2_PACKAGE_PYTHON3),y)
HOST_LIBSELINUX_DEPENDENCIES += host-python3
HOST_LIBSELINUX_PYLIBVER = python$(PYTHON3_VERSION_MAJOR)
else
HOST_LIBSELINUX_DEPENDENCIES += host-python
HOST_LIBSELINUX_PYLIBVER = python$(PYTHON_VERSION_MAJOR)
endif

HOST_LIBSELINUX_MAKE_OPTS = \
	$(HOST_CONFIGURE_OPTS) \
	PREFIX=$(HOST_DIR) \
	SHLIBDIR=$(HOST_DIR)/lib \
	LDFLAGS="$(HOST_LDFLAGS) -lpcre -lpthread" \
	$(HOST_PKG_PYTHON_DISTUTILS_ENV) \
	PYTHON=$(HOST_LIBSELINUX_PYLIBVER)

define HOST_LIBSELINUX_BUILD_CMDS
	$(HOST_MAKE_ENV) $(MAKE1) -C $(@D) \
		$(HOST_LIBSELINUX_MAKE_OPTS) all
	# Generate python interface wrapper
	$(HOST_MAKE_ENV) $(MAKE1) -C $(@D) \
		$(HOST_LIBSELINUX_MAKE_OPTS) swigify pywrap
endef

define HOST_LIBSELINUX_INSTALL_CMDS
	$(HOST_MAKE_ENV) $(MAKE) -C $(@D) \
		$(HOST_LIBSELINUX_MAKE_OPTS) install
	# Install python interface wrapper
	$(HOST_MAKE_ENV) $(MAKE) -C $(@D) \
		$(HOST_LIBSELINUX_MAKE_OPTS) install-pywrap
endef

$(eval $(generic-package))
$(eval $(host-generic-package))
