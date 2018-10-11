################################################################################
#
# perl-extutils-installpaths
#
################################################################################

PERL_EXTUTILS_INSTALLPATHS_VERSION = 0.012
PERL_EXTUTILS_INSTALLPATHS_SOURCE = ExtUtils-InstallPaths-$(PERL_EXTUTILS_INSTALLPATHS_VERSION).tar.gz
PERL_EXTUTILS_INSTALLPATHS_SITE = $(BR2_CPAN_MIRROR)/authors/id/L/LE/LEONT
HOST_PERL_EXTUTILS_INSTALLPATHS_DEPENDENCIES = host-perl-extutils-config
PERL_EXTUTILS_INSTALLPATHS_LICENSE = Artistic or GPL-1.0+
PERL_EXTUTILS_INSTALLPATHS_LICENSE_FILES = LICENSE
PERL_EXTUTILS_INSTALLPATHS_DISTNAME = ExtUtils-InstallPaths

$(eval $(host-perl-package))
