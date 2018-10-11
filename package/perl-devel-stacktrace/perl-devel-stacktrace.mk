################################################################################
#
# perl-devel-stacktrace
#
################################################################################

PERL_DEVEL_STACKTRACE_VERSION = 2.03
PERL_DEVEL_STACKTRACE_SOURCE = Devel-StackTrace-$(PERL_DEVEL_STACKTRACE_VERSION).tar.gz
PERL_DEVEL_STACKTRACE_SITE = $(BR2_CPAN_MIRROR)/authors/id/D/DR/DROLSKY
PERL_DEVEL_STACKTRACE_LICENSE = Artistic-2.0
PERL_DEVEL_STACKTRACE_LICENSE_FILES = LICENSE
PERL_DEVEL_STACKTRACE_DISTNAME = Devel-StackTrace

$(eval $(perl-package))
