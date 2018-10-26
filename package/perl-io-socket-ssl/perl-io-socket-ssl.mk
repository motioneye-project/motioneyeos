################################################################################
#
# perl-io-socket-ssl
#
################################################################################

PERL_IO_SOCKET_SSL_VERSION = 2.060
PERL_IO_SOCKET_SSL_SOURCE = IO-Socket-SSL-$(PERL_IO_SOCKET_SSL_VERSION).tar.gz
PERL_IO_SOCKET_SSL_SITE = $(BR2_CPAN_MIRROR)/authors/id/S/SU/SULLR
PERL_IO_SOCKET_SSL_LICENSE = Artistic or GPL-1.0+
PERL_IO_SOCKET_SSL_LICENSE_FILES = README
PERL_IO_SOCKET_SSL_DISTNAME = IO-Socket-SSL

$(eval $(perl-package))
