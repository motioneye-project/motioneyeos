################################################################################
#
# perl-gd
#
################################################################################

PERL_GD_VERSION = 2.69
PERL_GD_SOURCE = GD-$(PERL_GD_VERSION).tar.gz
PERL_GD_SITE = $(BR2_CPAN_MIRROR)/authors/id/R/RU/RURBAN
PERL_GD_DEPENDENCIES = zlib libpng freetype gd
PERL_GD_LICENSE = Artistic or GPL-1.0+
PERL_GD_LICENSE_FILES = LICENSE
PERL_GD_DISTNAME = GD

PERL_GD_CONF_OPTS = \
	-lib_gd_path=$(STAGING_DIR)/usr \
	-lib_ft_path=$(STAGING_DIR)/usr \
	-lib_png_path=$(STAGING_DIR)/usr \
	-lib_zlib_path=$(STAGING_DIR)/usr \
	-gdlib_config_path=$(STAGING_DIR)/usr/bin

$(eval $(perl-package))
