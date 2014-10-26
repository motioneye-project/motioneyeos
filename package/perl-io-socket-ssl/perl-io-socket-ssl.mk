################################################################################
#
# perl-io-socket-ssl
#
################################################################################

PERL_IO_SOCKET_SSL_VERSION = 2.002
PERL_IO_SOCKET_SSL_SOURCE = IO-Socket-SSL-$(PERL_IO_SOCKET_SSL_VERSION).tar.gz
PERL_IO_SOCKET_SSL_SITE = $(BR2_CPAN_MIRROR)/authors/id/S/SU/SULLR
PERL_IO_SOCKET_SSL_DEPENDENCIES = perl perl-net-ssleay
PERL_IO_SOCKET_SSL_LICENSE = Artistic or GPLv1+

$(eval $(perl-package))
