################################################################################
#
# qwt
#
################################################################################

QWT_VERSION = 6.1.3
QWT_SOURCE = qwt-$(QWT_VERSION).tar.bz2
QWT_SITE = http://downloads.sourceforge.net/project/qwt/qwt/$(QWT_VERSION)
QWT_INSTALL_STAGING = YES
ifeq ($(BR2_PACKAGE_QT),y)
QWT_DEPENDENCIES = qt
QWT_QMAKE = $(QT_QMAKE)
else ifeq ($(BR2_PACKAGE_QT5),y)
QWT_DEPENDENCIES += qt5base
QWT_QMAKE = $(QT5_QMAKE)
endif

QWT_LICENSE = LGPLv2.1 with exceptions
QWT_LICENSE_FILES = COPYING

QWT_CONFIG = 's%QWT_INSTALL_PREFIX.*/usr/local/.*%QWT_INSTALL_PREFIX = /usr%'
QWT_CONFIG += -e 's/^.*QWT_CONFIG.*QwtDesigner.*$$/\# QWT_CONFIG += QwtDesigner/'
QWT_CONFIG += -e 's%/features%/mkspecs/features%'

ifeq ($(BR2_PACKAGE_QWT_SVG),y)
QWT_CONFIG += -e 's/^.*QWT_CONFIG.*QwtSvg.*$$/QWT_CONFIG += QwtSvg/'
else
QWT_CONFIG += -e 's/^.*QWT_CONFIG.*QwtSvg.*$$/\# QWT_CONFIG += QwtSvg/'
endif

ifeq ($(BR2_PACKAGE_QWT_MATHML),y)
QWT_CONFIG += -e 's/^.*QWT_CONFIG.*QwtMathML.*$$/QWT_CONFIG += QwtMathML/'
else
QWT_CONFIG += -e 's/^.*QWT_CONFIG.*QwtMathML.*$$/\# QWT_CONFIG += QwtMathML/'
endif

ifeq ($(BR2_PACKAGE_QWT_OPENGL),y)
QWT_CONFIG += -e 's/^.*QWT_CONFIG.*QwtOpenGL.*$$/QWT_CONFIG += QwtOpenGL/'
else
QWT_CONFIG += -e 's/^.*QWT_CONFIG.*QwtOpenGL.*$$/\# QWT_CONFIG += QwtOpenGL/'
endif

define QWT_CONFIGURE_CMDS
	$(SED) $(QWT_CONFIG) $(@D)/qwtconfig.pri
	(cd $(@D); $(TARGET_MAKE_ENV) $(QWT_QMAKE))
endef

define QWT_BUILD_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) -C $(@D)
endef

# After installation, we fixup the INSTALL_PREFIX in qwtconfig.pri so
# that when building with qmake, -L$(STAGING_DIR)/usr/lib is used and
# not -L/usr/lib.
define QWT_INSTALL_STAGING_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) -C $(@D) install INSTALL_ROOT=$(STAGING_DIR)
	$(SED) "s%QWT_INSTALL_PREFIX = .*%QWT_INSTALL_PREFIX = $(STAGING_DIR)/usr%" \
		$(STAGING_DIR)/usr/mkspecs/features/qwtconfig.pri
endef

define QWT_INSTALL_TARGET_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) -C $(@D) install INSTALL_ROOT=$(TARGET_DIR)
	rm -Rf $(TARGET_DIR)/usr/mkspecs
endef

$(eval $(generic-package))
