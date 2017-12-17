################################################################################
#
# perl-mime-base64
#
################################################################################

PERL_MIME_BASE64_VERSION = 3.15
PERL_MIME_BASE64_SOURCE = MIME-Base64-$(PERL_MIME_BASE64_VERSION).tar.gz
PERL_MIME_BASE64_SITE = $(BR2_CPAN_MIRROR)/authors/id/G/GA/GAAS
PERL_MIME_BASE64_LICENSE = Artistic or GPLv1+
PERL_MIME_BASE64_LICENSE_FILES = README

$(eval $(perl-package))
