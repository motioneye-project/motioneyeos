################################################################################
#
# selinux-python
#
################################################################################

SELINUX_PYTHON_VERSION = 2.9
SELINUX_PYTHON_SITE = https://github.com/SELinuxProject/selinux/releases/download/20190315
SELINUX_PYTHON_LICENSE = GPL-2.0
SELINUX_PYTHON_LICENSE_FILES = COPYING

SELINUX_PYTHON_MAKE_OPTS += \
	$(TARGET_CONFIGURE_OPTS) \
	ARCH="$(BR2_ARCH)" \
	LIBDIR="$(STAGING_DIR)/usr/lib"

ifeq ($(BR2_PACKAGE_PYTHON3),y)
SELINUX_PYTHON_DEPENDENCIES += python3
SELINUX_PYTHON_MAKE_OPTS += \
	PYTHONLIBDIR="usr/lib/python$(PYTHON3_VERSION_MAJOR)"
else
SELINUX_PYTHON_DEPENDENCIES += python
SELINUX_PYTHON_MAKE_OPTS += \
	PYTHONLIBDIR="usr/lib/python$(PYTHON_VERSION_MAJOR)"
endif

ifeq ($(BR2_PACKAGE_SELINUX_PYTHON_AUDIT2ALLOW),y)
SELINUX_PYTHON_DEPENDENCIES += checkpolicy
SELINUX_PYTHON_MAKE_DIRS += audit2allow
endif

ifeq ($(BR2_PACKAGE_SELINUX_PYTHON_SEPOLGEN),y)
SELINUX_PYTHON_MAKE_DIRS += sepolgen/src/sepolgen
endif

define SELINUX_PYTHON_BUILD_CMDS
	$(foreach d,$(SELINUX_PYTHON_MAKE_DIRS),
		$(MAKE) -C $(@D)/$(d) $(SELINUX_PYTHON_MAKE_OPTS) \
			all
	)
endef

define SELINUX_PYTHON_INSTALL_TARGET_CMDS
	$(foreach d,$(SELINUX_PYTHON_MAKE_DIRS),
		$(MAKE) -C $(@D)/$(d) $(SELINUX_PYTHON_MAKE_OPTS) \
			DESTDIR=$(TARGET_DIR) install
	)
endef

$(eval $(generic-package))
