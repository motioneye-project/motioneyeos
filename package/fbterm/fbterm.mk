################################################################################
#
# fbterm
#
################################################################################

FBTERM_VERSION = 1.7.0
FBTERM_SITE = http://fbterm.googlecode.com/files
FBTERM_LICENSE = GPLv2+
FBTERM_LICENSE_FILES = COPYING
FBTERM_DEPENDENCIES = fontconfig liberation

$(eval $(autotools-package))
