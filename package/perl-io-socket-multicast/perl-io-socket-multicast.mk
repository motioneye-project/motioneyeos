################################################################################
#
# perl-io-socket-multicast
#
################################################################################

PERL_IO_SOCKET_MULTICAST_VERSION = 1.12
PERL_IO_SOCKET_MULTICAST_SOURCE = IO-Socket-Multicast-$(PERL_IO_SOCKET_MULTICAST_VERSION).tar.gz
PERL_IO_SOCKET_MULTICAST_SITE = $(BR2_CPAN_MIRROR)/authors/id/B/BR/BRAMBLE
PERL_IO_SOCKET_MULTICAST_LICENSE = Artistic or GPL-1.0+
PERL_IO_SOCKET_MULTICAST_LICENSE_FILES = README
PERL_IO_SOCKET_MULTICAST_DISTNAME = IO-Socket-Multicast

$(eval $(perl-package))
