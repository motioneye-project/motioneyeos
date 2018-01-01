################################################################################
#
# perl-mailtools
#
################################################################################

PERL_MAILTOOLS_VERSION = 2.18
PERL_MAILTOOLS_SOURCE = MailTools-$(PERL_MAILTOOLS_VERSION).tar.gz
PERL_MAILTOOLS_SITE = $(BR2_CPAN_MIRROR)/authors/id/M/MA/MARKOV
PERL_MAILTOOLS_DEPENDENCIES = perl-timedate
PERL_MAILTOOLS_LICENSE = Artistic or GPL-1.0+
PERL_MAILTOOLS_LICENSE_FILES = README

$(eval $(perl-package))
