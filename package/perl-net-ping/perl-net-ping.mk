################################################################################
#
# perl-net-ping
#
################################################################################

PERL_NET_PING_VERSION = 2.71
PERL_NET_PING_SOURCE = Net-Ping-$(PERL_NET_PING_VERSION).tar.gz
PERL_NET_PING_SITE = $(BR2_CPAN_MIRROR)/authors/id/R/RU/RURBAN
PERL_NET_PING_LICENSE = Artistic or GPL-1.0+
PERL_NET_PING_LICENSE_FILES = README
PERL_NET_PING_DISTNAME = Net-Ping

$(eval $(perl-package))
