################################################################################
#
# qwt
#
################################################################################

QWT_VERSION = 6.0.2
QWT_SOURCE = qwt-$(QWT_VERSION).tar.bz2
QWT_SITE = http://downloads.sourceforge.net/project/qwt/qwt/$(QWT_VERSION)
QWT_INSTALL_STAGING = YES
QWT_DEPENDENCIES = qt

QWT_CONFIG  =    's%QWT_INSTALL_PREFIX.*/usr/local/.*%QWT_INSTALL_PREFIX = /usr%'
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

define QWT_CONFIGURE_CMDS
	$(SED) $(QWT_CONFIG) $(@D)/qwtconfig.pri
	(cd $(@D); $(QT_QMAKE))
endef

define QWT_BUILD_CMDS
	$(MAKE) -C $(@D)
endef

# After installation, we fixup the INSTALL_PREFIX in qwtconfig.pri so
# that when building with qmake, -L$(STAGING_DIR)/usr/lib is used and
# not -L/usr/lib.
define QWT_INSTALL_STAGING_CMDS
	$(MAKE) -C $(@D) install INSTALL_ROOT=$(STAGING_DIR)
	$(SED) "s%QWT_INSTALL_PREFIX = .*%QWT_INSTALL_PREFIX = $(STAGING_DIR)/usr%" \
		$(STAGING_DIR)/usr/mkspecs/features/qwtconfig.pri
endef

define QWT_INSTALL_TARGET_CMDS
	$(MAKE) -C $(@D) install INSTALL_ROOT=$(TARGET_DIR)
	rm -Rf $(TARGET_DIR)/usr/mkspecs
endef

$(eval $(generic-package))
