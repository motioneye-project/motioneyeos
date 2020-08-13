################################################################################
#
# libyaml
#
################################################################################

LIBYAML_VERSION = 0.2.2
LIBYAML_SOURCE = yaml-$(LIBYAML_VERSION).tar.gz
LIBYAML_SITE = http://pyyaml.org/download/libyaml
LIBYAML_INSTALL_STAGING = YES
LIBYAML_LICENSE = MIT
LIBYAML_LICENSE_FILES = LICENSE

$(eval $(autotools-package))
$(eval $(host-autotools-package))
