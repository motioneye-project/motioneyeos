################################################################################
#
# libsemanage
#
################################################################################

LIBSEMANAGE_VERSION = 2.6
LIBSEMANAGE_SITE = https://raw.githubusercontent.com/wiki/SELinuxProject/selinux/files/releases/20161014
LIBSEMANAGE_LICENSE = LGPL-2.1+
LIBSEMANAGE_LICENSE_FILES = COPYING
LIBSEMANAGE_DEPENDENCIES = host-bison host-flex audit libselinux ustr bzip2
LIBSEMANAGE_INSTALL_STAGING = YES

LIBSEMANAGE_MAKE_OPTS = $(TARGET_CONFIGURE_OPTS)

define LIBSEMANAGE_BUILD_CMDS
	# DESTDIR is needed during the compile to compute library and
	# header paths.
	$(TARGET_MAKE_ENV) $(MAKE) -C $(@D) $(LIBSEMANAGE_MAKE_OPTS) DESTDIR=$(STAGING_DIR) all
endef

define LIBSEMANAGE_INSTALL_STAGING_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) -C $(@D) $(LIBSEMANAGE_MAKE_OPTS) DESTDIR=$(STAGING_DIR) install
endef

define LIBSEMANAGE_INSTALL_TARGET_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) -C $(@D) $(LIBSEMANAGE_MAKE_OPTS) DESTDIR=$(TARGET_DIR) install
endef

HOST_LIBSEMANAGE_DEPENDENCIES = host-bison host-audit host-libsepol host-libselinux \
				host-ustr host-bzip2 host-swig

# DESTDIR is needed during the compile to compute library and header paths.
HOST_LIBSEMANAGE_MAKE_OPTS += \
	$(HOST_CONFIGURE_OPTS) \
	DESTDIR=$(HOST_DIR) \
	PREFIX=$(HOST_DIR) \
	SWIG_LIB="$(HOST_DIR)/share/swig/$(SWIG_VERSION)/"

ifeq ($(BR2_PACKAGE_PYTHON3),y)
HOST_LIBSEMANAGE_DEPENDENCIES += host-python3
HOST_LIBSEMANAGE_MAKE_OPTS += \
	PYINC="-I$(HOST_DIR)/include/python$(PYTHON3_VERSION_MAJOR)m/" \
	PYTHONLIBDIR="-L$(HOST_DIR)/lib/python$(PYTHON3_VERSION_MAJOR)/" \
	PYLIBVER="python$(PYTHON3_VERSION_MAJOR)"
else
HOST_LIBSEMANAGE_DEPENDENCIES += host-python
HOST_LIBSEMANAGE_MAKE_OPTS += \
	PYINC="-I$(HOST_DIR)/include/python$(PYTHON_VERSION_MAJOR)/" \
	PYTHONLIBDIR="-L$(HOST_DIR)/lib/python$(PYTHON_VERSION_MAJOR)/" \
	PYLIBVER="python$(PYTHON_VERSION_MAJOR)"
endif

define HOST_LIBSEMANAGE_BUILD_CMDS
	$(HOST_MAKE_ENV) $(MAKE) -C $(@D) $(HOST_LIBSEMANAGE_MAKE_OPTS) all
	$(HOST_MAKE_ENV) $(MAKE) -C $(@D) $(HOST_LIBSEMANAGE_MAKE_OPTS) swigify pywrap
endef

define HOST_LIBSEMANAGE_INSTALL_CMDS
	$(HOST_MAKE_ENV) $(MAKE) -C $(@D) $(HOST_LIBSEMANAGE_MAKE_OPTS) install
	$(HOST_MAKE_ENV) $(MAKE) -C $(@D) $(HOST_LIBSEMANAGE_MAKE_OPTS) install-pywrap
endef

$(eval $(generic-package))
$(eval $(host-generic-package))
