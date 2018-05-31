################################################################################
#
# libjpeg
#
################################################################################

LIBJPEG_VERSION = 9b
LIBJPEG_SITE = http://www.ijg.org/files
LIBJPEG_SOURCE = jpegsrc.v$(LIBJPEG_VERSION).tar.gz
LIBJPEG_LICENSE = IJG
LIBJPEG_LICENSE_FILES = README
LIBJPEG_INSTALL_STAGING = YES
LIBJPEG_PROVIDES = jpeg

define LIBJPEG_REMOVE_USELESS_TOOLS
	rm -f $(addprefix $(TARGET_DIR)/usr/bin/,cjpeg djpeg jpegtran rdjpgcom wrjpgcom)
endef

LIBJPEG_POST_INSTALL_TARGET_HOOKS += LIBJPEG_REMOVE_USELESS_TOOLS

define LIBJPEG_INSTALL_STAGING_PC
	$(INSTALL) -D -m 0644 package/libjpeg/libjpeg.pc.in \
		$(STAGING_DIR)/usr/lib/pkgconfig/libjpeg.pc
	version=`sed -e '/^PACKAGE_VERSION/!d;s/PACKAGE_VERSION = \(.*\)/\1/' $(@D)/Makefile` ; \
		$(SED) "s/@PACKAGE_VERSION@/$${version}/" $(STAGING_DIR)/usr/lib/pkgconfig/libjpeg.pc
endef

LIBJPEG_POST_INSTALL_STAGING_HOOKS += LIBJPEG_INSTALL_STAGING_PC

$(eval $(autotools-package))
$(eval $(host-autotools-package))
