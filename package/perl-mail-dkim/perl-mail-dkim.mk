################################################################################
#
# perl-mail-dkim
#
################################################################################

PERL_MAIL_DKIM_VERSION = 0.40
PERL_MAIL_DKIM_SOURCE = Mail-DKIM-$(PERL_MAIL_DKIM_VERSION).tar.gz
PERL_MAIL_DKIM_SITE = $(BR2_CPAN_MIRROR)/authors/id/J/JA/JASLONG
PERL_MAIL_DKIM_DEPENDENCIES = perl-crypt-openssl-rsa perl-mailtools perl-net-dns
PERL_MAIL_DKIM_LICENSE_FILES = README

$(eval $(perl-package))
