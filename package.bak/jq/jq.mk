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
HOST_JQ_CONF_ENV += CFLAGS="$(HOST_CFLAGS) -std=c99"

# jq explicitly enables maintainer mode, which we don't need/want
JQ_CONF_OPTS += --disable-maintainer-mode
HOST_JQ_CONF_OPTS += --disable-maintainer-mode

$(eval $(autotools-package))
$(eval $(host-autotools-package))
