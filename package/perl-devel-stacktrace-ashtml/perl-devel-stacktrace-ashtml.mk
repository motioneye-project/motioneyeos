################################################################################
#
# perl-devel-stacktrace-ashtml
#
################################################################################

PERL_DEVEL_STACKTRACE_ASHTML_VERSION = 0.15
PERL_DEVEL_STACKTRACE_ASHTML_SOURCE = Devel-StackTrace-AsHTML-$(PERL_DEVEL_STACKTRACE_ASHTML_VERSION).tar.gz
PERL_DEVEL_STACKTRACE_ASHTML_SITE = $(BR2_CPAN_MIRROR)/authors/id/M/MI/MIYAGAWA
PERL_DEVEL_STACKTRACE_ASHTML_LICENSE = Artistic or GPL-1.0+
PERL_DEVEL_STACKTRACE_ASHTML_LICENSE_FILES = LICENSE
PERL_DEVEL_STACKTRACE_ASHTML_DISTNAME = Devel-StackTrace-AsHTML

$(eval $(perl-package))
