################################################################################
#
# perl-lwp-protocol-https
#
################################################################################

PERL_LWP_PROTOCOL_HTTPS_VERSION = 6.07
PERL_LWP_PROTOCOL_HTTPS_SOURCE = LWP-Protocol-https-$(PERL_LWP_PROTOCOL_HTTPS_VERSION).tar.gz
PERL_LWP_PROTOCOL_HTTPS_SITE = $(BR2_CPAN_MIRROR)/authors/id/O/OA/OALDERS
PERL_LWP_PROTOCOL_HTTPS_LICENSE = Artistic or GPL-1.0+
PERL_LWP_PROTOCOL_HTTPS_LICENSE_FILES = README
PERL_LWP_PROTOCOL_HTTPS_DISTNAME = LWP-Protocol-https

$(eval $(perl-package))
