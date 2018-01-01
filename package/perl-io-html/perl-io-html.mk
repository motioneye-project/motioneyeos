################################################################################
#
# perl-io-html
#
################################################################################

PERL_IO_HTML_VERSION = 1.001
PERL_IO_HTML_SOURCE = IO-HTML-$(PERL_IO_HTML_VERSION).tar.gz
PERL_IO_HTML_SITE = $(BR2_CPAN_MIRROR)/authors/id/C/CJ/CJM
PERL_IO_HTML_LICENSE = Artistic or GPL-1.0+
PERL_IO_HTML_LICENSE_FILES = LICENSE

$(eval $(perl-package))
