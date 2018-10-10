################################################################################
#
# perl-class-method-modifiers
#
################################################################################

PERL_CLASS_METHOD_MODIFIERS_VERSION = 2.12
PERL_CLASS_METHOD_MODIFIERS_SOURCE = Class-Method-Modifiers-$(PERL_CLASS_METHOD_MODIFIERS_VERSION).tar.gz
PERL_CLASS_METHOD_MODIFIERS_SITE = $(BR2_CPAN_MIRROR)/authors/id/E/ET/ETHER
PERL_CLASS_METHOD_MODIFIERS_LICENSE = Artistic or GPL-1.0+
PERL_CLASS_METHOD_MODIFIERS_LICENSE_FILES = LICENSE

$(eval $(perl-package))
