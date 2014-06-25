################################################################################
#
# google-breakpad
#
################################################################################

GOOGLE_BREAKPAD_VERSION = 1320
GOOGLE_BREAKPAD_SITE = http://google-breakpad.googlecode.com/svn/trunk
GOOGLE_BREAKPAD_SITE_METHOD = svn
GOOGLE_BREAKPAD_CONF_OPT = --disable-processor --disable-tools
# Only a static library is installed
GOOGLE_BREAKPAD_INSTALL_TARGET = NO
GOOGLE_BREAKPAD_INSTALL_STAGING = YES
GOOGLE_BREAKPAD_LICENSE = BSD-3c
GOOGLE_BREAKPAD_LICENSE_FILES = LICENSE

$(eval $(autotools-package))
$(eval $(host-autotools-package))
