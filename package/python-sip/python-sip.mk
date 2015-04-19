################################################################################
#
# python-sip
#
################################################################################

PYTHON_SIP_VERSION = 4.16.7
PYTHON_SIP_SOURCE = sip-$(PYTHON_SIP_VERSION).tar.gz
PYTHON_SIP_SITE = http://downloads.sourceforge.net/project/pyqt/sip/sip-$(PYTHON_SIP_VERSION)
PYTHON_SIP_LICENSE = SIP license or GPLv2 or GPLv3
PYTHON_SIP_LICENSE_FILES = LICENSE LICENSE-GPL2 LICENSE-GPL3

PYTHON_SIP_DEPENDENCIES = qt

ifeq ($(BR2_PACKAGE_PYTHON),y)
PYTHON_SIP_DEPENDENCIES += python
HOST_PYTHON_SIP_DEPENDENCIES += host-python
PYTHON_SIP_LIB_DIR = usr/lib/python$(PYTHON_VERSION_MAJOR)/site-packages
PYTHON_SIP_INCLUDE_DIR = usr/include/python$(PYTHON_VERSION_MAJOR)
else ifeq ($(BR2_PACKAGE_PYTHON3),y)
PYTHON_SIP_DEPENDENCIES += python3
HOST_PYTHON_SIP_DEPENDENCIES += host-python3
PYTHON_SIP_LIB_DIR = usr/lib/python$(PYTHON3_VERSION_MAJOR)/site-packages
PYTHON_SIP_INCLUDE_DIR = usr/include/python$(PYTHON3_VERSION_MAJOR)m
endif

define HOST_PYTHON_SIP_CONFIGURE_CMDS
	(cd $(@D); \
		$(HOST_MAKE_ENV) $(HOST_CONFIGURE_OPTS) $(HOST_DIR)/usr/bin/python configure.py)
endef

define HOST_PYTHON_SIP_BUILD_CMDS
	$(HOST_MAKE_ENV) $(HOST_CONFIGURE_OPTS) $(MAKE) -C $(@D)
endef

define HOST_PYTHON_SIP_INSTALL_CMDS
	$(HOST_MAKE_ENV) $(HOST_CONFIGURE_OPTS) $(MAKE) install -C $(@D)
endef

define PYTHON_SIP_CONFIGURE_CMDS
	(cd $(@D); \
		$(TARGET_MAKE_ENV) $(TARGET_CONFIGURE_OPTS) $(HOST_DIR)/usr/bin/python configure.py \
			--bindir $(TARGET_DIR)/usr/bin \
			--destdir $(TARGET_DIR)/$(PYTHON_SIP_LIB_DIR) \
			--incdir $(STAGING_DIR)/$(PYTHON_SIP_INCLUDE_DIR)  \
			--sipdir $(TARGET_DIR)/usr/share/sip \
			--sysroot $(STAGING_DIR)/usr \
			--use-qmake && \
		$(HOST_DIR)/usr/bin/qmake)
endef

define PYTHON_SIP_BUILD_CMDS
	$(TARGET_MAKE_ENV) $(TARGET_CONFIGURE_OPTS) $(MAKE) -C $(@D)
endef

define PYTHON_SIP_INSTALL_TARGET_CMDS
	$(TARGET_MAKE_ENV) $(TARGET_CONFIGURE_OPTS) $(MAKE) install -C $(@D)
endef

$(eval $(generic-package))
$(eval $(host-generic-package))
