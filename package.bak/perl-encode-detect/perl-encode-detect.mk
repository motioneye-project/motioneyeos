################################################################################
#
# perl-encode-detect
#
################################################################################

PERL_ENCODE_DETECT_VERSION = 1.01
PERL_ENCODE_DETECT_SOURCE = Encode-Detect-$(PERL_ENCODE_DETECT_VERSION).tar.gz
PERL_ENCODE_DETECT_SITE = $(BR2_CPAN_MIRROR)/authors/id/J/JG/JGMYERS
PERL_ENCODE_DETECT_DEPENDENCIES = host-perl-module-build
PERL_ENCODE_DETECT_LICENSE = MPL-1.1
PERL_ENCODE_DETECT_LICENSE_FILES = LICENSE

$(eval $(perl-package))
