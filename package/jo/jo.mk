################################################################################
#
# jo
#
################################################################################

JO_VERSION = 1.3
JO_SITE = https://github.com/jpmens/jo/releases/download/$(JO_VERSION)
JO_LICENSE = MIT (json.[ch]), GPL-2.0+ (rest)
JO_LICENSE_FILES = COPYING
# don't build man pages
JO_CONF_ENV = ac_cv_path_PANDOC=''

$(eval $(autotools-package))
