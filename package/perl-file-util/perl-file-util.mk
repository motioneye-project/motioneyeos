################################################################################
#
# perl-file-util
#
################################################################################

PERL_FILE_UTIL_VERSION = 4.132140
PERL_FILE_UTIL_SOURCE = File-Util-$(PERL_FILE_UTIL_VERSION).tar.gz
PERL_FILE_UTIL_SITE = $(BR2_CPAN_MIRROR)/authors/id/T/TO/TOMMY
PERL_FILE_UTIL_DEPENDENCIES = perl host-perl-module-build
PERL_FILE_UTIL_LICENSE = Artistic or GPLv1+
PERL_FILE_UTIL_LICENSE_FILES = COPYING LICENSE

$(eval $(perl-package))
$(eval $(host-perl-package))
