################################################################################
#
# perl-mime-tools
#
################################################################################

PERL_MIME_TOOLS_VERSION = 5.509
PERL_MIME_TOOLS_SOURCE = MIME-tools-$(PERL_MIME_TOOLS_VERSION).tar.gz
PERL_MIME_TOOLS_SITE = $(BR2_CPAN_MIRROR)/authors/id/D/DS/DSKOLL
PERL_MIME_TOOLS_LICENSE = Artistic or GPL-1.0+
PERL_MIME_TOOLS_LICENSE_FILES = COPYING
PERL_MIME_TOOLS_DISTNAME = MIME-tools

$(eval $(perl-package))
