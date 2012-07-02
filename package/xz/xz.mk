#############################################################
#
# xz-utils
#
#############################################################
XZ_VERSION = 5.0.3
XZ_SOURCE = xz-$(XZ_VERSION).tar.bz2
XZ_SITE = http://tukaani.org/xz/
XZ_INSTALL_STAGING = YES
XZ_CONF_ENV = ac_cv_prog_cc_c99='-std=gnu99'

$(eval $(autotools-package))
$(eval $(host-autotools-package))
