################################################################################
#
# perl-stream-buffered
#
################################################################################

PERL_STREAM_BUFFERED_VERSION = 0.03
PERL_STREAM_BUFFERED_SOURCE = Stream-Buffered-$(PERL_STREAM_BUFFERED_VERSION).tar.gz
PERL_STREAM_BUFFERED_SITE = $(BR2_CPAN_MIRROR)/authors/id/D/DO/DOY
PERL_STREAM_BUFFERED_LICENSE = Artistic or GPL-1.0+
PERL_STREAM_BUFFERED_LICENSE_FILES = LICENSE
PERL_STREAM_BUFFERED_DISTNAME = Stream-Buffered

$(eval $(perl-package))
