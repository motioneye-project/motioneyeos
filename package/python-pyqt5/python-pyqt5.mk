################################################################################
#
# python-pyqt5
#
################################################################################

PYTHON_PYQT5_VERSION = 5.7
PYTHON_PYQT5_SOURCE = PyQt5_gpl-$(PYTHON_PYQT5_VERSION).tar.gz
PYTHON_PYQT5_SITE = http://downloads.sourceforge.net/project/pyqt/PyQt5/PyQt-$(PYTHON_PYQT5_VERSION)
PYTHON_PYQT5_LICENSE = GPL-3.0
PYTHON_PYQT5_LICENSE_FILES = LICENSE

PYTHON_PYQT5_DEPENDENCIES = python-sip host-python-sip qt5base

ifeq ($(BR2_PACKAGE_PYTHON),y)
PYTHON_PYQT5_PYTHON_DIR = python$(PYTHON_VERSION_MAJOR)
PYTHON_PYQT5_RM_PORT_BASE = port_v3
else ifeq ($(BR2_PACKAGE_PYTHON3),y)
PYTHON_PYQT5_PYTHON_DIR = python$(PYTHON3_VERSION_MAJOR)
PYTHON_PYQT5_RM_PORT_BASE = port_v2
endif

PYTHON_PYQT5_QTDETAIL_LICENSE = Open Source

PYTHON_PYQT5_QTDETAIL_TYPE = shared

# Turn off features that aren't available in current qt configuration
PYTHON_PYQT5_QTDETAIL_DISABLE_FEATURES += $(if $(BR2_PACKAGE_OPENSSL),,PyQt_SSL)
PYTHON_PYQT5_QTDETAIL_DISABLE_FEATURES += $(if $(BR2_PACKAGE_QT5BASE_OPENGL),,PyQt_OpenGL)
PYTHON_PYQT5_QTDETAIL_DISABLE_FEATURES += $(if $(BR2_PACKAGE_QT5BASE_OPENGL_DESKTOP),,PyQt_Desktop_OpenGL)

define PYTHON_PYQT5_QTDETAIL
	echo $(1) >> $(2)/qtdetail.out
endef

# Since we can't run generate qtdetail.out by running qtdetail on target device
# we must generate the configuration.
define PYTHON_PYQT5_GENERATE_QTDETAIL
	$(RM) -f $(1)/qtdetail.out
	$(call PYTHON_PYQT5_QTDETAIL,$(PYTHON_PYQT5_QTDETAIL_LICENSE),$(1))
	$(call PYTHON_PYQT5_QTDETAIL,$(PYTHON_PYQT5_QTDETAIL_TYPE),$(1))
	$(foreach f,$(PYTHON_PYQT5_QTDETAIL_DISABLE_FEATURES),
		$(call PYTHON_PYQT5_QTDETAIL,$(f),$(1)) \
	)
endef

PYTHON_PYQT5_CONF_OPTS = \
	--bindir $(TARGET_DIR)/usr/bin \
	--destdir $(TARGET_DIR)/usr/lib/$(PYTHON_PYQT5_PYTHON_DIR)/site-packages \
	--qmake $(HOST_DIR)/usr/bin/qmake \
	--sysroot $(STAGING_DIR)/usr \
	-w --confirm-license \
	--no-designer-plugin \
	--no-docstrings \
	--no-sip-files

define PYTHON_PYQT5_CONFIGURE_CMDS
	$(call PYTHON_PYQT5_GENERATE_QTDETAIL,$(@D))
	(cd $(@D); \
		$(TARGET_MAKE_ENV) \
		$(TARGET_CONFIGURE_OPTS) \
		$(HOST_DIR)/usr/bin/python configure.py \
			$(PYTHON_PYQT5_CONF_OPTS) \
	)
endef

define PYTHON_PYQT5_BUILD_CMDS
	$(TARGET_MAKE_ENV) $(TARGET_CONFIGURE_OPTS) $(MAKE) -C $(@D)
endef

# __init__.py is needed to import PyQt5
# __init__.pyc is needed if BR2_PACKAGE_PYTHON_PYC_ONLY is set
define PYTHON_PYQT5_INSTALL_TARGET_CMDS
	$(TARGET_MAKE_ENV) $(TARGET_CONFIGURE_OPTS) $(MAKE) -C $(@D) install
	touch $(TARGET_DIR)/usr/lib/$(PYTHON_PYQT5_PYTHON_DIR)/site-packages/PyQt5/__init__.py
	$(RM) -rf $(TARGET_DIR)/usr/lib/$(PYTHON_PYQT5_PYTHON_DIR)/site-packages/PyQt5/uic/$(PYTHON_PYQT5_RM_PORT_BASE)
endef

$(eval $(generic-package))
