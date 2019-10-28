################################################################################
#
# perl-http-daemon
#
################################################################################

PERL_HTTP_DAEMON_VERSION = 6.06
PERL_HTTP_DAEMON_SOURCE = HTTP-Daemon-$(PERL_HTTP_DAEMON_VERSION).tar.gz
PERL_HTTP_DAEMON_SITE = $(BR2_CPAN_MIRROR)/authors/id/O/OA/OALDERS
PERL_HTTP_DAEMON_DEPENDENCIES = host-perl-module-build-tiny
PERL_HTTP_DAEMON_LICENSE = Artistic or GPL-1.0+
PERL_HTTP_DAEMON_LICENSE_FILES = LICENCE
PERL_HTTP_DAEMON_DISTNAME = HTTP-Daemon

$(eval $(perl-package))
