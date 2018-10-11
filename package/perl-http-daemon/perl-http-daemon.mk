################################################################################
#
# perl-http-daemon
#
################################################################################

PERL_HTTP_DAEMON_VERSION = 6.01
PERL_HTTP_DAEMON_SOURCE = HTTP-Daemon-$(PERL_HTTP_DAEMON_VERSION).tar.gz
PERL_HTTP_DAEMON_SITE = $(BR2_CPAN_MIRROR)/authors/id/G/GA/GAAS
PERL_HTTP_DAEMON_LICENSE = Artistic or GPL-1.0+
PERL_HTTP_DAEMON_LICENSE_FILES = README
PERL_HTTP_DAEMON_DISTNAME = HTTP-Daemon

$(eval $(perl-package))
