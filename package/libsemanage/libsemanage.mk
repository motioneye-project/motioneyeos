################################################################################
#
# libsemanage
#
################################################################################

LIBSEMANAGE_VERSION = 2.1.10
LIBSEMANAGE_SITE = https://raw.githubusercontent.com/wiki/SELinuxProject/selinux/files/releases/20130423
LIBSEPOL_LICENSE = LGPLv2.1+
LIBSEPOL_LICENSE_FILES = COPYING

LIBSEMANAGE_DEPENDENCIES = host-bison host-flex libselinux ustr bzip2

LIBSEMANAGE_INSTALL_STAGING = YES

LIBSEMANAGE_MAKE_OPTS = $(TARGET_CONFIGURE_OPTS)

ifeq ($(BR2_PACKAGE_LIBSEMANAGE_PYTHON_BINDINGS),y)

LIBSEMANAGE_DEPENDENCIES += python host-swig
LIBSEMANAGE_MAKE_OPTS += \
	PYINC="-I$(STAGING_DIR)/usr/include/python$(PYTHON_VERSION_MAJOR)/" \
	PYTHONLIBDIR="-L$(STAGING_DIR)/usr/lib/python$(PYTHON_VERSION_MAJOR)/" \
	PYLIBVER="python$(PYTHON_VERSION_MAJOR)" \
	SWIG_LIB="$(HOST_DIR)/usr/share/swig/$(SWIG_VERSION)/"

define LIBSEMANAGE_PYTHON_BUILD_CMDS
	$(MAKE) -C $(@D) $(LIBSEMANAGE_MAKE_OPTS) DESTDIR=$(STAGING_DIR) swigify pywrap
endef

define LIBSEMANAGE_PYTHON_INSTALL_STAGING_CMDS
	$(MAKE) -C $(@D) $(LIBSEMANAGE_MAKE_OPTS) DESTDIR=$(STAGING_DIR) install-pywrap
endef

define LIBSEMANAGE_PYTHON_INSTALL_TARGET_CMDS
	$(MAKE) -C $(@D) $(LIBSEMANAGE_MAKE_OPTS) DESTDIR=$(TARGET_DIR) install-pywrap
endef

endif # End of BR2_PACKAGE_PYTHON

define LIBSEMANAGE_BUILD_CMDS
	# DESTDIR is needed during the compile to compute library and
	# header paths.
	$(MAKE) -C $(@D) $(LIBSEMANAGE_MAKE_OPTS) DESTDIR=$(STAGING_DIR) all
	$(LIBSEMANAGE_PYTHON_BUILD_CMDS)
endef

define LIBSEMANAGE_INSTALL_STAGING_CMDS
	$(MAKE) -C $(@D) $(LIBSEMANAGE_MAKE_OPTS) DESTDIR=$(STAGING_DIR) install
	$(LIBSEMANAGE_PYTHON_INSTALL_STAGING_CMDS)
endef

define LIBSEMANAGE_INSTALL_TARGET_CMDS
	$(MAKE) -C $(@D) $(LIBSEMANAGE_MAKE_OPTS) DESTDIR=$(TARGET_DIR) install
	$(LIBSEMANAGE_PYTHON_INSTALL_TARGET_CMDS)
endef

HOST_LIBSEMANAGE_DEPENDENCIES = host-bison host-libsepol \
	host-libselinux host-ustr host-bzip2

define HOST_LIBSEMANAGE_BUILD_CMDS
	# DESTDIR is needed during the compile to compute library and
	# header paths.
	$(MAKE) -C $(@D) $(HOST_CONFIGURE_OPTS) DESTDIR=$(HOST_DIR) all
endef

define HOST_LIBSEMANAGE_INSTALL_CMDS
	$(MAKE) -C $(@D) $(HOST_CONFIGURE_OPTS) DESTDIR=$(HOST_DIR) install
endef

$(eval $(generic-package))
$(eval $(host-generic-package))
