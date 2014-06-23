################################################################################
#
# perl-mojolicious
#
################################################################################

PERL_MOJOLICIOUS_VERSION = 5.08
PERL_MOJOLICIOUS_SOURCE = Mojolicious-$(PERL_MOJOLICIOUS_VERSION).tar.gz
PERL_MOJOLICIOUS_SITE = http://backpan.perl.org/authors/id/S/SR/SRI/
PERL_MOJOLICIOUS_DEPENDENCIES = perl
PERL_MOJOLICIOUS_LICENSE = Artistic-2.0
PERL_MOJOLICIOUS_LICENSE_FILES = LICENSE

$(eval $(perl-package))
