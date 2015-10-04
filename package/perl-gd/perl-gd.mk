################################################################################
#
# perl-gd
#
################################################################################

PERL_GD_VERSION = 2.53
PERL_GD_SOURCE = GD-$(PERL_GD_VERSION).tar.gz
PERL_GD_SITE = $(BR2_CPAN_MIRROR)/authors/id/L/LD/LDS
PERL_GD_DEPENDENCIES = perl zlib libpng freetype gd
PERL_GD_LICENSE = Artistic-2.0 or GPLv1+
PERL_GD_LICENSE_FILES = LICENSE

PERL_GD_CONF_OPTS = \
	-options=FT,PNG \
	-lib_gd_path=$(STAGING_DIR)/usr \
	-lib_ft_path=$(STAGING_DIR)/usr \
	-lib_png_path=$(STAGING_DIR)/usr \
	-lib_zlib_path=$(STAGING_DIR)/usr \
	-ignore_missing_gd \
	-gdlib=$(STAGING_DIR)/usr/bin/gdlib-config

$(eval $(perl-package))
