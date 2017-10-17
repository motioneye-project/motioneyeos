################################################################################
#
# libselinux
#
################################################################################

LIBSELINUX_VERSION = 2.7
LIBSELINUX_SITE = https://raw.githubusercontent.com/wiki/SELinuxProject/selinux/files/releases/20170804
LIBSELINUX_LICENSE = Public Domain
LIBSELINUX_LICENSE_FILES = LICENSE

LIBSELINUX_DEPENDENCIES = libsepol pcre

LIBSELINUX_INSTALL_STAGING = YES

# Filter out D_FILE_OFFSET_BITS=64. This fixes errors caused by glibc 2.22.
LIBSELINUX_MAKE_OPTS = \
	$(TARGET_CONFIGURE_OPTS) \
	CFLAGS="$(filter-out -D_FILE_OFFSET_BITS=64,$(TARGET_CFLAGS))" \
	LDFLAGS="$(TARGET_LDFLAGS) -lpcre -lpthread" \
	ARCH=$(KERNEL_ARCH)

LIBSELINUX_MAKE_INSTALL_TARGETS = install

ifeq ($(BR2_PACKAGE_PYTHON)$(BR2_PACKAGE_PYTHON3),y)
ifeq ($(BR2_PACKAGE_PYTHON3),y)
LIBSELINUX_DEPENDENCIES += python3 host-swig
LIBSELINUX_PYINC = -I$(STAGING_DIR)/usr/include/python$(PYTHON3_VERSION_MAJOR)m
LIBSELINUX_PYLIBVER = python$(PYTHON3_VERSION_MAJOR)
else ifeq ($(BR2_PACKAGE_PYTHON),y)
LIBSELINUX_DEPENDENCIES += python host-swig
LIBSELINUX_PYINC = -I$(STAGING_DIR)/usr/include/python$(PYTHON_VERSION_MAJOR)
LIBSELINUX_PYLIBVER = python$(PYTHON_VERSION_MAJOR)
endif

LIBSELINUX_MAKE_OPTS += \
	PYINC="$(LIBSELINUX_PYINC)" \
	PYSITEDIR=$(TARGET_DIR)/usr/lib/$(LIBSELINUX_PYLIBVER)/site-packages \
	SWIG_LIB="$(HOST_DIR)/share/swig/$(SWIG_VERSION)/"

LIBSELINUX_MAKE_INSTALL_TARGETS += install-pywrap

# dependencies are broken and result in file truncation errors at link
# time if the Python bindings are built through the same make
# invocation as the rest of the library.
define LIBSELINUX_BUILD_PYTHON_BINDINGS
	$(TARGET_MAKE_ENV) $(MAKE) -C $(@D) \
		$(LIBSELINUX_MAKE_OPTS) DESTDIR=$(STAGING_DIR) swigify pywrap
endef
endif # python || python3

define LIBSELINUX_BUILD_CMDS
	# DESTDIR is needed during the compile to compute library and
	# header paths.
	$(TARGET_MAKE_ENV) $(MAKE) -C $(@D) \
		$(LIBSELINUX_MAKE_OPTS) DESTDIR=$(STAGING_DIR) all
	$(LIBSELINUX_BUILD_PYTHON_BINDINGS)
endef

define LIBSELINUX_INSTALL_STAGING_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) -C $(@D) \
		$(LIBSELINUX_MAKE_OPTS) DESTDIR=$(STAGING_DIR) \
		$(LIBSELINUX_MAKE_INSTALL_TARGETS)
endef

define LIBSELINUX_INSTALL_TARGET_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) -C $(@D) \
		$(LIBSELINUX_MAKE_OPTS) DESTDIR=$(TARGET_DIR) install
	# Create the selinuxfs mount point
	if [ ! -d "$(TARGET_DIR)/selinux" ]; then mkdir $(TARGET_DIR)/selinux; fi
	if ! grep -q "selinuxfs" $(TARGET_DIR)/etc/fstab; then \
		echo "none /selinux selinuxfs noauto 0 0" >> $(TARGET_DIR)/etc/fstab ; fi
endef

HOST_LIBSELINUX_DEPENDENCIES = \
	host-libsepol host-pcre host-swig

ifeq ($(BR2_PACKAGE_PYTHON3),y)
HOST_LIBSELINUX_DEPENDENCIES += host-python3
HOST_LIBSELINUX_PYINC = -I$(HOST_DIR)/include/python$(PYTHON3_VERSION_MAJOR)m/
HOST_LIBSELINUX_PYLIBVER = python$(PYTHON3_VERSION_MAJOR)
else
HOST_LIBSELINUX_DEPENDENCIES += host-python
HOST_LIBSELINUX_PYINC = -I$(HOST_DIR)/include/python$(PYTHON_VERSION_MAJOR)/
HOST_LIBSELINUX_PYLIBVER = python$(PYTHON_VERSION_MAJOR)
endif

# DESTDIR is needed during the compile to compute library and header paths.
HOST_LIBSELINUX_MAKE_OPTS = \
	$(HOST_CONFIGURE_OPTS) \
	DESTDIR=$(HOST_DIR) \
	PREFIX=$(HOST_DIR) \
	LDFLAGS="$(HOST_LDFLAGS) -lpcre -lpthread" \
	PYINC="$(HOST_LIBSELINUX_PYINC)" \
	PYSITEDIR="$(HOST_DIR)/lib/$(HOST_LIBSELINUX_PYLIBVER)/site-packages" \
	SWIG_LIB="$(HOST_DIR)/share/swig/$(SWIG_VERSION)/"

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
	ln -sf libselinux.so.1 $(HOST_DIR)/lib/libselinux.so
	# Install python interface wrapper
	$(HOST_MAKE_ENV) $(MAKE) -C $(@D) \
		$(HOST_LIBSELINUX_MAKE_OPTS) install-pywrap
endef

$(eval $(generic-package))
$(eval $(host-generic-package))
