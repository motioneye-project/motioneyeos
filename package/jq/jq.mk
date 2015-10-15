################################################################################
#
# jq
#
################################################################################

JQ_VERSION = 1.5
JQ_SITE = https://github.com/stedolan/jq/releases/download/jq-$(JQ_VERSION)
JQ_LICENSE = MIT (code), CC-BY-3.0 (documentation)
JQ_LICENSE_FILES = COPYING

# uses c99 specific features
JQ_CONF_ENV += CFLAGS="$(TARGET_CFLAGS) -std=c99"

$(eval $(autotools-package))
