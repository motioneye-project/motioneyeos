################################################################################
#
# libsemanage
#
################################################################################

LIBSEMANAGE_VERSION = 2.5
LIBSEMANAGE_SITE = https://raw.githubusercontent.com/wiki/SELinuxProject/selinux/files/releases/20160223
LIBSEMANAGE_LICENSE = LGPLv2.1+
LIBSEMANAGE_LICENSE_FILES = COPYING
LIBSEMANAGE_DEPENDENCIES = host-bison host-flex audit libselinux ustr bzip2
LIBSEMANAGE_INSTALL_STAGING = YES

LIBSEMANAGE_MAKE_OPTS = $(TARGET_CONFIGURE_OPTS)

define LIBSEMANAGE_BUILD_CMDS
	# DESTDIR is needed during the compile to compute library and
	# header paths.
	$(MAKE) -C $(@D) $(LIBSEMANAGE_MAKE_OPTS) DESTDIR=$(STAGING_DIR) all
endef

define LIBSEMANAGE_INSTALL_STAGING_CMDS
	$(MAKE) -C $(@D) $(LIBSEMANAGE_MAKE_OPTS) DESTDIR=$(STAGING_DIR) install
endef

define LIBSEMANAGE_INSTALL_TARGET_CMDS
	$(MAKE) -C $(@D) $(LIBSEMANAGE_MAKE_OPTS) DESTDIR=$(TARGET_DIR) install
endef

HOST_LIBSEMANAGE_DEPENDENCIES = host-bison host-audit host-libsepol host-libselinux \
				host-ustr host-bzip2 host-swig
HOST_LIBSEMANAGE_MAKE_OPTS += $(HOST_CONFIGURE_OPTS) \
	SWIG_LIB="$(HOST_DIR)/usr/share/swig/$(SWIG_VERSION)/"

ifeq ($(BR2_PACKAGE_PYTHON3),y)
HOST_LIBSEMANAGE_DEPENDENCIES += host-python3
HOST_LIBSEMANAGE_MAKE_OPTS += \
	PYINC="-I$(HOST_DIR)/usr/include/python$(PYTHON3_VERSION_MAJOR)m/" \
	PYTHONLIBDIR="-L$(HOST_DIR)/usr/lib/python$(PYTHON3_VERSION_MAJOR)/" \
	PYLIBVER="python$(PYTHON3_VERSION_MAJOR)"
else
HOST_LIBSEMANAGE_DEPENDENCIES += host-python
HOST_LIBSEMANAGE_MAKE_OPTS += \
	PYINC="-I$(HOST_DIR)/usr/include/python$(PYTHON_VERSION_MAJOR)/" \
	PYTHONLIBDIR="-L$(HOST_DIR)/usr/lib/python$(PYTHON_VERSION_MAJOR)/" \
	PYLIBVER="python$(PYTHON_VERSION_MAJOR)"
endif

define HOST_LIBSEMANAGE_BUILD_CMDS
	# DESTDIR is needed during the compile to compute library and
	# header paths.
	$(MAKE) -C $(@D) $(HOST_CONFIGURE_OPTS) DESTDIR=$(HOST_DIR) all
	$(MAKE) -C $(@D) $(HOST_LIBSEMANAGE_MAKE_OPTS) DESTDIR=$(HOST_DIR) swigify pywrap
endef

define HOST_LIBSEMANAGE_INSTALL_CMDS
	$(MAKE) -C $(@D) $(HOST_CONFIGURE_OPTS) DESTDIR=$(HOST_DIR) install
	$(MAKE) -C $(@D) $(HOST_LIBSEMANAGE_MAKE_OPTS) DESTDIR=$(HOST_DIR) install-pywrap
endef

$(eval $(generic-package))
$(eval $(host-generic-package))
