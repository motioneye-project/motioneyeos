################################################################################
#
# perl-net-ssh2
#
################################################################################

PERL_NET_SSH2_VERSION = 0.69
PERL_NET_SSH2_SOURCE = Net-SSH2-$(PERL_NET_SSH2_VERSION).tar.gz
PERL_NET_SSH2_SITE = $(BR2_CPAN_MIRROR)/authors/id/S/SA/SALVA
PERL_NET_SSH2_LICENSE = Artistic or GPL-1.0+
PERL_NET_SSH2_LICENSE_FILES = README
PERL_NET_SSH2_DEPENDENCIES = libssh2

$(eval $(perl-package))
