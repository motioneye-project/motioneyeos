################################################################################
#
# python-pyqt
#
################################################################################

PYTHON_PYQT_VERSION = 4.11.3
PYTHON_PYQT_SOURCE = PyQt-x11-gpl-$(PYTHON_PYQT_VERSION).tar.gz
PYTHON_PYQT_SITE = http://downloads.sourceforge.net/project/pyqt/PyQt4/PyQt-$(PYTHON_PYQT_VERSION)
PYTHON_PYQT_LICENSE = GPLv2 or GPLv3
PYTHON_PYQT_LICENSE_FILES = LICENSE.GPL2 LICENSE.GPL3

PYTHON_PYQT_DEPENDENCIES = python-sip host-python-sip qt

ifeq ($(BR2_PACKAGE_PYTHON),y)
PYTHON_PYQT_PYTHON_DIR = python$(PYTHON_VERSION_MAJOR)
PYTHON_PYQT_RM_PORT_BASE = port_v3
else ifeq ($(BR2_PACKAGE_PYTHON3),y)
PYTHON_PYQT_PYTHON_DIR = python$(PYTHON3_VERSION_MAJOR)
PYTHON_PYQT_RM_PORT_BASE = port_v2
endif

ifeq ($(BR2_PACKAGE_QT_EMBEDDED),y)
PYTHON_PYQT_QTFLAVOR = WS_QWS
else
PYTHON_PYQT_QTFLAVOR = WS_X11
endif

PYTHON_PYQT_QTDETAIL_LICENSE = Open Source

ifeq ($(BR2_PACKAGE_QT_SHARED),y)
PYTHON_PYQT_QTDETAIL_TYPE = shared
endif

# Turn off features that aren't available in QWS and current qt
# configuration.
PYTHON_PYQT_QTDETAIL_DISABLE_FEATURES = \
	PyQt_Accessibility PyQt_SessionManager \
	PyQt_Shortcut PyQt_RawFont

ifeq ($(BR2_PACKAGE_QT_OPENSSL),)
PYTHON_PYQT_QTDETAIL_DISABLE_FEATURES += PyQt_OpenSSL
endif

# Yes, this looks a bit weird: when OpenGL ES is available, we have to
# disable the feature that consists in not having OpenGL ES support.
ifeq ($(BR2_PACKAGE_QT_OPENGL_ES),y)
PYTHON_PYQT_QTDETAIL_DISABLE_FEATURES += PyQt_NoOpenGLES
endif

# PyQt_qreal_double must be disabled on a number of architectures that
# use float for qreal.
ifeq ($(BR2_PACKAGE_PYTHON_PYQT_ARCH_USES_QREAL_FLOAT),y)
PYTHON_PYQT_QTDETAIL_DISABLE_FEATURES += PyQt_qreal_double
endif

define PYTHON_PYQT_QTDETAIL
	echo $(1) >> $(2)/qtdetail.out
endef

# Since we can't run generate qtdetail.out by running qtdetail on target device
# we must generate the configuration.
define PYTHON_PYQT_GENERATE_QTDETAIL
	$(RM) -f $(1)/qtdetail.out
	$(call PYTHON_PYQT_QTDETAIL,$(PYTHON_PYQT_QTDETAIL_LICENSE),$(1))
	$(call PYTHON_PYQT_QTDETAIL,$(PYTHON_PYQT_QTDETAIL_TYPE),$(1))
	$(foreach f,$(PYTHON_PYQT_QTDETAIL_DISABLE_FEATURES),
		$(call PYTHON_PYQT_QTDETAIL,$(f),$(1)) \
	)
endef

PYTHON_PYQT_CONF_OPTS = \
	--bindir $(TARGET_DIR)/usr/bin \
	--destdir $(TARGET_DIR)/usr/lib/$(PYTHON_PYQT_PYTHON_DIR)/site-packages \
	--qmake $(HOST_DIR)/usr/bin/qmake \
	--sysroot $(STAGING_DIR)/usr \
	-w --confirm-license \
	--no-designer-plugin \
	--no-docstrings \
	--no-sip-files \
	--qt-flavor=$(PYTHON_PYQT_QTFLAVOR)

# The VendorID related information is only needed for Python 2.x, not
# Python 3.x.
ifeq ($(BR2_PACKAGE_PYTHON),y)
PYTHON_PYQT_CONF_OPTS += \
	--vendorid-incdir $(STAGING_DIR)/usr/include/$(PYTHON_PYQT_PYTHON_DIR)  \
	--vendorid-libdir $(STAGING_DIR)/usr/lib/$(PYTHON_PYQT_PYTHON_DIR)/config
endif

define PYTHON_PYQT_CONFIGURE_CMDS
	$(call PYTHON_PYQT_GENERATE_QTDETAIL,$(@D))
	(cd $(@D); \
		$(TARGET_MAKE_ENV) \
		$(TARGET_CONFIGURE_OPTS) \
		$(HOST_DIR)/usr/bin/python configure-ng.py \
			$(PYTHON_PYQT_CONF_OPTS) \
	)
endef

define PYTHON_PYQT_BUILD_CMDS
	$(TARGET_MAKE_ENV) $(TARGET_CONFIGURE_OPTS) $(MAKE) -C $(@D)
endef

# __init__.py is needed to import PyQt4
# __init__.pyc is needed if BR2_PACKAGE_PYTHON_PYC_ONLY is set
define PYTHON_PYQT_INSTALL_TARGET_CMDS
	$(TARGET_MAKE_ENV) $(TARGET_CONFIGURE_OPTS) $(MAKE) -C $(@D) install
	touch $(TARGET_DIR)/usr/lib/$(PYTHON_PYQT_PYTHON_DIR)/site-packages/PyQt4/__init__.py
	$(RM) -rf $(TARGET_DIR)/usr/lib/$(PYTHON_PYQT_PYTHON_DIR)/site-packages/PyQt4/uic/$(PYTHON_PYQT_RM_PORT_BASE)
	PYTHONPATH="$(PYTHON_PATH)" \
		$(HOST_DIR)/usr/bin/python -c "import compileall; \
		compileall.compile_dir('$(TARGET_DIR)/usr/lib/$(PYTHON_PYQT_PYTHON_DIR)/site-packages/PyQt4')"
endef

$(eval $(generic-package))
