################################################################################
#
# libyaml
#
################################################################################

LIBYAML_VERSION = 0.1.4
LIBYAML_SOURCE = yaml-$(LIBYAML_VERSION).tar.gz
LIBYAML_SITE = http://pyyaml.org/download/libyaml/
LIBYAML_INSTALL_STAGING = YES

$(eval $(autotools-package))

