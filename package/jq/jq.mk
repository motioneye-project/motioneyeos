################################################################################
#
# jq
#
################################################################################

JQ_VERSION = jq-1.3
JQ_SITE = http://github.com/stedolan/jq/tarball/$(JQ_VERSION)
JQ_AUTORECONF = YES
JQ_DEPENDENCIES = host-flex host-bison
JQ_LICENSE = MIT (code), CC-BY-3.0 (documentation)
JQ_LICENSE_FILES = COPYING

# uses c99 specific features
JQ_CONF_ENV += CFLAGS="$(TARGET_CFLAGS) -std=c99"

$(eval $(autotools-package))
