################################################################################
#
# perl-xml-namespacesupport
#
################################################################################

PERL_XML_NAMESPACESUPPORT_VERSION = 1.11
PERL_XML_NAMESPACESUPPORT_SOURCE = XML-NamespaceSupport-$(PERL_XML_NAMESPACESUPPORT_VERSION).tar.gz
PERL_XML_NAMESPACESUPPORT_SITE = $(BR2_CPAN_MIRROR)/authors/id/P/PE/PERIGRIN
PERL_XML_NAMESPACESUPPORT_LICENSE = Artistic or GPL-1.0+
PERL_XML_NAMESPACESUPPORT_LICENSE_FILES = README

$(eval $(perl-package))
