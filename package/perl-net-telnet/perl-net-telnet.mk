################################################################################
#
# perl-net-telnet
#
################################################################################

PERL_NET_TELNET_VERSION = 3.04
PERL_NET_TELNET_SOURCE = Net-Telnet-$(PERL_NET_TELNET_VERSION).tar.gz
PERL_NET_TELNET_SITE = $(BR2_CPAN_MIRROR)/authors/id/J/JR/JROGERS
PERL_NET_TELNET_LICENSE = Artistic or GPL-1.0+
PERL_NET_TELNET_LICENSE_FILES = README
PERL_NET_TELNET_DISTNAME = Net-Telnet

$(eval $(perl-package))
